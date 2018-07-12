class Trainer < ActiveRecord::Base
  has_many :locations, through: :visits
  has_many :encounters, through: :visits
  has_many :visits

  def go_to_location(location_name = "WeWork Dumbo")
    v = display_location(location_name)
    Visit.create(location_id: v.id, trainer_id: self.id, weather: "#{Location.fetch_weather(latitude(location_name), longitude(location_name))}")
    $current_location = v
  end

  def location_api(input)
    location_api = RestClient.get("https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{input}&inputtype=textquery&fields=name,geometry&key=AIzaSyDe39-V51PVPYwaYc76j_H9qnmsvCGo-p0")
  end

  def parse_api(place_api)
    JSON.parse(place_api.body)
  end

  def display_location(input)
    if parse_api(location_api(input))["candidates"] == []
      p "We couldn't find that location. Sorry! Please try again, maybe being more specific."
      location_menu(active_trainer)
    else
      new_location = parse_api(location_api(input))["candidates"][0]["name"]
      # new_location = parse_api(location_api(input))["candidates"][0]["formatted_address"].split(',')
        Location.find_or_create_by(name: new_location)
    end
  end

  def latitude(input)
    parse_api(location_api(input))["candidates"][0]['geometry']['location']['lat']
  end

  def longitude(input)
    parse_api(location_api(input))["candidates"][0]['geometry']['location']['lng']
  end



#Our API key for google  AIzaSyDe39-V51PVPYwaYc76j_H9qnmsvCGo-p0
# https://maps.googleapis.com/maps/api/place/details/json?placeid=ChIJOwg_06VPwokRYv534QaPC8g&fields=name&key=AIzaSyDe39-V51PVPYwaYc76j_H9qnmsvCGo-p0


  def find_location(location_name)
    Location.find_by name: location_name
  end

def catch_pokemon(found_pokemon, pokemon_hp)
    catch_percent = 0
    3.times do |catch|
      rand_num = rand(200..400)
      if rand_num >= 390
        catch_percent = 1000
      else
        catch_percent += rand(200..400)
      end
    end
    if catch_percent >= pokemon_hp
      Encounter.create(pokemon_id: found_pokemon.id, visit_id: self.visits.last.id)
      self.encounters.reload
      system "clear"
      spinner = TTY::Spinner.new("[:spinner] Attempting to catch #{found_pokemon.name} ...", format: :spin_2)
      spinner.auto_spin
      sleep(2)
      spinner.stop("You caught #{found_pokemon.name}!")
    else
      system "clear"
      spinner = TTY::Spinner.new("[:spinner] Attempting to catch #{found_pokemon.name} ...", format: :spin_2)
      spinner.auto_spin
      sleep(2)
      spinner.stop("#{found_pokemon.name} popped out")
      found_pokemon.display_image
      battle_menu(found_pokemon, pokemon_hp, self)
    end
  end

  def pokemon_status(found_pokemon,pokemon_hp)
    if pokemon_hp <= 0
      p "OMG you have killed #{found_pokemon.name}!"
    elsif pokemon_hp < 400
      p "#{found_pokemon.name} is weak!"
    elsif pokemon_hp < 600
      p "#{found_pokemon.name} is looking tired..."
    elsif pokemon_hp < 800
      p "#{found_pokemon.name} is pretty angry!"
    end
    pokemon_hp
  end

  def battle_pokemon(found_pokemon, pokemon_hp)
    clear_screen
    attack_pokemon = rand(1..500)
    pokemon_hp -= attack_pokemon
    pid = fork{ exec 'afplay', './media/battle_hit.wav' }
    p "You attacked #{found_pokemon.name}"
    pokemon_status(found_pokemon, pokemon_hp)
    found_pokemon.display_image
    # battle_pokemon_menu
    battle_menu(found_pokemon, pokemon_hp, self)
  end

  def my_pokemon
    self.encounters.map {|encounter| Pokemon.find(encounter.pokemon_id).name}
  end

  def my_pokemon_with_id
    # self.encounters.map {|encounter| encounter.id}
    self.encounters.each do |encounter|
      if encounter.nickname == nil
        p "<========================>"
        p "ID| Name"
        p "#{encounter.id} | #{Pokemon.find(encounter.pokemon_id).name}"
        p "Types: #{Pokemon.find(encounter.pokemon_id).display_types}"
        Pokemon.find(encounter.pokemon_id).display_image_small
      else
        p "<========================>"
        p "ID| Name | Nickname"
        p "#{encounter.id}| #{Pokemon.find(encounter.pokemon_id).name}: '#{encounter.nickname}'"
        p "Types: #{Pokemon.find(encounter.pokemon_id).display_types}"
        Pokemon.find(encounter.pokemon_id).display_image_small
      end
    end
  end

def my_locations_with_weather
  visits = Visit.where("trainer_id=#{self.id}")
  uniq_locations = visits.map { |visit| "#{Location.find(visit.location_id).name}.  You saw #{visit.weather}" }
  uniq_locations.uniq.each { |location| p location }
end


end
