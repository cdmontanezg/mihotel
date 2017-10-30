class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.string :nombre_huesped
      t.string :descripcion
      t.datetime :fecha
      t.integer :canal

      t.belongs_to :hotel, index: true, foreign_key: true

      t.belongs_to :reservation, index: true, foreign_key: true

      t.timestamps
    end
  end
end