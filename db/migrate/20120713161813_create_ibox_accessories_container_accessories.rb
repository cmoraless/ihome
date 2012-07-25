class CreateIboxAccessoriesContainerAccessories < ActiveRecord::Migration
  def change
    create_table :ibox_accessories_container_accessories do |t|
      t.string :name

      t.timestamps
    end
  end
end
