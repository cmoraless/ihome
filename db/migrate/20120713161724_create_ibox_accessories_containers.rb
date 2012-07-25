class CreateIboxAccessoriesContainers < ActiveRecord::Migration
  def change
    create_table :ibox_accessories_containers do |t|
      t.string :name

      t.timestamps
    end
  end
end
