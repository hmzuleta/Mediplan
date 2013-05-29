# encoding: utf-8


class Office < ActiveRecord::Base
  attr_accessible :location, :specialty
  # una sala debe corresponder a una especialidad y debe estar situada en un lugar especifico
  #NO ESCRIBIR ACCESOR
  validates :location, :specialty, :presence => true
  validates :specialty, :format => {:with=> /^[a-zA-Z\s\D]+$/, :message => "La especialidad no debe contener números" }
end
