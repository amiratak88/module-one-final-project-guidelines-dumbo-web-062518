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

  def display_location(input)
    if parse_api(location_api(input))["candidates"] == []
      p "We couldn't find that location. Sorry! Please try again, maybe being more specific."
      location_menu(active_trainer)
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

def catch_pokemon(found_pokemon, pokemon_hp)
    catch_percent = 0
    3.times do |catch|
      catch_percent += rand(1..300)
    end
    if catch_percent >= pokemon_hp
      Encounter.create(pokemon_id: found_pokemon.id, visit_id: Visit.last.id)
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
      battle_actions(found_pokemon, pokemon_hp)
    end
  end

  def pokemon_status(found_pokemon,pokemon_hp)
    if pokemon_hp <= 0
      p "OMG you have killed #{found_pokemon.name}!"
    elsif pokemon_hp < 400
      p "#{found_pokemon.name} is weak!"
    end
    pokemon_hp
  end

  def battle_pokemon(found_pokemon, pokemon_hp)
    attack_pokemon = rand(1..500)
    pokemon_hp -= attack_pokemon
    p "You attacked #{found_pokemon.name}"
    found_pokemon.display_image
    pokemon_status(found_pokemon, pokemon_hp)
    # battle_pokemon_menu
    battle_actions(found_pokemon, pokemon_hp)
  end

  def battle_actions(found_pokemon, pokemon_hp)
    input = TTY::Prompt.new

    input.select('What do you want to do?', cycle: true) do |menu|

      menu.choice 'Catch pokemon', -> do
        if pokemon_hp <= 0
          p "#{found_pokemon.name} is dead, you can't catch it."
        else
          self.catch_pokemon(found_pokemon, pokemon_hp)
        end
      end

      menu.choice 'Attack pokemon', -> do
        self.battle_pokemon(found_pokemon, pokemon_hp)
      end

      menu.choice 'Run away!!!', -> do
        system "clear"
        location_menu
      end
    # quit_option(input, self)
    end
  end

  def my_pokemon
    self.encounters.map {|encounter| Pokemon.find(encounter.pokemon_id).name}
  end

  def my_pokemon_with_id
    # self.encounters.map {|encounter| encounter.id}
    self.encounters.each do |encounter|
      if encounter.nickname == nil
        p "<========================>"
        p "#{Pokemon.find(encounter.pokemon_id).name} - #{encounter.id}"
        p "#{Pokemon.find(encounter.pokemon_id).types}"
        Pokemon.find(encounter.pokemon_id).display_image_small
      else
        p "<========================>"
        p "#{Pokemon.find(encounter.pokemon_id).name} - #{encounter.id} - #{encounter.nickname}"
        p "#{Pokemon.find(encounter.pokemon_id).types}"
        Pokemon.find(encounter.pokemon_id).display_image_small
      end
    end
  end
end
