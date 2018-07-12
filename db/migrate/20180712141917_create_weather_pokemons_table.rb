class CreateWeatherPokemonsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :weather_pokemons do |t|
      t.integer :weather_type_id
      t.integer :pokemon_id
    end
  end
end
