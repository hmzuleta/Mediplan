class Patient < ActiveRecord::Base

  #un paciente tiene nombre, cedula y contraseña, los cuales son los datos utolozados al interactuaar con el sistema
  #ademas de poder tener varias citas a su nombre
  #NO ESCRIBIR ACCESOR

  attr_accessible :name, :pID, :IDType , :sex, :maritalStatus, :bPlace, :bDay, :address, :tel1, :tel2, :email, :occup, :empresaRemit, :numContratoPol, :responsable, :telResponsable,
                  :antecedentesFam, :antecedentesPers
  has_many :appointments
  has_many :controls
  validates_presence_of :name, :pID, :IDType , :sex, :maritalStatus, :bPlace, :bDay, :address, :tel1, :tel2, :occup, :antecedentesFam, :antecedentesPers
  validates :pID, :uniqueness => true
end
