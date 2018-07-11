def clear_screen
  system "clear"
end

def start_game
  clear_screen
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

def quit_option(active_trainer, menu)
  menu.choice 'Quit', -> do
    p "Thanks for playing!"
    exit
  end
end

def profile_option(active_trainer, menu)
  menu.choice 'View your trainer profile', -> do
    trainer_menu(active_trainer)
  end
end

def location_menu(active_trainer)
  p "You are at the: #{Location.find($current_location.id).name}"
  input = TTY::Prompt.new

  input.select("What do you want to do?", cycle: true) do |menu|
    menu.choice 'Look for pokemon', -> do
      # clear_screen
      encounter_menu(active_trainer)
      location_menu(active_trainer)
    end

    menu.choice 'Go to another location', -> do
      # clear_screen
      puts "Where do you want to go?"
      active_trainer.go_to_location(gets.chomp)
      # clear_screen
      location_menu(active_trainer)
    end

    profile_option(active_trainer, menu)
    quit_option(active_trainer, menu)
  end
end

def encounter_menu(active_trainer)
  found_pokemon = Pokemon.generate_pokemon

  input = TTY::Prompt.new

  input.select('What do you want to do?', cycle: true) do |menu|
    menu.choice 'Catch pokemon', -> do
      active_trainer.catch_pokemon(found_pokemon)
    end

    menu.choice 'Run away!', -> do
      location_menu(active_trainer)
    end

    quit_option(active_trainer, menu)
  end
end

def trainer_menu(active_trainer)

  input = TTY::Prompt.new
  input.select('Hello trainer #{active_trainer.name}', cycle: true) do |menu|
    menu.choice 'View pokemon', -> do
      pokemon_menu(active_trainer)
    end

    menu.choice 'View visited locations', -> do
      isits = Visit.where("trainer_id=#{active_trainer.id}")
      uniq_locations = visits.map { |visit| Location.find(visit.location_id).name }
      uniq_locations.uniq.each { |location| p location }
      # clear_screen
      trainer_menu(active_trainer)
    end

    menu.choice 'Go back', -> do
      location_menu(active_trainer)
    end
  end
end

def pokemon_menu(active_trainer)
  pokemon = active_trainer.my_pokemon

  p "Here are your pokemon:"
  active_trainer.my_pokemon_with_id

  input = TTY::Prompt.new
  input.select('What do you want to do?', cycle: true) do |menu|

    menu.choice 'Release a pokemon', -> do
      p "Enter a pokemon id to release."
      input2 = gets.chomp
      Encounter.destroy(input2)
      trainer_menu(active_trainer)
    end

    menu.choice 'Rename a pokemon', -> do
      p "Enter a pokemon id to rename"
      input3 = gets.chomp
      p "Enter a name for the pokemon #{Pokemon.find(Encounter.find(input3).pokemon_id).name}"
      input4 = gets.chomp
      Encounter.find(input3).update(nickname: input4)
      p Encounter.find(input3).nickname
      p "Changed name"
      # clear_screen
      pokemon_menu(active_trainer)
    end

    menu.choice 'Go back', -> do
      trainer_menu(active_trainer)
    end
  end
end
