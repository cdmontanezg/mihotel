class CreateHotels < ActiveRecord::Migration[5.1]
  def change
    create_table :hotels do |t|
      t.string :name
      t.string :city
      t.string :address
      t.string :contact_name

      t.timestamps
    end
  end
end
