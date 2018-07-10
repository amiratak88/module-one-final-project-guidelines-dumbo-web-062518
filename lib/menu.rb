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
  system "clear"

  case input
  when "1"
    system "clear"
    encounter_menu
    location_menu
  when "2"
    puts "Where do you want to go?"
    $trainer.go_to_location(gets.chomp)
    system "clear"
    location_menu
  end
  quit_option(input)
  profile_option(input)
end

def encounter_menu
  found_pokemon = Pokemon.generate_pokemon
  trainer = Trainer.find($trainer.id)
  p "What do you want to do?"
  p "1. Catch Pokemon"
  p "2. Run away!!!"
  p "q. Quit"
  input = gets.chomp
  system "clear"
  case input
  when "1"
    trainer.catch_pokemon(found_pokemon)
  when "2"
    system "clear"
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
    $trainer.my_pokemon.each { |pokemon| p pokemon }
    pokemon_menu
  when "2"
    visits = Visit.where("trainer_id=#{$trainer.id}")
    uniq_locations = visits.map { |visit| Location.find(visit.location_id).name }
    uniq_locations.uniq.each { |location| p location }
    trainer_menu
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

def pokemon_menu
  trainer = Trainer.find($trainer.id)
  pokemon = trainer.my_pokemon

  p "Here are your pokemon:"
  trainer.my_pokemon_with_id
  # pokemon.each {|pokemon| p "#{pokemon.id} - #{pokemon.name}"}
  p "What do you want to do?"
  p "1. Release a pokemon"
  p "2. Rename a pokemon"
  p "3. Go back."
  input = gets.chomp
  case input
  when "1"
    p "Enter a pokemon id to release."
    input2 = gets.chomp
    Encounter.destroy(input2)
    trainer_menu
  when "2"
    p "Enter a pokemon id to rename"
    input3 = gets.chomp
    p "Enter a name for the pokemon #{Encounter.find(input3)}"
    input4 = gets.chomp
    Encounter.find(input3).update(nickname: input4)
    p Encounter.find(input3).nickname
  when "3"
    trainer_menu
  end
end
