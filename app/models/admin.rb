class Doctor < ActiveRecord::Base

  #un doctor tiene nombre, cedula y especialidad
  attr_accessible :pID, :pw
  validates_presence_of :pID, :pw
  validates :pID, :uniqueness => true


end
