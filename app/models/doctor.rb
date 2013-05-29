class Doctor < ActiveRecord::Base

  #un doctor tiene nombre, cedula y especialidad
  attr_accessible :name, :pID, :specialty, :appo

  #ademas tiene disponibilidades y ccitas
  has_many :doctor_availabilities
  has_many :appointments


   validates_presence_of :specialty
   validates :specialty, :format => {:with=> /^[a-zA-Z\s\D]+$/}
   validates_presence_of :name
   validates :name, :format => {:with=> /^[a-zA-Z\s\D]+$/}
   validates :pID, :presence => true,
            :numericality => { :only_integer => true,
                                :greater_than_or_equal_to => 100000,
                                :less_than_or_equal_to => 9999999999 },
             :uniqueness => true
    validates_presence_of :appo


end
