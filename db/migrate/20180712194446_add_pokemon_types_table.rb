class AddPokemonTypesTable < ActiveRecord::Migration[5.0]
  def change
    create_table :pokemon_types do |t|
      t.string :name
      t.integer :weather_type_id
    end
  end
end
