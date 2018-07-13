##
## METHODS
##

# def populate_pokemon
#   counter = 1
#   until counter == 15 do
#     new_mon = Pokemon.create(pokedex_id: counter)
#     new_mon.name = new_mon.display_name
#     new_mon.type_1 = new_mon.insert_type_1
#     new_mon.type_2 = new_mon.insert_type_2
#     new_mon.save
#     counter += 1
#   end
# end

# def get_the_mons
#   pokemon_array = Array.new
#
#   Pokemon.all.each do |pokemon|
#     pokemon_hash = {
#       id: pokemon.id,
#       name: pokemon.name,
#       pokedex_id: pokemon.pokedex_id,
#       type_1: pokemon.type_1,
#       type_2: pokemon.type_2
#     }
#     pokemon_array << pokemon_hash
#   end
#
#   p pokemon_array
# end

pokemon_array = [{:id=>1, :name=>"Bulbasaur", :pokedex_id=>1, :type_1=>"Poison", :type_2=>"Grass"},
 {:id=>2, :name=>"Ivysaur", :pokedex_id=>2, :type_1=>"Poison", :type_2=>"Grass"},
 {:id=>3, :name=>"Venusaur", :pokedex_id=>3, :type_1=>"Poison", :type_2=>"Grass"},
 {:id=>4, :name=>"Charmander", :pokedex_id=>4, :type_1=>"Fire", :type_2=>nil},
 {:id=>5, :name=>"Charmeleon", :pokedex_id=>5, :type_1=>"Fire", :type_2=>nil},
 {:id=>6, :name=>"Charizard", :pokedex_id=>6, :type_1=>"Flying", :type_2=>"Fire"},
 {:id=>7, :name=>"Squirtle", :pokedex_id=>7, :type_1=>"Water", :type_2=>nil},
 {:id=>8, :name=>"Wartortle", :pokedex_id=>8, :type_1=>"Water", :type_2=>nil},
 {:id=>9, :name=>"Blastoise", :pokedex_id=>9, :type_1=>"Water", :type_2=>nil},
 {:id=>10, :name=>"Caterpie", :pokedex_id=>10, :type_1=>"Bug", :type_2=>nil},
 {:id=>11, :name=>"Metapod", :pokedex_id=>11, :type_1=>"Bug", :type_2=>nil},
 {:id=>12, :name=>"Butterfree", :pokedex_id=>12, :type_1=>"Flying", :type_2=>"Bug"},
 {:id=>13, :name=>"Weedle", :pokedex_id=>13, :type_1=>"Poison", :type_2=>"Bug"},
 {:id=>14, :name=>"Kakuna", :pokedex_id=>14, :type_1=>"Poison", :type_2=>"Bug"}]

def populate_pokemon_from_array(pokemon_array)
  pokemon_array.each do |pokemon|
    Pokemon.create(name: pokemon[:name], pokedex_id: pokemon[:pokedex_id], type_1: pokemon[:type_1], type_2: pokemon[:type_2])
  end
end

def populate_weather_types
  ## clouds, clear, thunderstorm, snow, rain
  WeatherType.create(name: 'clouds')
  WeatherType.create(name: 'clear')
  WeatherType.create(name: 'thunderstorm')
  WeatherType.create(name: 'snow')
  WeatherType.create(name: 'rain')
end

def populate_weather_pokemon
  pokemons = Pokemon.all
  pokemons.each do |pokemon|

    #type_1
    weather_type = get_pokemon_weather_type_id(pokemon.type_1)
    weather = WeatherType.find_by(name: weather_type)
    WeatherPokemon.create(weather_type_id: weather.id, pokemon_id: pokemon.id)

    #type_2
    if !pokemon.type_2.nil?
      weather_type = get_pokemon_weather_type_id(pokemon.type_2)
      weather = WeatherType.find_by(name: weather_type)
      WeatherPokemon.create(weather_type_id: weather.id, pokemon_id: pokemon.id)
    end
  end
end

def get_pokemon_weather_type_id(pokemon_type)
  ## clouds, clear, thunderstorm, snow, rain
  weather_type = String.new

  case pokemon_type.downcase
  when 'normal'
    weather_type = 'clear'
  when 'fighting'
    weather_type = 'clear'
  when 'flying'
    weather_type = 'clear'
  when 'poison'
    weather_type = 'clouds'
  when 'ground'
    weather_type = 'clouds'
  when 'rock'
    weather_type = 'clouds'
  when 'bug'
    weather_type = 'clear'
  when 'ghost'
    weather_type = 'clouds'
  when 'steel'
    weather_type = 'clear'
  when 'fire'
    weather_type = 'clear'
  when 'water'
    weather_type = 'rain'
  when 'grass'
    weather_type = 'clear'
  when 'electric'
    weather_type = 'thunderstorm'
  when 'psychic'
    weather_type = 'clear'
  when 'ice'
    weather_type = 'snow'
  when 'dragon'
    weather_type = 'clear'
  when 'dark'
    weather_type = 'clouds'
  when 'fairy'
    weather_type = 'clear'
  else
    weather_type = 'clear'
  end

  weather_type.downcase
end

# def populate_pokemon_types
#   PokemonType.new(name: 'normal', weather_type_id: 2)
#   PokemonType.new(name: 'fighting', weather_type_id: 2)
#   PokemonType.new(name: 'flying', weather_type_id: 2)
#   PokemonType.new(name: 'poison', weather_type_id: 1)
#   PokemonType.new(name: 'ground', weather_type_id: 1)
#   PokemonType.new(name: 'rock', weather_type_id: 1)
#   PokemonType.new(name: 'bug', weather_type_id: 2)
#   PokemonType.new(name: 'ghost', weather_type_id: 1)
#   PokemonType.new(name: 'steel', weather_type_id: 2)
#   PokemonType.new(name: 'fire', weather_type_id: 2)
#   PokemonType.new(name: 'water', weather_type_id: 5)
#   PokemonType.new(name: 'grass', weather_type_id: 2)
#   PokemonType.new(name: 'electric', weather_type_id: 3)
#   PokemonType.new(name: 'psychic', weather_type_id: 2)
#   PokemonType.new(name: 'ice', weather_type_id: 4)
#   PokemonType.new(name: 'dragon', weather_type_id: 2)
#   PokemonType.new(name: 'dark', weather_type_id: 1)
#   PokemonType.new(name: 'fairy', weather_type_id: 2)
# end

##
## RUN METHODS
##

clear_screen

spinner = TTY::Spinner.new("[:spinner] Populating pokemon...", format: :spin_2)
spinner.auto_spin
# populate_pokemon
populate_pokemon_from_array(pokemon_array)
sleep(1)
# p "Populating pokemon..."
spinner.stop("Done.".green)

spinner = TTY::Spinner.new("[:spinner] Populating weather types...", format: :spin_2)
spinner.auto_spin
populate_weather_types
sleep(1)
# p "Populating weather types..."
spinner.stop("Done.".green)

spinner = TTY::Spinner.new("[:spinner] Populating weather_pokemon...", format: :spin_2)
spinner.auto_spin
populate_weather_pokemon
sleep(1)
# p "Populating weather_pokemon..."
spinner.stop("Done.".green)
