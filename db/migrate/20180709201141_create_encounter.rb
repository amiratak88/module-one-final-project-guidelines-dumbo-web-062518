class CreateEncounter < ActiveRecord::Migration[5.0]
  def change
    create_table :encounters do |t|
      t.integer :pokemon_id
      t.integer :visit_id
    end
  end
end
