# encoding: utf-8
require 'test_helper'

class AppointmentTest < ActiveSupport::TestCase
  test "day nil" do
    e = Appointment.create(:hour => Time.new, :pID_doctor => 1234567, :pID_patient => 9876543, :office => "p101").errors[:day].first
    puts "day nill: "+e
    assert_not_nil(e,"day no deberia ser nil")
  end

  test "hour nil" do
    e = Appointment.create(:day => Date.new, :pID_doctor => 1234567, :pID_patient => 9876543, :office => "p101").errors[:hour].first
    puts "hour nill: "+e
    assert_not_nil(e,"hour no deberia ser nil")
  end

  test "office nil" do
    e = Appointment.create(:day => Date.new, :day => Date.new, :pID_doctor => 1234567, :pID_patient => 9876543).errors[:office].first
    puts "office nill: "+e
    assert_not_nil(e,"office no deberia ser nil")
  end

  test "pID_doctor nil" do
    e = Appointment.create(:day => Date.new, :hour => Time.new, :pID_patient => 9876543, :office => "p101").errors[:pID_doctor].first
    puts "pID_doctor nill: "+e
    assert_not_nil(e,"pID_doctor no deberia ser nil")
  end

  test "pID_doctor no numerico" do
    e = Appointment.create(:day => Date.new, :hour => Time.new, :pID_doctor => "qwerty", :pID_patient => 9876543, :office => "p101").errors[:pID_doctor].first
    puts "pID_doctor no numerico: "+e
    assert_not_nil(e,"pID_doctor no deberia ser no numerico")
  end

  test "pID_patient no numerico" do
    e = Appointment.create(:day => Date.new, :hour => Time.new, :pID_doctor => 1234567, :pID_patient => "qwerty", :office => "p101").errors[:pID_patient].first
    puts "pID_patient no numerico: "+e
    assert_not_nil(e,"pID_patient no deberia ser no numerico")
  end
end