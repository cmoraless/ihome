class CreateCameras < ActiveRecord::Migration
  def change
    create_table :cameras do |t|
      t.string :ip
      t.string :name
      t.string :port
      t.string :user
      t.string :password
      t.references :ibox
      t.timestamps
    end
  end
end
