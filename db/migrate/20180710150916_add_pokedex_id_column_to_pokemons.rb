class AddPokedexIdColumnToPokemons < ActiveRecord::Migration[5.0]
  def change
    add_column :pokemons, :pokedex_id, :integer
  end
end
