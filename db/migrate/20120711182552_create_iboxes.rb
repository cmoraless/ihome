class CreateIboxes < ActiveRecord::Migration
  def change
    create_table :iboxes do |t|
      t.string :name
      t.string :ip
      t.string :mac
      t.string :port
      t.string :user
      t.string :password
      t.boolean :isActive
      t.timestamps
    end
  end
end
