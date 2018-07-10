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
  p "q. Quit"
  p "t. View trainer profile"
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
  quit_option(input)
  trainer_option(input)
end

def encounter_menu
  found_pokemon = Pokemon.generate_pokemon
  p "What do you want to do?"
  p "1. Catch Pokemon"
  p "2. Run away!!!"
  p "q. Quit"
  input = gets.chomp
  case input
  when "1"
    $trainer.catch_pokemon(found_pokemon)
  when "2"
    location_menu
  end
  quit_option(input)
end

def trainer_menu
  puts "1. View Pokemon."
  puts "2. View visited locations."
  puts "3. Go back."

  input = gets.chomp

  case input
  when "1"
    p "hi"
  when "2"
    visits = Visit.where("trainer_id=#{$trainer.id}")
    uniq_locations = visits.map { |visit| Location.find(visit.location_id).name }
    uniq_locations.uniq.each { |location| p location }
  when "3"
    location_menu
  end
end

def quit_option(input)
  case input
  when "q"
    p "Thanks for playing!"
    exit
  end
end

def profile_option(input)
  case input
  when "t"
    p "You are #{$trainer.name}"
    trainer_menu
  end
end
