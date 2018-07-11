def populate_pokemon
  counter = 1
  until counter == 15 do
    new_mon = Pokemon.create(pokedex_id: counter)
    new_mon.name = new_mon.display_name
    new_mon.types = new_mon.get_types
    new_mon.save
    counter += 1
  end
end

populate_pokemon
