# encoding: utf-8
require 'test_helper'

class DoctorAvailabilityTest < ActiveSupport::TestCase

  test "fecha valida" do
    d=Date.today
    d = d.to_time.advance(:months => -1).to_date
    t = Time.new
    docav = DoctorAvailability.create(:day=>d, :hour=>t, :pID_doctor=>'200000').errors[:day].first
    puts("Fecha del mes siguiente: " + docav )
    assert_not_nil(docav,"La fecha no puede ser menor que hoy.")
  end

  test "fecha valida2" do
    d=Date.today
    t = Time.new
    docav = DoctorAvailability.create(:day=>d, :hour=>t, :pID_doctor=>'200000').errors[:day].first
    puts("Fecha del mes siguiente: " + docav )
    assert_not_nil(docav,"La fecha debería ser mayor a hoy.")
  end

  test "cedula no numerica" do
    d=Date.today
    d = d.to_time.advance(:day => 10).to_date
    t = Time.new
    docav = DoctorAvailability.create(:day=>d, :hour=>t, :pID_doctor=>'2a00000').errors[:pID_doctor].first
    puts "cedula no numerica: "+docav
    assert_not_nil(docav, "La cedula solo puede tener digitos")
  end

  test "hora valida" do

  end

end