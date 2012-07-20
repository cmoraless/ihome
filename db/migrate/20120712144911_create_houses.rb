class CreateHouses < ActiveRecord::Migration
  def change
    create_table :houses do |t|
      t.string :address
      t.boolean :state

      t.timestamps
    end
  end
end
