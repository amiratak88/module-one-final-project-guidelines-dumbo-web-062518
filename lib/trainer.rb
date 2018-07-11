class Trainer < ActiveRecord::Base
  has_many :locations, through: :visits
  has_many :encounters, through: :visits
  has_many :visits

  def go_to_location(location_name = "Flatiron School")
    v = find_location(location_name)
    Visit.create(location_id: v.id, trainer_id: self.id)
    $current_location = v
  end

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
    hp_percent = 100
    catch_percent = 0
    trainer = Trainer.find($trainer.id)
    3.times do |catch|
      catch_percent += rand(1..75)
      # p "catch_percent #{catch_percent}"
    end
    if catch_percent >= 100
      Encounter.create(pokemon_id: found_pokemon.id, visit_id: Visit.last.id)
      spinner = TTY::Spinner.new("[:spinner] Attempting to catch #{found_pokemon.name} ...", format: :spin_2)
      spinner.auto_spin # Automatic animation with default interval
      sleep(2) # Perform task
      spinner.stop("You caught #{found_pokemon.name}!") # Stop animation
      # p "You caught #{found_pokemon.name}!"
    else
      p "#{found_pokemon.name} got away!"
    end
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
