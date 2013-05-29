class Appointment < ActiveRecord::Base

  #una cita tiene doctor, paciente, sala, dia y hora
  attr_accessible :day, :hour, :office, :pID_doctor, :pID_patient
  #NO ESCRIBIR ACCESOR

  validates_presence_of :day
  validates_presence_of :hour
  validates_presence_of :office
  validates_presence_of :pID_doctor
  validates_numericality_of :pID_doctor


end
