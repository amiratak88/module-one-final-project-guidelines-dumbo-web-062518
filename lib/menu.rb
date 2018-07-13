def clear_screen
  system "clear"
end

def start_game
  system "killall afplay"
  pid = fork{ exec 'afplay', './media/pokemon_opening.mp3' }

  clear_screen
  Catpix::print_image "./media/images/pokemon_logo.png",
    :limit_x => 0.5,
    :limit_y => 0.5,
    :center_x => false,
    :center_y => false,
    :resolution => "auto"

  puts "\n\n\n\n\n"

  login_user
end

def login_user
  prompt = TTY::Prompt.new
  trainer_name = prompt.ask('What is your trainer\'s name? (case-sensitive)'.blue) do |q|
    q.required true
    q.convert :string
  end

  if Trainer.all.find_by(name: trainer_name)
    active_trainer = Trainer.all.find_by(name: trainer_name)
    clear_screen
    puts "Welcome back, #{active_trainer.name}!".green
    visit = Visit.where("trainer_id='#{active_trainer.id}'").last
    $current_location = Location.find(visit.location_id)
    location_menu(active_trainer)
  else
    active_trainer = Trainer.create(name: trainer_name)
    active_trainer.go_to_location
    clear_screen
    puts "Welcome #{active_trainer.name}!".green
    active_trainer.get_gender
    location_menu(active_trainer)
  end
end

def quit_option(active_trainer, menu)
  menu.choice 'Quit', -> do
    system "killall afplay"
    pid = fork{ exec 'afplay', './media/menu_select.wav' }
    clear_screen
    puts "Thanks for playing!".green
    exit
  end
end

def profile_option(active_trainer, menu)
  menu.choice 'View your trainer profile', -> do
    system "killall afplay"
    pid = fork{ exec 'afplay', './media/menu_select.wav' }
    pid = fork{ exec 'afplay', './media/pokemon_center.mp3' }
    clear_screen
    trainer_menu(active_trainer)
  end
end

def location_menu(active_trainer)
  system "killall afplay"
  pid = fork{ exec 'afplay', './media/palette_town_theme.mp3' }
  my_location = Location.find($current_location.id).name
  puts "\n"
  puts "You are at #{my_location}".yellow
  puts "You see #{Location.fetch_weather($current_location.latitude, $current_location.longitude)}".yellow
  puts "#{Location.fetch_weather_icon($current_location.latitude, $current_location.longitude)}"
  # puts "#{Location.fetch_weather_icon($current_location.latitude, $current_location.longitude))}"
  input = TTY::Prompt.new

  puts "\n"
  input.select("What do you want to do?".blue, cycle: true) do |menu|
    menu.choice 'Look for pokemon', -> do
      pid = fork{ exec 'afplay', './media/menu_select.wav' }
      clear_screen
      encounter_menu(active_trainer)
      location_menu(active_trainer)
    end

    menu.choice 'Go to another location', -> do
      pid = fork{ exec 'afplay', './media/menu_select.wav' }

      prompt = TTY::Prompt.new

      next_location = prompt.ask("Where do you want to go?".blue) do |q|
        q.required true
        q.convert :string
      end

      active_trainer.go_to_location(next_location)
      # next_location_formatted = active_trainer.display_location(next_location)
      next_location_formatted = active_trainer.get_location_name(next_location)

      clear_screen
      Catpix::print_image "./media/images/pokebike.gif",
        :limit_x => 0.5,
        :limit_y => 0.5,
        :center_x => false,
        :center_y => false,
        :resolution => "auto"

      puts "\n\n\n\n\n"
      spinner = TTY::Spinner.new("[:spinner] Traveling to #{next_location_formatted} [:spinner]".magenta, format: :spin_2)
      spinner.auto_spin
      sleep(3.5)
      spinner.stop("You have arrived!".green)
      sleep(1)
      clear_screen
      location_menu(active_trainer)
    end

    profile_option(active_trainer, menu)
    quit_option(active_trainer, menu)
  end
end

def encounter_menu(active_trainer)
  my_location = Location.find($current_location.id).name
  weather = Location.weather_pokemon(active_trainer.latitude(my_location), active_trainer.longitude(my_location)).downcase
  found_pokemon = Pokemon.generate_pokemon_type(weather)

  input = TTY::Prompt.new

  puts "\n"
  input.select('What do you want to do?'.blue, cycle: true) do |menu|

    menu.choice 'Fight!', -> do
      pid = fork{ exec 'afplay', './media/menu_select.wav' }
      system "killall afplay"
      pid = fork{ exec 'afplay', './media/battle_vs_trainer.mp3' }
      battle_menu(found_pokemon, 1000, active_trainer)
    end

    menu.choice 'Run away!', -> do
      pid = fork{ exec 'afplay', './media/menu_select.wav' }
      clear_screen
      location_menu(active_trainer)
    end
  end
end

def trainer_menu(active_trainer)
  Catpix::print_image "./media/images/#{active_trainer.gender}_sprite.png",
    :limit_x => 0.6,
    :limit_y => 0.6,
    :center_x => false,
    :center_y => false,
    :resolution => "high"
  input = TTY::Prompt.new
  puts "\n"
  input.select("Hello trainer #{active_trainer.name}!".blue, cycle: true) do |menu|
    menu.choice 'View pokemon', -> do
      pid = fork{ exec 'afplay', './media/menu_select.wav' }
      pokemon_menu(active_trainer)
    end

    menu.choice 'View visited locations', -> do
      pid = fork{ exec 'afplay', './media/menu_select.wav' }
      visits = Visit.where("trainer_id=#{active_trainer.id}")
      clear_screen
      puts "Here are the places you've been:".yellow
      # uniq_locations = visits.map { |visit| p Location.find(visit.location_id)}
      # uniq_locations.uniq.each { |location| p location}
      active_trainer.my_locations_with_weather

      puts "\n"
      keypress = TTY::Prompt.new
      keypress.keypress("Press any key to continue...".blue.blink)

      clear_screen

      trainer_menu(active_trainer)
    end

    menu.choice 'Go back', -> do
      pid = fork{ exec 'afplay', './media/menu_select.wav' }
      sleep(0.3)
      clear_screen
      location_menu(active_trainer)
    end
  end
