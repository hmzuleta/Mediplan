class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.time :hour
      t.date :day
      t.string :pID_doctor
      t.string :pID_patient
      t.string :office

      t.timestamps
    end
  end
end
