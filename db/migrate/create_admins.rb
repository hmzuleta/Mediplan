class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.string :pID
      t.string :pw
    end
  end
end
