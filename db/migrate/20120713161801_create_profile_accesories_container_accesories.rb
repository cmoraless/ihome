class CreateProfileAccesoriesContainerAccesories < ActiveRecord::Migration
  def change
    create_table :profile_accesories_container_accesories do |t|
      t.string :name

      t.timestamps
    end
  end
end
