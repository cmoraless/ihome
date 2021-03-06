class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_hash
      t.string :password_salt
      t.string :name
      t.boolean :isAdmin
      t.boolean :isSuperAdmin
      t.string :address
      t.string :phone
      t.string :rut
      t.string :code
      t.timestamps
    end
  end
end
