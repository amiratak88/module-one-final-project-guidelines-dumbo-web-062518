def populate_pokemon
  counter = 1
  until counter == 15 do
    new_mon = Pokemon.create(pokedex_id: counter)
    new_mon.name = new_mon.display_name
    new_mon.save
    counter += 1
  end
end

populate_pokemon

peter = Trainer.create(name: "Peter")
dan = Trainer.create(name: "Dan")
anthony = Trainer.create(name: "Anthony")

flatiron = Location.create(name: "Flatiron School")
central_park = Location.create(name: "Central Park")
statue_of_liberty = Location.create(name: "Statue of Liberty")
moma = Location.create(name: "MoMA")
