class Doctor < ActiveRecord::Base

  #un doctor tiene nombre, cedula y especialidad
  attr_accessible :name, :pID, :pw

  #ademas tiene citas
  has_many :appointments


   validates_presence_of :name, :pID, :pw
   validates :pID, :uniqueness => true


end
