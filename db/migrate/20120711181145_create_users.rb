class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, :id =>false, :primary_key =>'email' do |t|
      t.string :email
      t.string :password
      t.string :name
      t.boolean :isAdmin
      t.string :address
      t.string :phone
      t.string :rut
      t.timestamps
    end
  end
end
