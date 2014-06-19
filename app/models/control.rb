class Control < ActiveRecord::Base

  #un paciente tiene nombre, cedula y contraseña, los cuales son los datos utolozados al interactuaar con el sistema
  #ademas de poder tener varias citas a su nombre
  #NO ESCRIBIR ACCESOR

  attr_accessible :pID, :fecha, :hora, :motivo, :diagnosticoAct, :antecedentesFam, :antecedentesPers, :peso, :tensionArt, :esPrimeraVez, :nomAcomp, :tel1Acomp, :tel2Acomp, :parentesco
  validates_presence_of :pID, :fecha, :hora, :motivo, :diagnosticoAct, :antecedentesFam, :antecedentesPers, :peso, :tensionArt, :esPrimeraVez
end
