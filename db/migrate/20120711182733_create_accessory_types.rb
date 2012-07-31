class CreateAccessoryTypes < ActiveRecord::Migration
  def change
    create_table :accessory_types do |t|
      t.string :name
      t.string :kind

      t.timestamps
    end
  end
end
