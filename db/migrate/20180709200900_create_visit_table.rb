class CreateVisitTable < ActiveRecord::Migration[5.0]
  def change
    create_table :visits do |t|
      t.integer :trainer_id
      t.integer :location_id
      t.timestamp
    end
  end
end
