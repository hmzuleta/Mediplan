class CreateOffices < ActiveRecord::Migration
  def change
    create_table :offices do |t|
      t.string :location
      t.string :specialty

      t.timestamps
    end
  end
end
