def clear_screen
  system "clear"
end

def start_game
  puts "Enter your trainer's name"
  trainer_name = gets.chomp
  if Trainer.all.find_by(name: trainer_name)
    active_trainer = Trainer.all.find_by(name: trainer_name)
    clear_screen
    p "Welcome back, #{active_trainer.name}!"
    visit = Visit.where("trainer_id=#{active_trainer.id}").last
    $current_location = Location.find(visit.location_id)
    location_menu(active_trainer)
  else
    active_trainer = Trainer.create(name: trainer_name)
    clear_screen
    p "Welcome #{active_trainer.name}!"
    active_trainer.go_to_location
    location_menu(active_trainer)
  end
end

def location_menu(active_trainer)
  p "You are at the: #{Location.find($current_location.id).name}"
  p "What do you want to do?"
  p "1. Look for pokemon."
  p "2. Go to another location."
  p "q. Quit"
  p "t. View trainer profile"
  input = gets.chomp

  case input
  when "1"
    clear_screen
    encounter_menu(active_trainer)
    location_menu(active_trainer)
  when "2"
    clear_screen
    puts "Where do you want to go?"
    active_trainer.go_to_location(gets.chomp)
    clear_screen
    location_menu(active_trainer)
  end
  quit_option(input, active_trainer)
  profile_option(input, active_trainer)
end

def encounter_menu(active_trainer)
  found_pokemon = Pokemon.generate_pokemon
  # trainer = Trainer.find($trainer.id)
  p "What do you want to do?"
  p "1. Catch Pokemon"
  p "2. Run away!!!"
  p "q. Quit"
  input = gets.chomp
  clear_screen
  case input
  when "1"
    active_trainer.catch_pokemon(found_pokemon)
    p "You caught #{found_pokemon.name}!"
  when "2"
    clear_screen
    location_menu(active_trainer)
  end
  quit_option(input, active_trainer)
end

def trainer_menu(active_trainer)
  p "Hello trainer #{active_trainer.name}!"
  p "1. View Pokemon."
  p "2. View visited locations."
  p "3. Go back."

  input = gets.chomp

  case input
  when "1"
    # $trainer.my_pokemon.each { |pokemon| p pokemon }
    clear_screen
    pokemon_menu(active_trainer)
  when "2"
    visits = Visit.where("trainer_id=#{active_trainer.id}")
    uniq_locations = visits.map { |visit| Location.find(visit.location_id).name }
    uniq_locations.uniq.each { |location| p location }
    clear_screen
    trainer_menu(active_trainer)
  when "3"
    clear_screen
    location_menu(active_trainer)
  end
end

def quit_option(input, active_trainer)
  case input
  when "q"
    p "Thanks for playing!"
    exit
  end
end

def profile_option(input, active_trainer)
  case input
  when "t"
    clear_screen
    trainer_menu(active_trainer)
  end
end

def pokemon_menu(active_trainer)
  # trainer = Trainer.find(active_trainer.id)
  pokemon = active_trainer.my_pokemon

  p "Here are your pokemon:"
  active_trainer.my_pokemon_with_id
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
    trainer_menu(active_trainer)
  when "2"
    p "Enter a pokemon id to rename"
    input3 = gets.chomp
    p "Enter a name for the pokemon #{Pokemon.find(Encounter.find(input3).pokemon_id).name}"
    input4 = gets.chomp
    Encounter.find(input3).update(nickname: input4)
    p Encounter.find(input3).nickname
    p "Changed name"
    clear_screen
    pokemon_menu(active_trainer)
  when "3"
    clear_screen
    trainer_menu(active_trainer)
  end
end
