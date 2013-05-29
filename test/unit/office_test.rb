# encoding: utf-8
require 'test_helper'

class OfficeTest < ActiveSupport::TestCase
  test "location nil" do
    e=Office.create(:specialty => "Pediatria").errors[:location].first
    puts "location nil: "+e
    assert_not_nil(e, "location no deberia ser nil")
  end

  test "specialty nil" do
    e=Office.create(:location => "101").errors[:specialty].first
    puts "specialty nil: "+e
    assert_not_nil(e, "specialty no deberia ser nil")
  end

  test "specialty numerica" do
    e=Office.create(:location => "101",:specialty => "Odontología1").errors[:specialty].first
    puts "specialty numerica: "+e
    assert_not_nil(e, "specialty no debería tener números")
  end
end

