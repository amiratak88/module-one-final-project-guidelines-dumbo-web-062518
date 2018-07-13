class Trainer < ActiveRecord::Base
  has_many :locations, through: :visits
  has_many :encounters, through: :visits
  has_many :visits

  def go_to_location(location_name = "WeWork Dumbo")
    v = display_location(location_name)
    if v["status"] == "ZERO_RESULTS"
      puts "Please enter a new location.".yellow
      location_menu(active_trainer)
    else
      Visit.create(location_id: v.id, trainer_id: self.id, weather: "#{Location.fetch_weather(latitude(location_name), longitude(location_name))}")
      $current_location = v
    end
  end

  def get_location_name(location)
    new_location = display_location(location).name
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
    # percent_display = 0
    # catch_percent = 0
    # pokemon_run_chance = 0
    # rand_num = rand(1..100)
    # 3.times do |catch|
    #   if rand_num >= 90
    #     catch_percent = 1000
    #   else
    #     catch_percent += rand(75..125)
    #   end
    # end
    # binding.pry

    # if catch_percent >= pokemon_hp
    #   Encounter.create(pokemon_id: found_pokemon.id, visit_id: self.visits.last.id)
    #   self.encounters.reload
    #   system "clear"
    #   spinner = TTY::Spinner.new("[:spinner] The pokeball is wiggling...".yellow, format: :spin_2)
    #   pokemon_run_chance += rand(1..100)
    #   spinner.auto_spin
    #   sleep(2)
    #   spinner.stop("You caught #{found_pokemon.name}!".green)
    # else
    #   system "clear"
    #   spinner = TTY::Spinner.new("[:spinner] The pokeball is wiggling...".yellow, format: :spin_2)
    #   spinner.auto_spin
    #   sleep(2)
    #   spinner.stop("#{found_pokemon.name} popped out".yellow)
    #
    #   pokemon_run_chance += rand(1..100)
    #   if pokemon_run_chance > 85
    #     puts "Pokemon got away".magenta
    #     location_menu(self)
    #   end
    #
    #   found_pokemon.display_image
    #   battle_menu(found_pokemon, pokemon_hp, self)
    # end

    roll_100 = rand(1..100)
    chance = 10 # base percent chance
    multiplier = 5
    chance = (((1000 - pokemon_hp) / 100) * multiplier) + chance # at 200hp, chance is 50%

    clear_screen
    # puts "#{chance}% chance to catch - #{pokemon_hp} HP"
    threw_too_hard(roll_100, found_pokemon)
    spinner = TTY::Spinner.new("[:spinner] The pokeball is wiggling...".yellow, format: :spin_2)
    spinner.auto_spin
    sleep(2)

    if roll_100 <= chance
      Encounter.create(pokemon_id: found_pokemon.id, visit_id: self.visits.last.id)
      self.encounters.reload

      spinner.stop("You caught #{found_pokemon.name}!".green)

      if pokemon_hp == 1000
        puts "Great throw!".magenta.blink
      end

      continue_key
      clear_screen
    else
      spinner.stop("#{found_pokemon.name} popped out!".yellow)
      sleep(1.5)
      clear_screen
      pokemon_status(found_pokemon, pokemon_hp)
      pokemon_runaway(found_pokemon)
      found_pokemon.display_image
      battle_menu(found_pokemon, pokemon_hp, self)
    end
  end

  def threw_too_hard(roll_100, found_pokemon)
    if roll_100 == 100
      puts "You threw the pokeball too hard and #{found_pokemon.name} has died.".red.blink
      Catpix::print_image "./media/images/cubone_skull_crossbones.png",
        :limit_x => 0.5,
        :limit_y => 0.5,
        :center_x => true,
        :center_y => false,
        :resolution => "high"
      continue_key
      location_menu(self)
    end
  end

  def pokemon_status(found_pokemon, pokemon_hp)
    if pokemon_hp <= 0
      puts "OMG you have killed #{found_pokemon.name}!".red.blink
      continue_key
    elsif pokemon_hp < 400
      puts "#{found_pokemon.name} is weak!".green.blink
    elsif pokemon_hp < 600
      puts "#{found_pokemon.name} is looking tired...".yellow.blink
    elsif pokemon_hp < 800
      puts "#{found_pokemon.name} is pretty angry!".red.blink
    end
  end

  def battle_pokemon(found_pokemon, pokemon_hp)
    clear_screen
    # pokemon_run_chance = 0
    attack_pokemon = rand(50..500)
    # pokemon_run_chance += rand(1..100)
    pokemon_hp -= attack_pokemon
    pid = fork{ exec 'afplay', './media/battle_hit.wav' }
    puts "You attacked #{found_pokemon.name}!".red
    sleep(1)
    pokemon_status(found_pokemon, pokemon_hp)
    if pokemon_hp > 0
      pokemon_runaway(found_pokemon)
    end
    # if pokemon_run_chance > 85
    #   puts "Pokemon got away".magenta
    #   location_menu(self)
    # end


    if pokemon_hp <= 0
      Catpix::print_image "./media/images/cubone_skull_crossbones.png",
        :limit_x => 0.5,
        :limit_y => 0.5,
        :center_x => true,
        :center_y => false,
        :resolution => "high"
    else
      found_pokemon.display_image
    end

    battle_menu(found_pokemon, pokemon_hp, self)
  end

  def pokemon_runaway(found_pokemon)
    run_chance = rand(1..100)

    if run_chance <= 15
      puts "#{found_pokemon.name} got away...".magenta.blink
      continue_key
      clear_screen
      location_menu(self)
    end
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
    uniq_locations = visits.map { |visit| "#{visit.location_id}. #{Location.find(visit.location_id).name}.  You saw #{visit.weather}" }
    uniq_locations.uniq.each { |location| puts "#{location}" }
  end

  def get_gender
    input = TTY::Prompt.new

    puts "\n"
    input.select('Please select the gender you are most comfortable with.'.blue, cycle: true) do |menu|

        menu.choice 'Male', -> do
          select_sound
          self.gender = "Male"
          self.save
          clear_screen
        end

        menu.choice 'Female', -> do
          select_sound
          self.gender = "Female"
          self.save
          clear_screen
        end

      menu.choice 'Non-Binary', -> do
        select_sound
        self.gender = "Non_binary"
        self.save
        clear_screen
      end
    end
  end
end
