class Trainer < ActiveRecord::Base
  has_many :locations, through: :visits
  has_many :encounters, through: :visits
  has_many :visits

  def go_to_location(location_name)
    v = find_location(location_name)
    Visit.create(location_id: v.id, trainer_id: self.id)
  end

  def find_location(location_name)
    Location.find_by name: location_name
  end

  def look_for_pokemon
    #generates random pokemon from array
    found_pokemon = Pokemon.find_by(pokedex_id: rand(1..151))
    p "A wild #{found_pokemon.name} has appeared!"
    catch_pokemon(found_pokemon)
    # Encounter.all
  end

  def catch_pokemon(found_pokemon)
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

  # def current_location_by_visit
  #   Visit.last.id
  # end
  #
  # def current_visit
  # end
end
