class CreateIboxAccessoriesContainersAccessories < ActiveRecord::Migration
  def change
    create_table :ibox_accessories_containers_accessories do |t|
      t.integer :ibox_accessories_container_id
      t.integer :accessory_id
      
      t.timestamps
    end
  end
end
