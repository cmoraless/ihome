class CreateIboxAccessoriesContainers < ActiveRecord::Migration
  def change
    create_table :ibox_accessories_containers do |t|
      t.string :name
      t.references :ibox
      t.references :accessory_type

      t.timestamps
    end
    add_index :ibox_accessories_containers, :ibox_id
    add_index :ibox_accessories_containers, :accessory_type_id

  end
end
