class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :value
      t.string :comment
      t.references :ibox
      t.references :profile
      t.references :accessory
      t.references :user

      t.timestamps
    end
    add_index :activities, :ibox_id
    add_index :activities, :profile_id 
    add_index :activities, :accessory_id 
    add_index :activities, :user_id   
  end
end
