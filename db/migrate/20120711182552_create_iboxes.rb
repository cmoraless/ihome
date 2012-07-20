class CreateIboxes < ActiveRecord::Migration
  def change
    create_table :iboxes do |t|
      t.string :name
      t.boolean :isActive

      t.timestamps
    end
  end
end
