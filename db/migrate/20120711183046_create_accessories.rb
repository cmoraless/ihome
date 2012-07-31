class CreateAccessories < ActiveRecord::Migration
  def change
    create_table :accessories do |t|
      t.string :name # alias
      t.string :zid
      t.integer :value
      t.string :cmdclass
      t.boolean :state
      t.boolean :isScheduled
      t.references :accessory_type

      t.timestamps
    end
    add_index :accessories, :accessory_type_id
  end
end
