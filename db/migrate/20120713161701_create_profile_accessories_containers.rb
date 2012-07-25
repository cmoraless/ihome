class CreateProfileAccessoriesContainers < ActiveRecord::Migration
  def change
    create_table :profile_accessories_containers do |t|
      t.string :name

      t.timestamps
    end
  end
end
