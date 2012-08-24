class CreateAccessoriesUsers < ActiveRecord::Migration
  def change
    create_table :accessories_users, :id=>false do |t|
      t.integer :accessory_id
      t.integer :user_id
    end
  end
end
