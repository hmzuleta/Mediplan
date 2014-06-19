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

ActiveRecord::Schema.define(:version => 20130428193259) do

  create_table 'admins', :force => true do |t|
    t.string   'pID'
    t.string   'pw'
  end

  create_table 'appointments', :force => true do |t|
    t.date     'day', :null => false
    t.time     'hour', :null => false
    t.string   'pID_patient', :null => false
  end

  create_table 'doctors', :force => true do |t|
    t.string   'name'
    t.string   'pID'
    t.string   'pw'
  end

  create_table 'patients', :force => true do |t|
    t.string  'name', :null => false
    t.string  'pID', :unique => true, :null => false
    t.string  'IDType', :null => false
    t.string  'sex', :null => false
    t.string  'maritalStatus', :null => false
    t.string  'bPlace', :null => false
    t.string  'bDay', :null => false
    t.string  'address', :null => false
    t.integer 'tel1', :null => false
    t.integer 'tel2', :null => false
    t.string  'email'
    t.string  'occup', :null => false
    t.string  'empresaRemit'
    t.integer 'numContratoPol'
    t.string  'responsable'
    t.integer 'telResponsable'
    t.string  'antecedentesFam', :null => false
    t.string  'antecedentesPers', :null => false
  end

  create_table 'controls', :force => true do |t|
    t.string  'pID', :unique => true, :null => false
    t.date    'day', :null => false
    t.time    'hora', :null => false
    t.string  'motivo', :null => false
    t.decimal 'peso', :null => false
    t.string  'tensionArt', :null => false
    t.boolean 'esPrimeraVez', :null => false
    t.string  'nomAcomp', :null => false
    t.integer 'tel1Acomp', :null => false
    t.integer 'tel2Acomp', :null => false
    t.string  'parentesco', :null => false
  end

end
