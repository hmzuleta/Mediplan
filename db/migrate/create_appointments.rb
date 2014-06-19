class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.date :day
      t.time :hour
      t.string :pID_doctor
      t.string :pID_patient
    end
  end
end
