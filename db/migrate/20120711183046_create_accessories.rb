class CreateAccessories < ActiveRecord::Migration
  def change
    create_table :accessories do |t|
      t.string :name # alias
      t.string :zid
      t.integer :value
      t.string :kind
      t.string :cmdclass
      t.string :x
      t.string :y
      t.string :w
      t.string :h      
      t.boolean :state
      t.boolean :isScheduled
      t.boolean :isPublic
      t.references :accessory_type

      t.timestamps
    end
    add_index :accessories, :accessory_type_id
  end
end
