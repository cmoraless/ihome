class CreateAccesories < ActiveRecord::Migration
  def change
    create_table :accesories do |t|
      t.string :name
      t.boolean :state
      t.boolean :isScheduled

      t.timestamps
    end
  end
end
