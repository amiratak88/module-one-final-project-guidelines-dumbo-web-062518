def clear_screen
  system "clear"
end

def start_game
  clear_screen
  Catpix::print_image "./media/pokemon_logo.png",
    :limit_x => 0.5,
    :limit_y => 0.5,
    :center_x => true,
    :center_y => false,
    :resolution => "auto"

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
    active_trainer.go_to_location
    clear_screen
    p "Welcome #{active_trainer.name}!"
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
  my_location = Location.find($current_location.id).name
  p "You are at #{my_location}"
  p "You see #{Location.fetch_weather(active_trainer.latitude(my_location), active_trainer.longitude(my_location))}"
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
    # menu.choice 'Catch pokemon', -> do
    #   active_trainer.catch_pokemon(found_pokemon, 1000)
    # end

    menu.choice 'Fight!', -> do
      battle_menu(found_pokemon, 1000, active_trainer)
    end

    menu.choice 'Run away!', -> do
      location_menu(active_trainer)
    end


    quit_option(active_trainer, menu)
  end
end

def trainer_menu(active_trainer)

  input = TTY::Prompt.new
  input.select("Hello trainer #{active_trainer.name}", cycle: true) do |menu|
    menu.choice 'View pokemon', -> do
      pokemon_menu(active_trainer)
    end

    menu.choice 'View visited locations', -> do
      visits = Visit.where("trainer_id=#{active_trainer.id}")
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
  clear_screen
  pokemon = active_trainer.my_pokemon
  active_trainer.encounters.reload

  p "Here are your pokemon:"
  active_trainer.my_pokemon_with_id

  input = TTY::Prompt.new
  input.select('What do you want to do?', cycle: true) do |menu|

    menu.choice 'Release a pokemon', -> do
      p "Enter a pokemon id to release."
      input2 = gets.chomp
      clear_screen
      if Encounter.find(input2).nickname == nil
        "You released #{Pokemon.find(Encounter.find(input2).pokemon_id).name}.  Bye #{Pokemon.find(Encounter.find(input2).pokemon_id).name}!"
      else
        p "You released #{Encounter.find(input2).nickname}.  Bye #{Encounter.find(input2).nickname}!"
      end
      Encounter.destroy(input2)
      active_trainer.encounters.reload
      trainer_menu(active_trainer)
    end

    menu.choice 'Rename a pokemon', -> do
      p "Enter a pokemon id to rename"
      input3 = gets.chomp
      pkmn = Encounter.find(input3)
      p "Enter a name for the pokemon #{Pokemon.find(pkmn.pokemon_id).name}"
      input4 = gets.chomp
      pkmn.nickname = input4
      pkmn.save
      active_trainer.encounters.reload
      p "Changed name to #{pkmn.nickname}"
      # clear_screen
      pokemon_menu(active_trainer)
    end

    menu.choice 'Go back', -> do
      clear_screen
      trainer_menu(active_trainer)
    end
  end
end

def battle_menu(found_pokemon, pokemon_hp, active_trainer)
  input = TTY::Prompt.new

  input.select('What do you want to do?', cycle: true) do |menu|

    if pokemon_hp > 0
      menu.choice 'Throw Pokeball', -> do
          active_trainer.catch_pokemon(found_pokemon, pokemon_hp)
      end

      menu.choice 'Attack pokemon', -> do
        active_trainer.battle_pokemon(found_pokemon, pokemon_hp)
      end
    end

    menu.choice 'Run away!!!', -> do
      clear_screen
      location_menu(active_trainer)
    end
  end
end
