class CreateIboxAccesoriesContainerAccesories < ActiveRecord::Migration
  def change
    create_table :ibox_accesories_container_accesories do |t|
      t.string :name

      t.timestamps
    end
  end
end
