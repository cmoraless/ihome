class CreateAccessoriesIboxAccessoriesContainers < ActiveRecord::Migration
  def change
    create_table :accessories_ibox_accessories_containers, :id=>false do |t|
      t.integer :accessory_id
      t.integer :ibox_accessories_container_id
    end
  end
end
