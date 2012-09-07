class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.string :name
      t.string :dayBegin
      t.string :dayEnd
      t.boolean :isReiterative
      t.time :timeStart
      t.time :timeEnd
      t.references :profile
      t.references :accessory

      t.timestamps
    end
    add_index :schedules, :profile_id
    add_index :schedules, :accessory_id

  end
end
