class CreateProfileAccessoriesContainersAccessories < ActiveRecord::Migration
  def change
    create_table :profile_accessories_containers_accessories do |t|
      t.integer :profile_accessories_container_id
      t.integer :accessory_id

      t.timestamps
    end
  end
end
