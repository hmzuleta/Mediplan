class  PageController < ApplicationController

  $recibeDisp = false

  ################################################
  # METODOS ADMIN
  ################################################

  #Se encarga de iniciar una sesion como jefe de consulta externa, teniendo como
  # validacion para ingreso la contraseña insertada
  def admin_page

    @est3='No hay citas'

    if session[:usuario] == nil
      password=params[:pw]
      @entro=false
      @msg=''
      ad = Admin.where(:pID=>params[:pID], :pw => password).first
      if ad != nil  then
        @entro=true
        session[:usuario]='admin'
        puts("Sesion iniciada como Administrador")
        if(!Appointment.all.empty?)
          app= Appointment.order(:day)
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

  #el administrador puede registrar un nuevo medico dando nombre, cedula y especialidad del mismo
  def admin_addDoc
    @creo = false
    doc = Doctor.new(:name => params[:name], :pID => params[:id], :pw=> params[:pw])

    puts doc[:name]
    puts doc[:pID]
    puts doc[:pw]
    puts("invalido") if doc.invalid?
    puts("valido") if !doc.invalid?
    doc.errors.each {|key,value| puts "#{key} = #{value}"} if doc.invalid?
    if Doctor.where(:pID => doc[:pID]).first == nil #solo existe un medico con esa cedula
      @creo = doc.save
      # @creo = !Doctor.where(:pID => doc[:pID]).first.nil?
      puts "Se agrego el doctor = "+@creo.to_s+" al sistema."
    end
  end

  def admin_changePW
    @cambio = false
    ad = Admin.where(:pID=>session[:pID]).first
    if ad != nil
      if ad.pw == params[:old] and params[:new]==params[:newConf] then
        ad.pw = params[:newConf]
        ad.save
        @cambio = true
      end
    end
  end


  ################################################
  # METODOS PACIENTE
  ################################################


  #Ingresa a una sesion como paciente, dando su nombre y cedula
  def pat_page
    cedula = params[:pID]
    puts
    pat = Patient.where(:pID => cedula).first
    if pat != nil then
      session[:usuario]='pat'
      session[:nombre]=pat.name
      puts pat.nil?
      session[:cedula]=cedula
      @msg = "Paciente "+session[:nombre]
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

  def pat_selCita #TODO
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


  ################################################
  # METODOS MEDICO
  ################################################

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

  #cancela la cita del doctor
  def doc_cancelar
    cd = params[:cedPat]
    hr = params[:hora]
    da = params[:dia]
    cita = Appointment.where(:pID_patient => cd, :hour => hr.to_time, :pID_doctor => session[:cedula], :day => da).first
    if(cita != nil)
      cita.pID_patient = nil
      cita.save
      @cancelada = true
    end
  end

  def doc_changePW
    @cambio = false
    ad = Admin.where(:pID=>session[:pID]).first
    if ad != nil
      if ad.pw == params[:old] and params[:new]==params[:newConf] then
        ad.pw = params[:newConf]
        ad.save
        @cambio = true
      end
    end
  end

  #el paciente se registra mediante el sistema de citas, pasando su nombre, cedula y contrasenia
  def pat_create
    @creo = false
    pati = Patient.new(:name => params[:name], :pID =>params[:cedula], :IDType=>params[:IDType], :sex=>params[:sex],
      :maritalStatus=>params[:maritalStatus], :bPlace=>params[:bPlace], :bDay=>params[:bDay], :address=>params[:address], :tel1=>params[:tel1], :tel2=>params[:tel2],
      :email=>params[:email], :occup=>params[:occup], :empresaRemit=>params[:empresaRemit], :numContratoPol=>params[:numContratoPol], :responsable=>params[:responsable],
      :telResponsable=>params[:telResponsable], :antecedentesFam=>params[:antecedentesFam], :antecedentesPers=>params[:antecedentesPers])

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

  def pat_view
    @pat = Patient.where(:pID=>params[:patID])
  end

  def control_create
    @creo = false
    con = Control.new(:pID=> params[:pID], :day=> params[:day], :hora=> params[:hora], :motivo=> params[:motivo], :diagnosticoAct=> params[:diagnosticoAct],
                      :peso=> params[:peso], :tensionArt=> params[:tensionArt], :esPrimeraVez=> params[:esPrimeraVez], :nomAcomp=> params[:nomAcomp],
                      :tel1Acomp=> params[:tel1Acomp], :tel2Acomp=> params[:tel2Acomp], :parentesco=> params[:parentesco])
    con.save
    @creo = true
  end


  def citas_dia
    @aps = Appointment.where(:day=> params[:day])
  end


  ################################################
  # METODOS TODOS LOS USUARIOS
  ################################################

  #cierra la sesion del usuario
  def logout
    reset_session
  end


end








