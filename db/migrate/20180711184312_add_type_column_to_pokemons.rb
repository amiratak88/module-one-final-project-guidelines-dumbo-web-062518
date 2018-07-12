class AddTypeColumnToPokemons < ActiveRecord::Migration[5.0]
  def change
    add_column :pokemons, :type_1, :string
  end
end
