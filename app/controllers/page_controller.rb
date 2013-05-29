class  PageController < ApplicationController

  $recibeDisp = false

  #Se encarga de iniciar una sesion como jefe de consulta externa, teniendo como
  # validacion para ingreso la contraseña insertada
  def admin_page

    @est1='No hay citas'
    @est2='No hay citas'
    @est3='No hay citas'

    if session[:usuario] == nil
      password=params[:pass]
      @entro=false
      @msg=''

      if password.to_s == 'admin'  then
        @entro=true
        session[:usuario]='jce'
        puts("Sesion iniciada como admin")
        if(!Appointment.all.empty?)
          app= Appointment.order(:office)
          actual=app.first
          maxApp=app.first
          maxAct=0
          i=0
          app.each do |ap|
            if actual[:office]==ap[:office]then
              i=i+1
            else
              if i>maxAct
                maxAct=i
                maxApp=actual
              end
              i=1
              actual=ap
            end

          end
          @est1="Consultorio " + maxApp[:office].to_s
          puts  "EST 1 " +  @est1

          app= Appointment.order(:pID_doctor)
          actualDoc=Doctor.where(:pID=>app.first[:pID_doctor]).first
          actual=actualDoc[:specialty]
          maxApp=actual
          maxAct=0
          i=0
          app.each do |ap|
            specDoc= Doctor.where(:pID=>ap[:pID_doctor]).first
            spec=specDoc[:specialty]
            if actual==spec
              i=i+1
            else
              if i>maxAct
                maxAct=i
                maxApp=actual
              end
              i=1
              actual=spec
            end

          end
          @est2="Especialidad " + maxApp.to_s
          puts  "EST 2 " +  @est2

          app= Appointment.order(:day)
          actual=app.first
          maxApp=app.first
          maxAct=0
          i=0
          app.each do |ap|
            if actual[:day]==ap[:day]then
              i=i+1
            else
              if i>maxAct
                maxAct=i
                maxApp=actual
              end
              i=1
              actual=ap
            end

          end
          @est3="Fecha " + maxApp[:day].to_s
          puts  "EST 3 " +  @est3

        end


      else
        @msg='La clave ingresada no es correcta'
      end
    end
  end

  def admin_offices
    @oficinas = Office.all
    @recDisp = $recibeDisp
  end

  # El administrador, o jefe de consulta externa genera las citas para el mes
  #acorde con la disponibilidad de medicos y consultorios  y la especialidad de
  #cada uno del ellos
  def admin_generate
    o=Office.all
    @i=0
    @j=0
    o.each do |office|
      disp = OfficeAvailability.where(:location => office[:location])
      disp.each do |d|
        doc= Doctor.where(:specialty => office[:specialty]).order(:appo)
        doc.each do |dc|

          diso= DoctorAvailability.where(:pID_doctor => dc[:pID],:day => d[:day],:hour=>d[:hour],:checked => false)
          dispo=diso.first
          if(!diso.empty?)
            if(Appointment.where(:pID_doctor => dc[:pID],:office=>office[:location],:day => dispo[:day],:hour=>dispo[:hour]).empty?)
            dispo.checked=true
            dispo.save!
            appo=Appointment.create(:pID_doctor=>dc[:pID],:office=>office[:location],:day=>dispo[:day],:hour=>dispo[:hour])

            puts "=========CITA: "+appo.pID_doctor+" "+appo.office+" "+appo.day.to_s+" "+appo.hour.to_s+"========================"
            puts "Errores: "+appo.errors[:base].any?.to_s
            puts "salvo: "+appo.save!.to_s


            ap=dc[:appo]
            ad=ap+1
            dc.assign_attributes(:appo=>ad)
            dc.save
            @j=@j+1
            break
          else
            puts "Cita repetida"
          end

        else
          puts "No hay Disponibilidades ////////////////////"
        end

      end
     end

      @i= @i+1
   end
    $recibeDisp = false
  end

  #Ingresa a una sesion como paciente, dando su nombre y cedula
  def pat_page
    nombre = params[:name]
    cedula = params[:pID]
    pat = Patient.where(:name => nombre, :pID => cedula).first
    if pat != nil then
      session[:usuario]='pat'
      session[:nombre]=nombre
      session[:cedula]=cedula
      @msg = "Bienvenido, "+session[:nombre]
    end
  end

  #entra a la sesion del medico, el cual pasa su nombre y cedula
  def doc_page
    nombre = params[:name]
    cedula= params[:pID]
    doc= Doctor.where(:name => nombre, :pID => cedula).first
    if doc!=nil
      session[:usuario]='doc'
      session[:nombre]=nombre
      session[:cedula]=cedula
    end

    @recDisp = $recibeDisp
    @citas = Appointment.where(:pID_doctor => session[:cedula]).where("pID_patient IS NOT NULL").order(:day)
    puts "__________________________________________________________Numero de citas encontradas:"+@citas.size.to_s
  end

  #cancela la cita del doctor, mas detalles en los comentarios al interior
  def doc_cancelar
    cd = params[:cedPat]
    hr = params[:hora]
    da = params[:dia]
    cita = Appointment.where(:pID_patient => cd, :hour => hr.to_time, :pID_doctor => session[:cedula], :day => da).first

    #1. Se pierde la availability del doctor
    availability = DoctorAvailability.where(:pID_doctor => session[:cedula], :hour => hr.to_time, :day => da).first
    availability.delete

    #2 Se busca un reemplazo para la cita
    newAvReempl = DoctorAvailability.where(:hour => hr.to_time, :day => da, :checked => false).first
    if newAvReempl != nil
      idReempl=newAvReempl[:pID_doctor]
    else
      idReempl=nil
    end

    #3 Si existe reemplazo, lo agrega al appointment. Si no hay reemplazo, la cita se pierde.
    @msj = ''
    if idReempl != nil
      cita[:pID_doctor] = idReempl
      guardo = cita.save
      if guardo
        @msj = "Hay Reemplazo!"
      else
        @msj = "Hay reemplazo pero no se puedo guardar. Errores:"
        cita.errors.each {|key,value| @msj=@msj+"#{key} = #{value}"}
      end
      puts @msj
    else
      cita.delete
      @msj = "No hay reemplazo :("
      puts @msj
    end
  end

  #cancela una cita del paciente, la cita queda simplemente sin paciente
  def pat_cancelar
    cd = params[:cedDoctor]
    hr = params[:hora]
    da = params[:dia]
    @cancelada = false
    cita = Appointment.where(:pID_doctor => cd, :hour => hr.to_time, :pID_patient => session[:cedula], :day => da).first
    if(cita != nil)
      cita.pID_patient = nil
      cita.save
      @cancelada = true
    end

  end

  #el paciente al momento de hacerse a una cita debe poder elegir la especialidad
  #para la cual requiere la cita
  def pat_selEsp
    @pat = Patient.where(:pID => session[:cedula]).first
    @especialidades = []
    i = 0
    Doctor.all.each do |doc|
      temp = doc[:specialty]
      puts "/////////////////////////SPEC "+ temp
      existe = false
      @especialidades.each do |e|
        existe = true if (e == temp)
      end
      if(!existe && temp != "")then
        @especialidades[i] = temp
        i = i+1
      end
    end
    puts "////////////////////////ESPECIALIDADES"
    @especialidades.each do |e|
      puts e
    end
  end

  def pat_selCita
    spec = params[:espec]
    puts "Especialidad: "+spec
    @citas = []

    if Doctor.where(:specialty => spec).empty?
      puts "No hay doctores con la especialidad '"+spec+"'"
    else
      puts "Si hay doctores con la especialidad '"+spec+"'"
    end
    i = 0
    Doctor.where(:specialty => spec).each do |doc|
      if Appointment.where(:pID_doctor => doc[:pID], :pID_patient => nil).empty?
        puts "No hay citas con el pID_doctor '"+doc[:pID]+"'"
      else
        puts "Si hay citas con el pID_doctor '"+doc[:pID]+"'"
      end
      Appointment.where(:pID_doctor => doc[:pID], :pID_patient => nil).each do |cit|
        @citas[i] = cit
        i=i+1
      end
    end

  end

  # se reserva una cita para el paciente con la hora, fecha y medico seleccinados
  def pat_reser
    dia = params[:dia]
    hura = params[:hora]
    doci = params[:doc]

    @reservada = false

    appoi = Appointment.where(:day => dia, :hour => hura.to_time, :pID_doctor => doci).first
    if(appoi[:pID_patient] == nil)then
      appoi[:pID_patient] = session[:cedula]
      appoi.errors.each {|key,value| puts "#{key} = #{value}"} if appoi.invalid?
      appoi.save
      @reservada = true if Appointment.where(:day => dia, :hour => hura.to_time, :pID_doctor => doci).first[:pID_patient] != nil
    end

  end

  #se generan las citas correspondientes para un doctor siempre y cuando no haya
  #alguna reservada previamente en el horario
  def doc_resp_availability
    @pudo=false
    @msj=''
    hash= params["show"]
    month= hash["date(2i)"]
    day=hash["date(3i)"]
    year=hash["date(1i)"]

    date=Date.new(year.to_i,month.to_i,day.to_i)
    hash_time_i= params["event"]
    hourI=hash_time_i["timeI(4i)"]
    minI=hash_time_i["timeI(5i)"]
    hourF=hash_time_i["timeF(4i)"]
    minF=hash_time_i["time(5i)"]
    @pID=session[:cedula]

    timeI= Time.new(2000,10,31,hourI.to_i-5,minI.to_i)
    timeF= Time.new(2000,10,31,hourF.to_i-5,minF.to_i)

    timeT = timeF-timeI

    if minI.to_i%30!=0 || minF.to_i%30!=0
      @msj='Debe ingresar horas con minutos 30 o 00'
      puts @msj

    elsif date<Date.today
      @msj='Debe ingresar una fecha futura'
      puts @msj

    elsif timeF<timeI && (timeT.min.to_i=0 || timeT.min.to_i=30)
      @msj='La hora inicial debe ser mayor que la final por media hora'
      puts @msj

    elsif date.month != Date.today.month+1
      @msj='El mes debe ser el imediatamente siguiente [ mes numero '+Date.today.month+1.to_s+']'
      puts @msj
    else
      @i=0
      @entro=true
      inicio_cita = timeI
      check=false
      while inicio_cita < timeF

        if DoctorAvailability.where(:day => date,:pID_doctor => session[:cedula],:hour => inicio_cita).empty?

          ava = DoctorAvailability.new(:hour => inicio_cita,:day => date,:pID_doctor =>session[:cedula], :checked=>check)
          ava.save
          @i=@i+1

        end
        inicio_cita = inicio_cita +(30*60)
      end


    end
  end

  def prueba

  end

  #cierra la sesion del usuario
  def logout
    reset_session
  end

  #se agrega una disponibilidad a un medicoy generan los espacios de citas
  def doc_add_availability
    @doc_pid = params[:pID_doc]
    #dia = params[:day]
    #inicio = params[:start]
    #fin = params[:end]

    #doc = Doctor.where(:pID => session[:cedula]).first
    #if doc != nil
    #  doc.add_availabilities(dia, inicio, fin)
    #  doc.generate_appointments
    #end

  end

  #el paciente se registra mediante el sistema de citas, pasando su nombre, cedula y contrasenia
  def pat_create

    @creo = false
    pati = Patient.new(:name => params[:name], :pID =>params[:cedula])

    puts pati[:name]
    puts pati[:pID]
    if Patient.where(:pID => pati[:pID]).first == nil
      #pat.errors.each {|key,value| puts "#{key} = #{value}"} if pat.invalid?
      #puts "Valid Patient" if pat.valid?
      pati.save
      @creo = !Patient.where(:pID => pati[:pID]).first.nil?
      puts "Creo = "+@creo.to_s
    end

  end

  def admin_insDoc
    @especialidades=dar_especialidades
  end

  #el administrador puede registrar un nuevo medico dando nombre, cedula y especialidad del mismo
  def admin_addDoc
    @creo = false
    doc = Doctor.new(:name => params[:name], :pID => params[:id], :specialty => params[:specialty], :appo => 0)

    puts doc[:name]
    puts doc[:pID]
    puts doc[:specialty]
    puts("invalido") if doc.invalid?
    puts("valido") if !doc.invalid?
    doc.errors.each {|key,value| puts "#{key} = #{value}"} if doc.invalid?
    if Doctor.where(:pID => doc[:pID]).first == nil
      @creo = doc.save
     # @creo = !Doctor.where(:pID => doc[:pID]).first.nil?
      puts "Creo = "+@creo.to_s
    end
  end

  def admin_insCons
    @especialidades =  dar_especialidades
  end

  #el jefe de consulta externa puede inscribir nuevos consultorios con especialidades definidas
  def admin_addCons
    @creo = false
    s=nil
    if params[:espec] != nil and params[:espec] != ""
      s=params[:espec]
      puts "Drop down escojida. Valor: "+s
    elsif params[:specialty] != nil and params[:specialty] != ""
      s=params[:specialty]
      puts "Text field escojido. Valor: "+s
    else
      puts "ninguno escojido"
    end
    off = Office.new(:specialty => s, :location => params[:location])

    puts off[:location]
    puts off[:specialty]
    if Office.where(:location => off[:location]).first == nil
      @creo = off.save
      off.errors.each {|key,value| puts "#{key} = #{value}"} if off.invalid?
      #@creo = !Office.where(:location => off[:location]).first.nil?
      puts "Creo = "+@creo.to_s
    end

  end

  def admin_endMonth
    @findemes = false
    @terminado = false
    d = Date.today
    if d.day==d.end_of_month.day
      @findemes= true
      # implementar el guardado de los datos históricos en un txt y calcular:
      # consultorio con mas citas
      # doctor con mas citas
      # especialidad mas comun
      OfficeAvailability.delete_all
      DoctorAvailability.delete_all
      @terminado = Appointment.delete_all
      $recibeDisp = true
    end
  end

  def dar_especialidades
    sp = []
    i = 0
    Office.all.each do |ofi|
      specTemp = ofi[:specialty]
      esta = false
      sp.each do |s|
        esta = true if s == specTemp
      end
      if !esta
        sp[i]= specTemp
        i=i+1
      end
    end
    return sp
  end

  def admin_addOfficeDisp
    @location=params[:location]
    @day=[ "Lunes","Martes","Miercoles","Jueves ","Viernes","Sabado"]
  end

  def admin_resp_availability
    date=Date.today+1
    puts "_____________________________Fecha inicial: "+date.to_s
    day=params[:day_of_the_week]
    location=params[:location]

    @i=0

    hash_time_i= params["event"]
    hourI=hash_time_i["timeI(4i)"]
    minI=hash_time_i["timeI(5i)"]
    hourF=hash_time_i["timeF(4i)"]
    minF=hash_time_i["time(5i)"]

    timeI= Time.new(2000,10,31,hourI.to_i-5,minI.to_i)
    timeF= Time.new(2000,10,31,hourF.to_i-5,minF.to_i)

    encontro = false
    while date.month==(Date.today>>1).month
      if day=='Lunes'
         if date.monday?
           encontro = true
           puts "----1-----"
           inicio_cita = timeI
           while inicio_cita < timeF

             if OfficeAvailability.where(:day => date,:location=>location,:hour => inicio_cita).empty?

               ava = OfficeAvailability.new(:day => date,:location=>location,:hour => inicio_cita)
               ava.save!
               @i=@i+1
             end
             inicio_cita = inicio_cita +(30*60)
          end
         end
      end

      if day=='Martes'
        if date.tuesday?
          encontro = true
          puts "----2-----"
          inicio_cita = timeI
          while inicio_cita < timeF

            if OfficeAvailability.where(:day => date,:location=>location,:hour => inicio_cita).empty?

              ava = OfficeAvailability.new(:day => date,:location=>location,:hour => inicio_cita)
              ava.save!
              @i=@i+1
            end
            inicio_cita = inicio_cita +(30*60)
          end
        end
       end
      if day=='Miercoles'
        if date.wednesday?
          encontro = true
          puts "----3-----"
          inicio_cita = timeI
          while inicio_cita < timeF

            if OfficeAvailability.where(:day => date,:location=>location,:hour => inicio_cita).empty?

              ava = OfficeAvailability.new(:day => date,:location=>location,:hour => inicio_cita)
              ava.save!
              @i=@i+1
            end
            inicio_cita = inicio_cita +(30*60)
          end
        end
      end
      if day=='Jueves'
        if date.thursday?
          encontro = true
          puts "----4-----"
          inicio_cita = timeI
          while inicio_cita < timeF

            if OfficeAvailability.where(:day => date,:location=>location,:hour => inicio_cita).empty?

              ava = OfficeAvailability.new(:day => date,:location=>location,:hour => inicio_cita)
              ava.save!
              @i=@i+1
            end
            inicio_cita = inicio_cita +(30*60)
          end
        end
      end

      if day=='Viernes'
        if date.friday?
          encontro = true
          puts "----5-----"
          inicio_cita = timeI
          while inicio_cita < timeF

            if OfficeAvailability.where(:day => date,:location=>location,:hour => inicio_cita).empty?

              ava = OfficeAvailability.new(:day => date,:location=>location,:hour => inicio_cita)
              ava.save!
              @i=@i+1
            end
            inicio_cita = inicio_cita +(30*60)
          end
        end
      end
      if day=='Sabado'
        if date.saturday?
          encontro = true
          puts "----6-----"
          inicio_cita = timeI
          while inicio_cita < timeF

            if OfficeAvailability.where(:day => date,:location=>location,:hour => inicio_cita).empty?

              ava = OfficeAvailability.new(:day => date,:location=>location,:hour => inicio_cita)
              ava.save!
              @i=@i+1
            end
            inicio_cita = inicio_cita +(30*60)
          end
        end
      end

      if encontro
        date += 7
      else
        date += 1
      end

    end
  end

end








