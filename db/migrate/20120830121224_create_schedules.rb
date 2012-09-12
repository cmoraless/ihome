class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.string :name
      t.references :profile
      t.references :accessory

      t.timestamps
    end
    add_index :schedules, :profile_id
    add_index :schedules, :accessory_id

  end
end
