class Trainer < ActiveRecord::Base
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
    found_pokemon = Pokemon.find(rand(1..10))
    p "A wild #{found_pokemon.name} has appeared!"
    catch_pokemon(found_pokemon)
    Encounter.all
  end

  def catch_pokemon(found_pokemon)
    Encounter.create(pokemon_id: found_pokemon.id, visit_id: Visit.last.id)
  end

  def my_visits
    Visit.where(trainer_id: self.id)
  end

  def my_visit_ids
    my_visits.map {|visit| visit.id}
  end

  def my_encounters
    array = []
    my_visit_ids.each do |visit|
      if Encounter.where(visit_id: visit) != []
        array << Encounter.where(visit_id: visit)
      end
    end
    array.flatten
  end

  def my_pokemon
    my_encounters.map do |encounter|
      # if encounter != []
        Pokemon.find(encounter.pokemon_id).name
      # end
    end
  end


  # def current_location_by_visit
  #   Visit.last.id
  # end
  #
  # def current_visit
  # end
#look for pokemon
#go to another location
#add "You notice pokemon at _____ location"

#if you look for pokemon
#either find a pokemon or not.
#if not, go back to location menu
#if you do find one, it's randomized.
#catch? Run away?
#if you try to catch, there's a small chance it will escape
#if you catch, it creates an Encounter Pokemon, and you go back to Location menu.
#if you run away, go back to location menu

#any menu should have ability to check pokemon owned by trainer.
#look back and see what pokemon you caught where.
#look and see friend's collection.
#can travel around from any location.


#Methods:



  # def
  # end

end
