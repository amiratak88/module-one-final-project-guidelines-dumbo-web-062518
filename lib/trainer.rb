class Trainer < ActiveRecord::Base
  has_many :locations, through: :visits
  has_many :encounters, through: :visits
  has_many :visits

  def go_to_location(location_name = "WeWork Dumbo")
    v = display_location(location_name)
    if v["status"] == "ZERO_RESULTS"
      puts "Please enter a new location."
      location_menu(active_trainer)
    else
      # p "I'm traveling without your permission"
      Visit.create(location_id: v.id, trainer_id: self.id, weather: "#{Location.fetch_weather(latitude(location_name), longitude(location_name))}")
      $current_location = v
  end
end

  def location_api(input)
    location_api = RestClient.get("https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{input}&inputtype=textquery&fields=name,geometry,formatted_address&key=AIzaSyDe39-V51PVPYwaYc76j_H9qnmsvCGo-p0")
  end

  def parse_api(place_api)
    JSON.parse(place_api.body)
  end

  def display_location(input)
    if parse_api(location_api(input))["status"] == "ZERO_RESULTS"
      clear_screen
      puts "We couldn't find that location. Sorry! Please try again, maybe being more (or maybe less) specific.".yellow
      location_menu(self)
    else
      # binding.pry
      new_location_name = parse_api(location_api(input))["candidates"][0]["name"]
      new_location_lat = parse_api(location_api(input))["candidates"][0]["geometry"]["location"]["lat"]
      new_location_lon = parse_api(location_api(input))["candidates"][0]["geometry"]["location"]["lng"]
      # new_location = parse_api(location_api(input))["candidates"][0]["formatted_address"].split(',')
        Location.find_or_create_by(name: new_location_name, latitude: new_location_lat, longitude: new_location_lon)
    end
  end

  def location_zip(input)
    address = parse_api(location_api(input))["candidates"][0]["formatted_address"]
    binding.pry
    new_location = address.split(",")
    newthing = new_location[-2]
    binding.pry
    newthing.split[-1]
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
      spinner = TTY::Spinner.new("[:spinner] Attempting to catch #{found_pokemon.name} ...".yellow, format: :spin_2)
      spinner.auto_spin
      sleep(2)
      spinner.stop("You caught #{found_pokemon.name}!".green)
    else
      system "clear"
      spinner = TTY::Spinner.new("[:spinner] Attempting to catch #{found_pokemon.name} ...".yellow, format: :spin_2)
      spinner.auto_spin
      sleep(2)
      spinner.stop("#{found_pokemon.name} popped out".yellow)
      found_pokemon.display_image
      battle_menu(found_pokemon, pokemon_hp, self)
    end
  end

  def pokemon_status(found_pokemon,pokemon_hp)
    if pokemon_hp <= 0
      puts "OMG you have killed #{found_pokemon.name}!".red
    elsif pokemon_hp < 400
      puts "#{found_pokemon.name} is weak!".green
    elsif pokemon_hp < 600
      puts "#{found_pokemon.name} is looking tired...".yellow
    elsif pokemon_hp < 800
      puts "#{found_pokemon.name} is pretty angry!".red
    end
    pokemon_hp
  end

  def battle_pokemon(found_pokemon, pokemon_hp)
    clear_screen
    attack_pokemon = rand(1..500)
    pokemon_hp -= attack_pokemon
    pid = fork{ exec 'afplay', './media/battle_hit.wav' }
    puts "You attacked #{found_pokemon.name}!".red.blink
    pokemon_status(found_pokemon, pokemon_hp)
    found_pokemon.display_image
    # battle_pokemon_menu
    battle_menu(found_pokemon, pokemon_hp, self)
  end

  def my_pokemon
    self.encounters.map {|encounter| Pokemon.find(encounter.pokemon_id).name}
  end

  def my_pokemon_with_id
    self.encounters.each do |encounter|

      puts "<========================>"
      output = "ID: #{encounter.id} | Name: #{Pokemon.find(encounter.pokemon_id).name}"
      if !encounter.nickname.nil?
        output = output + " | Nickname: #{encounter.nickname}"
      end
      output = output + " | Types: #{Pokemon.find(encounter.pokemon_id).display_types}"
      puts output
      Pokemon.find(encounter.pokemon_id).display_image_small
    end
  end

def my_locations_with_weather
  visits = Visit.where("trainer_id=#{self.id}")
  uniq_locations = visits.map { |visit| "#{Location.find(visit.location_id).name}.  You saw #{visit.weather}" }
  uniq_locations.uniq.each { |location| puts location }
end

def get_gender
  input = TTY::Prompt.new

  puts "\n"
  input.select('Please select the gender you are most comfortable with.'.blue, cycle: true) do |menu|

      menu.choice 'Male', -> do
        pid = fork{ exec 'afplay', './media/menu_select.wav' }
        self.gender = "Male"
        self.save
        clear_screen
      end

      menu.choice 'Female', -> do
        pid = fork{ exec 'afplay', './media/menu_select.wav' }
        self.gender = "Female"
        self.save
        clear_screen
      end

    menu.choice 'Non-Binary', -> do
      pid = fork{ exec 'afplay', './media/menu_select.wav' }
      self.gender = "Non_binary"
      self.save
      clear_screen
    end
  end
end


end
