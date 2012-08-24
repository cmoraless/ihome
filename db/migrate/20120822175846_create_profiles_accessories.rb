class CreateProfilesAccessories < ActiveRecord::Migration
  def change
    create_table :profiles_accessories, :id=>false do |t|
      t.integer :profile__id
      t.integer :accessory_id
    end
  end

end
