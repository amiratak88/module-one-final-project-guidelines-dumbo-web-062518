class Trainer < ActiveRecord::Base
  has_many :locations, through: :visits
  has_many :encounters, through: :visits
  has_many :visits

  def go_to_location(location_name = "Flatiron School")
    v = display_location(location_name)
    Visit.create(location_id: v.id, trainer_id: self.id)
    $current_location = v
  end

  def location_api(input)
    location_api = RestClient.get("https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{input}&inputtype=textquery&fields=name&key=AIzaSyDe39-V51PVPYwaYc76j_H9qnmsvCGo-p0")
  end

  def parse_api(place_api)
    JSON.parse(place_api.body)
  end

  #&placeid=ChIJOwg_06VPwokRYv534QaPC8g

  def display_location(input)
    if parse_api(location_api(input))["candidates"] == []
      binding.pry
      p "Please try again!"
    else
      new_location = parse_api(location_api(input))["candidates"][0]["name"]
        Location.find_or_create_by(name: new_location)
    end
  end

#Our API key for google  AIzaSyDe39-V51PVPYwaYc76j_H9qnmsvCGo-p0

# https://maps.googleapis.com/maps/api/place/details/json?placeid=ChIJOwg_06VPwokRYv534QaPC8g&fields=name&key=AIzaSyDe39-V51PVPYwaYc76j_H9qnmsvCGo-p0


  def find_location(location_name)
    Location.find_by name: location_name
  end

  # def look_for_pokemon
    #generates random pokemon from array
    # found_pokemon = Pokemon.find_by(pokedex_id: rand(1..15))
    # p "A wild #{found_pokemon.name} has appeared!"
    # catch_pokemon(found_pokemon)
    # Encounter.all
  # end

  def catch_pokemon(found_pokemon)
    trainer = Trainer.find($trainer.id)
    Encounter.create(pokemon_id: found_pokemon.id, visit_id: Visit.last.id)
  end

  def my_pokemon
    self.encounters.map {|encounter| Pokemon.find(encounter.pokemon_id).name}
  end

  def pick_trainer
    puts "Enter your trainer's name"
    trainer_name = gets.chomp
    if Trainer.all.find_by name: trainer_name
      location_menu
    else
      Trainer.create(name: trainer_name)
      location_menu
    end
  end

  def my_pokemon_with_id
    # self.encounters.map {|encounter| encounter.id}
    self.encounters.each do |encounter|
      if encounter.nickname == nil
        p "#{Pokemon.find(encounter.pokemon_id).name} - #{encounter.id}"
      else
        p "#{Pokemon.find(encounter.pokemon_id).name} - #{encounter.id} - #{encounter.nickname}"
      end
    end
  end

  # def current_location_by_visit
  #   Visit.last.id
  # end
  #
  # def current_visit
  # end
end
