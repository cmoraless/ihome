class CreateProfileAccesoriesContainers < ActiveRecord::Migration
  def change
    create_table :profile_accesories_containers do |t|
      t.string :name

      t.timestamps
    end
  end
end
