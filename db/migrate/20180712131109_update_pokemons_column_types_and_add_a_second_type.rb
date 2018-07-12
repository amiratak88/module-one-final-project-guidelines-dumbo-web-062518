class UpdatePokemonsColumnTypesAndAddASecondType < ActiveRecord::Migration[5.0]
  def change
    add_column :pokemons, :type_2, :string
  end
end
