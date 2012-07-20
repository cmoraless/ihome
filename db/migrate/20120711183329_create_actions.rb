class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.datetime :hour
      t.boolean :state

      t.timestamps
    end
  end
end
