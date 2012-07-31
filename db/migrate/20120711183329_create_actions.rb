class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.datetime :hour
      t.boolean :state
      t.references :profile_accessories_container
      t.references :accessory_type

      t.timestamps
    end
    add_index :actions, :profile_accessories_container_id
    add_index :actions, :accessory_type_id  
  end
end
