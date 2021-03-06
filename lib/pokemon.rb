class Pokemon < ActiveRecord::Base
  has_many :encounters
  belongs_to :weather_pokemon

  def get_api
    pokemon_api = RestClient.get("http://pokeapi.co/api/v2/pokemon/#{self.pokedex_id}")
  end

  def parse_api(pokemon_api)
    JSON.parse(pokemon_api.body)
  end

  def pokeapi_method
    parse_api(get_api)
  end

  def display_name
    pokeapi_method["name"].titleize
  end

  def display_id
    pokeapi_method["id"]
  end

  def display_types
    type_array = [self.type_1, self.type_2]
    if type_array[1] == nil
      "#{type_array[0]}"
    else
      "#{type_array[0]} & #{type_array[1]}"
    end
  end

  def create_type_array
    pokeapi_method["types"].map {|type| type["type"]["name"]}
  end

  def insert_type_1
    create_type_array[0]
  end

  def insert_type_2
    create_type_array[1]
  end



  def get_types
    type_array = pokeapi_method["types"].map {|type| type["type"]["name"].titleize}
    type_string = String.new
    type_array.each_with_index do |type, index|
      if index == 0
        type_string = type
      else
        type_string = type_string + ", " + type
      end
    end
    type_string
  end

  def display_image
    # Catpix::print_image "http://www.pokestadium.com/sprites/xy/#{self.name.downcase}.gif",
    Catpix::print_image "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/#{self.pokedex_id}.png",
      :limit_x => 0.5,
      :limit_y => 0.5,
      :center_x => false,
      :center_y => false,
      :resolution => "high"
  end

  def display_image_small
    # Catpix::print_image "http://www.pokestadium.com/sprites/xy/#{self.name.downcase}.gif",
    Catpix::print_image "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/#{self.pokedex_id}.png",
      :limit_x => 0.1,
      :limit_y => 0.1,
      :center_x => false,
      :center_y => false,
      :resolution => "high"
  end

  # def self.generate_pokemon
  # #generates random pokemon from array
  #   found_pokemon = self.find_by(pokedex_id: rand(1...15))
  #   p "A wild #{found_pokemon.name} has appeared!"
  #   found_pokemon.display_image
  #   found_pokemon
  #   # catch_pokemon(found_pokemon)
  # # Encounter.all
  # end

  def self.type_match(weather)
    weather_id = WeatherType.find_by(name: weather).id
    weather_pokemon = WeatherPokemon.all.where("weather_type_id == '#{weather_id}'")
    found_pokemon_id = weather_pokemon.sample.pokemon_id
    found_pokemon = self.find_by(pokedex_id: "#{found_pokemon_id}")
    puts "A wild #{found_pokemon.name} has appeared!".yellow.blink
    found_pokemon.display_image
    found_pokemon
    # matched = self.all.where("type_1 = '#{weather}'").or(self.all.where("type_2 = '#{weather}'"))
    # p weather_pokemon
  end

  def self.no_type_match(weather)
    weather_id = WeatherType.find_by(name: weather).id
    weather_pokemon = WeatherPokemon.all.where("weather_type_id != '#{weather_id}'")
    found_pokemon_id = weather_pokemon.sample.pokemon_id
    found_pokemon = self.find_by(pokedex_id: "#{found_pokemon_id}")
    puts "A wild #{found_pokemon.name} has appeared!".yellow.blink
    found_pokemon.display_image
    found_pokemon
    # p weather_pokemon
    # non_matched = self.all.where.not("type_1 = '#{weather}'").or(self.all.where("type_2 = '#{weather}'"))
  end

  def self.generate_pokemon_type(weather)
    #if weather is raining, 70% more likely water pokemon will appear
    weather_downcase = weather.downcase
    randomizer = rand(1..100)
    if (randomizer > 70)
      no_type_match(weather_downcase)
    else
      type_match(weather_downcase)
    end
  end

end
