class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.string :nombre_huesped
      t.string :descripcion
      t.datetime :fecha
      t.integer :canal

      t.timestamps
    end
  end
end