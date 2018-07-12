class WeatherType < ActiveRecord::Base
  has_many :pokemons, through: :weather_pokemons
end







# weather_type = "rain"
# use weather_type to get pokemon types associated with that weather_type
# pokemon_type = "water"

# pokemon_array = Pokemon.all

# pokemon_array.select do |pokemon|
#   <logic for selecting pokemon based on type_1 and type_2>
# end
