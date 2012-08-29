class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.string :name
      t.boolean :mon
      t.boolean :tue
      t.boolean :wen
      t.boolean :thu
      t.boolean :fri
      t.boolean :sat
      t.boolean :sun
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
