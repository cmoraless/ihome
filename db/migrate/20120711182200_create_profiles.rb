class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :name
      t.boolean :isActive
      t.references :user
      t.references :ibox

      t.timestamps
    end
    add_index :profiles, :user_id  
    add_index :profiles, :ibox_id 
  end
end
