class DoctorAvailability < ActiveRecord::Base

  #La disponibilidad del doctor consiste en un dia, una hora de disponibilidad y su cedula
  #NO ESCRIBIR ACCESOR

  attr_accessible :day,:hour,:pID_doctor,:checked

  validates :day, :hour, :pID_doctor,:presence => true
  validate :fecha_mayor_que_hoy

  def fecha_mayor_que_hoy
    d = day.to_s.to_date
    if !day.blank? and d <= Date.today
      errors.add(:day, "La fecha debe ser mayor a hoy")
    end
  end

  validates :pID_doctor, :numericality => true

end
