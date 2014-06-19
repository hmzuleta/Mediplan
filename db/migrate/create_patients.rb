class CreatePatients < ActiveRecord::Migration
  def change
    create_table :patients do |t|
      t.string  :name
      t.string  :pID
      t.string  :IDType
      t.string  :sex
      t.string  :maritalStatus
      t.string  :bPlace
      t.string  :bDay
      t.string  :address
      t.integer :tel1
      t.integer :tel2
      t.string  :email
      t.string  :occup
      t.string  :empresaRemit
      t.integer :numContratoPol
      t.string  :responsable
      t.integer :telResponsable
      t.string  :antecedentesFam
      t.string  :antecedentesPers
    end
  end
end
