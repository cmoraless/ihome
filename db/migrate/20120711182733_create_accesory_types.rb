class CreateAccesoryTypes < ActiveRecord::Migration
  def change
    create_table :accesory_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
