class CreateAccessoryTypes < ActiveRecord::Migration
  def change
    create_table :accessory_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
