class Pokemon <ActiveRecord::Base
  has_many :encounters

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
    pokeapi_method["types"].map {|type| type["type"]["name"].titleize}
  end

  # def location_api(input)
  #   location_api = RestClient.get("https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{input}&inputtype=textquery&fields=name&key=AIzaSyDe39-V51PVPYwaYc76j_H9qnmsvCGo-p0")
  # end
  # #&placeid=ChIJOwg_06VPwokRYv534QaPC8g
  #
  # def display_location(input)
  #   if parse_api(location_api(input))["candidates"] == []
  #     binding.pry
  #     p "Please try again!"
  #   else
  #     new_location = parse_api(location_api(input))["candidates"][0]["name"]
  #       Location.find_or_create_by(name: new_location)
  #   end
  # end


  def self.generate_pokemon
  #generates random pokemon from array
    found_pokemon = self.find_by(pokedex_id: rand(1...15))
    p "A wild #{found_pokemon.name} has appeared!"
    found_pokemon
    # catch_pokemon(found_pokemon)
  # Encounter.all
  end

end