end

def pokemon_menu(active_trainer)
  clear_screen
  pokemon = active_trainer.my_pokemon
  active_trainer.encounters.reload
  puts "\n"
  if active_trainer.encounters == []
    input = TTY::Prompt.new
    puts "\n"
    input.select('Get out there and catch some Pokemon!'.yellow, cycle: true) do |menu|
      puts "It looks like you haven't caught any pokemon yet, #{active_trainer.name}!".yellow
      menu.choice 'Go back', -> do
        pid = fork{ exec 'afplay', './media/menu_select.wav' }
        clear_screen
        trainer_menu(active_trainer)
      end
    end
  else
    # clear_screen
    puts "Here are your pokemon:".yellow
    active_trainer.my_pokemon_with_id

    input = TTY::Prompt.new
    print "\n"
    input.select('What do you want to do?'.blue, cycle: true) do |menu|

      menu.choice 'Release a pokemon', -> do
      pid = fork{ exec 'afplay', './media/menu_select.wav' }
      prompt = TTY::Prompt.new

      is_valid_encounter_id = false

      while is_valid_encounter_id == false
        poke_id = prompt.ask("Enter a pokemon id to release: ".blue) do |q|
          q.required true
          q.validate(/^\d+$/, 'Invalid ID. Please enter a number.'.red)
          q.convert :int
        end

        if !Encounter.where(id: poke_id).empty?
          is_valid_encounter_id = true

          if Encounter.find(poke_id).nickname == nil
            puts "\n"
            puts "You released #{Pokemon.find(Encounter.find(poke_id).pokemon_id).name}.  Bye #{Pokemon.find(Encounter.find(poke_id).pokemon_id).name}!".yellow
          else
            puts "\n"
            puts "You released #{Encounter.find(poke_id).nickname}.  Bye #{Encounter.find(poke_id).nickname}!".yellow
          end
        else
          puts "Invalid ID. Please enter a number.".red
        end
      end

      sleep(2)
      clear_screen

      Encounter.destroy(poke_id)
      active_trainer.encounters.reload
      pokemon_menu(active_trainer)
    end

    menu.choice 'Rename a pokemon', -> do
      pid = fork{ exec 'afplay', './media/menu_select.wav' }
      prompt = TTY::Prompt.new
      result = prompt.collect do
        is_valid_encounter_id = false

        while is_valid_encounter_id == false
          poke_id = ask('Enter a pokemon id to rename: '.blue) do |q|
            q.convert :int
            q.validate(/^\d+$/, 'Invalid ID. Please enter a number.'.red)
            q.required true
          end

          if !Encounter.where(id: poke_id).empty?
            is_valid_encounter_id = true
          else
            puts "Invalid ID. Please enter a number.".red
          end
        end

        pkmn = Encounter.find(poke_id)

        question = 'Enter a name for the pokemon ' + Pokemon.find(pkmn.pokemon_id).name + ': '
        nickname = ask(question.blue) do |q|
          q.convert :string
          q.validate(/^[a-zA-Z0-9\s]*$/, 'Name must be alphanumeric.')
          q.required true
        end

        pkmn.nickname = nickname
        pkmn.save
      end

      active_trainer.encounters.reload
      pokemon_menu(active_trainer)
    end

    menu.choice 'Pokemon Location', -> do
      pid = fork{ exec 'afplay', './media/menu_select.wav' }
      prompt = TTY::Prompt.new
      result = prompt.collect do
        is_valid_encounter_id = false

        while is_valid_encounter_id == false
          poke_id = ask('Enter a pokemon id to see where you caught them!'.blue) do |q|
            q.convert :int
            q.validate(/^\d+$/, 'Invalid ID. Please enter a number.'.red)
            q.required true
          end

          if !Encounter.where(id: poke_id).empty?
            is_valid_encounter_id = true
          else
            puts "Invalid ID. Please enter a number.".red
          end
        end

        pkmn = Encounter.find(poke_id)
        puts "You caught #{Pokemon.find(pkmn.pokemon_id).name} at #{pkmn.the_place}!"
        puts "You saw #{Visit.find(pkmn.visit_id).weather} while you were there."
        sleep (5)
#display the location here
      end

      active_trainer.encounters.reload
      pokemon_menu(active_trainer)
    end

    menu.choice 'Go back', -> do
      pid = fork{ exec 'afplay', './media/menu_select.wav' }
      clear_screen
      trainer_menu(active_trainer)
    end
  end
end
end

def battle_menu(found_pokemon, pokemon_hp, active_trainer)
  input = TTY::Prompt.new

  print "\n"
  input.select('What do you want to do?'.blue, cycle: true) do |menu|

    if pokemon_hp > 0
      menu.choice 'Throw Pokeball', -> do
        pid = fork{ exec 'afplay', './media/menu_select.wav' }
        active_trainer.catch_pokemon(found_pokemon, pokemon_hp)
      end

      menu.choice 'Attack pokemon', -> do
        pid = fork{ exec 'afplay', './media/menu_select.wav' }
        active_trainer.battle_pokemon(found_pokemon, pokemon_hp)
      end
    end

    menu.choice 'Run away!!!', -> do
      pid = fork{ exec 'afplay', './media/menu_select.wav' }
      clear_screen
      location_menu(active_trainer)
    end
  end
end
