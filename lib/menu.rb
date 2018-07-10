def start_game
  puts "Enter your trainer's name"
  trainer_name = gets.chomp
  if Trainer.all.find_by(name: trainer_name)
    $trainer = Trainer.all.find_by(name: trainer_name)
    p "Welcome back, #{$trainer.name}!"
    visit = Visit.where("trainer_id=#{$trainer.id}").last
    $current_location = Location.find(visit.location_id)
    location_menu
  else
    $trainer = Trainer.create(name: trainer_name)
    p "Welcome #{$trainer.name}!"
    $trainer.go_to_location
    location_menu
  end
end

def location_menu
  p "You are at the: #{Location.find($current_location.id).name}"
  p "What do you want to do?"
  p "1. Look for pokemon."
  p "2. Go to another location."

  input = gets.chomp

  case input
  when "1"
    encounter_menu
    location_menu
  when "2"
    puts "Where do you want to go?"
    $trainer.go_to_location(gets.chomp)
    location_menu
  end

end

def encounter_menu
  found_pokemon = Pokemon.generate_pokemon
  p "What do you want to do?"
  p "1. Catch Pokemon"
  p "2. Run away!!!"
  input = gets.chomp
  case input
  when "1"
    $trainer.catch_pokemon(found_pokemon)
  when "2"
    location_menu
  end
end
