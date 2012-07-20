class CreateIboxAccesoriesContainers < ActiveRecord::Migration
  def change
    create_table :ibox_accesories_containers do |t|
      t.string :name

      t.timestamps
    end
  end
end
