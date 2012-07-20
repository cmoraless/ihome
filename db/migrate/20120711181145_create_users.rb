class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, :id =>false, :primary_key =>'email' do |t|
      t.string :email
      t.string :name
      t.boolean :isAdmin
      t.string :address
      t.string :phone
      t.string :rut
      t.references :house
      t.timestamps
    end

    add_index :users, :house_id
  end
end
