require 'test_helper'

class PatientTest < ActiveSupport::TestCase
  test "nombre nulo" do
    pac = Patient.create(:pID=>443345)
    error = pac.errors[:name].first
    puts "nombre nulo E: "+error
    assert_not_nil(error, "Debe tener nombre")
  end

  test "nombre con numeros" do
    pac = Patient.create(:name =>"Leonel Alvarez 54", :pID=>1343412)
    error = pac.errors[:name].first
    puts "nombre con numeros E:"+error
    assert_not_nil(error, "No puede incluir numeros en el nombre")
  end

  test "cedula no numerica" do
    pac = Patient.create(:name =>"Rene Higuita", :pID=>'qwerty')
    error = pac.errors[:pID].first
    puts "cedula no numerica E:"+error
    assert_not_nil(error, "La cedula debe ser numerica")
  end

  test "cedula en rango" do
    pac = Patient.create(:name =>'Faustino Asprilla', :pID=>0)
    error = pac.errors[:pID].first
    puts "cedula en rango E:"+error
    assert_not_nil(error, "La cedula debe estar entre 100000..9999999999")
  end

  test "cedula no nula" do
    pac = Patient.create(:name =>"Carlos Valderrama")
    error = pac.errors[:pID].first
    puts "cedula no nula E:"+error
    assert_not_nil(error, "La cedula no puede ser nula")
  end
end
