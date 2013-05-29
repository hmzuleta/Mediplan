class CreateDoctors < ActiveRecord::Migration
  def change
    create_table :doctors do |t|
      t.string :name
      t.string :pID
      t.string :specialty

      t.timestamps
    end
  end
end
