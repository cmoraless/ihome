class CreateAccessoriesProfiles < ActiveRecord::Migration
  def change
    create_table :accessories_profiles, :id=>false do |t|
      t.integer :accessory_id
      t.integer :profile_id
    end
  end

end
