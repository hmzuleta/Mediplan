class Patient < ActiveRecord::Base

  #un paciente tiene nombre, cedula y contraseña, los cuales son los datos utolozados al interactuaar con el sistema
  #ademas de poder tener varias citas a su nombre
  #NO ESCRIBIR ACCESOR

  attr_accessible :name, :pID
  has_many :appointments
  validates_presence_of :name
  validates :name, :format => {:with=> /^[a-zA-Z\s\D]+$/}
  validates :pID, :presence => true,
                  :numericality => { :only_integer => true,
                                     :greater_than_or_equal_to => 100000,
                                     :less_than_or_equal_to => 9999999999 },
                  :uniqueness => true
end
