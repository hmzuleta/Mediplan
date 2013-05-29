# encoding: utf-8
require 'test_helper'

class DoctorTest <  ActiveSupport::TestCase
  test "nombre null" do
    e = Doctor.create(:specialty =>'General', :pID=>43456876).errors[:name].first
    puts "nombre null: "+e
    assert_not_nil(e, "No puede tener nombre nulo")
  end

  test "nombre con numeros" do
    e = Doctor.create(:name =>'Juan Lopez 22lol',:specialty =>'General', :pID=>43456876).errors[:name].first
    puts "nombre con numeros: "+e
    assert_not_nil(e, "No puede tener nombre nulo")
  end

  test "cedula no numerica" do
    e = Doctor.create(:name =>'Juan Lopez', :specialty =>'General', :pID=>'aaaaaaa').errors[:pID].first
    puts "cedula no numerica: "+e
    assert_not_nil(e, "La cedula solo puede tener digitos")
  end

  test "cedula en rango" do
    e = Doctor.create(:name =>'Juan Lopez', :specialty =>'General', :pID=>0).errors[:pID].first
    puts "cedula en rango: "+e
    assert_not_nil(e, "La cedula debe ser mayor a 1")
  end

  test "especialidad no null" do
    e = Doctor.create(:name =>'Juan Lopez', :pID=>'1020794475').errors[:specialty].first
    puts "especiaidad no null: "+e
    assert_not_nil(e, "La especialidad no puede ser nula")
  end
end