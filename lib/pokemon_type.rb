class PokemonType < ActiveRecord::Base
  has_many :pokemons
  has_many :weather_types, through: :weather_pokemon
end
