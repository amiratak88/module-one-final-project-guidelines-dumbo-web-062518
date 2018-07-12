class PokemonType < ActiveRecord::Base
  has_many :pokemons
end
