class IboxesUsers < ActiveRecord::Migration
  def change
    create_table :iboxes_users, :id=>false do |t|
      t.integer :ibox_id
      t.integer :user_id
    end
  end
end
