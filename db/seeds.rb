##
## METHODS
##

def populate_pokemon
  counter = 1
  until counter == 15 do
    new_mon = Pokemon.create(pokedex_id: counter)
    new_mon.name = new_mon.display_name
    new_mon.type_1 = new_mon.insert_type_1
    new_mon.type_2 = new_mon.insert_type_2
    new_mon.save
    counter += 1
  end
end

def populate_weather_types
  ## cloud, clear, thunderstorm, snow, rain
  WeatherType.create(name: 'cloud')
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
  ## cloud, clear, thunderstorm, snow, rain
  weather_type = String.new

  case pokemon_type.downcase
  when 'normal'
    weather_type = 'clear'
  when 'fighting'
    weather_type = 'clear'
  when 'flying'
    weather_type = 'clear'
  when 'poison'
    weather_type = 'cloud'
  when 'ground'
    weather_type = 'cloud'
  when 'rock'
    weather_type = 'cloud'
  when 'bug'
    weather_type = 'clear'
  when 'ghost'
    weather_type = 'cloud'
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
    weather_type = 'cloud'
  when 'fairy'
    weather_type = 'clear'
  else
    weather_type = 'clear'
  end

  weather_type.downcase
end

##
## RUN METHODS
##

clear_screen

spinner = TTY::Spinner.new("[:spinner] Populating pokemon...", format: :spin_2)
spinner.auto_spin
populate_pokemon
sleep(0.3)
p "Populating pokemon..."
p "Done."

spinner = TTY::Spinner.new("[:spinner] Populating weather types...", format: :spin_2)
spinner.auto_spin
populate_weather_types
sleep(0.3)
p "Populating weather types..."
p "Done."

spinner = TTY::Spinner.new("[:spinner] Populating weather_pokemon...", format: :spin_2)
spinner.auto_spin
populate_weather_pokemon
sleep(0.3)
p "Done."
p "Populating weather_pokemon..."
