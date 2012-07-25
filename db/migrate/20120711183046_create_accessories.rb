class CreateAccessories < ActiveRecord::Migration
  def change
    create_table :accessories do |t|
      t.string :name
      t.boolean :state
      t.boolean :isScheduled
      t.references :accessory_type

      t.timestamps
    end

      add_index :accessories, :accessory_type_id
  end
end
