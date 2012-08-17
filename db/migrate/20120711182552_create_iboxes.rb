class CreateIboxes < ActiveRecord::Migration
  def change
    create_table :iboxes do |t|
      t.string :name
      t.string :ip
      t.string :port
      t.boolean :isActive
      t.timestamps
    end
  end
end
