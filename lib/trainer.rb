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

  def catch_pokemon(found_pokemon)
    Encounter.create(pokemon_id: found_pokemon.id, visit_id: Visit.last.id)
  end

  def my_pokemon
    self.encounters.map {|encounter| Pokemon.find(encounter.pokemon_id).name}
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
end
