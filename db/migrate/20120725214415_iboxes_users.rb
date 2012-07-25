class IboxesUsers < ActiveRecord::Migration
  def change
    create_table :iboxes_users do |t|
      t.integer :ibox_id
      t.string  :user_id
      t.timestamps
    end
  end
end
