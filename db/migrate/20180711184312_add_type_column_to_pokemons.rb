class AddTypeColumnToPokemons < ActiveRecord::Migration[5.0]
  def change
    add_column :pokemons, :types, :string
  end
end
