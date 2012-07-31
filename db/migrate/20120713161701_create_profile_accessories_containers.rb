class CreateProfileAccessoriesContainers < ActiveRecord::Migration
  def change
    create_table :profile_accessories_containers do |t|
      t.string :name
      t.references :profile
      t.references :accesory_type

      t.timestamps
    end
    add_index :profile_accessories_containers, :profile_id
    add_index :profile_accessories_containers, :accesory_type_id    
  end
  
end
