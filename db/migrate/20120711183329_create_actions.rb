class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.integer :day_begin
      t.integer :day_end
      t.boolean :repeat_weekly
      t.boolean :repeat_dayly
      t.time :time_start
      t.time :time_end
      t.timestamps
    end
  end
end
