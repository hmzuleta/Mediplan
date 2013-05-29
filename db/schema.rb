# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130429050303) do

  create_table "appointments", :force => true do |t|
    t.time     "hour"
    t.date     "day"
    t.string   "pID_doctor"
    t.string   "pID_patient"
    t.string   "office"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "doctor_availabilities", :force => true do |t|
    t.string   "pID_doctor"
    t.date     "day"
    t.time     "hour"
    t.boolean  "checked"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "doctors", :force => true do |t|
    t.string   "name"
    t.string   "pID"
    t.string   "specialty"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "office_availabilities", :force => true do |t|
    t.string   "location"
    t.date     "day"
    t.time     "hour"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "offices", :force => true do |t|
    t.string   "location"
    t.string   "speciality"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "patients", :force => true do |t|
    t.string   "name"
    t.string   "pID"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
