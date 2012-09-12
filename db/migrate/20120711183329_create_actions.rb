class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.string :dayBegin
      t.string :dayEnd
      t.boolean :repeatAtWeek
      t.boolean :repeatAtDay
      t.time :timeStart
      t.time :timeEnd
      t.timestamps
    end
  end
end
