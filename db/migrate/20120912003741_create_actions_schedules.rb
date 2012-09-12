class CreateActionsSchedules < ActiveRecord::Migration
  def change
    create_table :actions_schedules, :id=>false do |t|
      t.integer :action_id
      t.integer :schedule_id
    end
  end
end
