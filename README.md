# Pokemon Go Lite CLI
created by [Anthony Chen](https://github.com/anthonychen1109), [Peter Hargarten](https://github.com/peterth3geek), and [Daniel Chung](https://github.com/dlchung)

This project is using Ruby and ActiveRecord, along with Sqlite3 for database management. Data is taken from 3 API sources including [Google Places API](https://developers.google.com/places/web-service/intro), [PokeAPI](https://pokeapi.co/), and [OpenWeatherMap](https://openweathermap.org/api).

### Setup Instructions

Install required gems:

    bundle install

You may get an error when installing the rmagick gem in Mac OSX High Sierra. Use this [fix](https://blog.francium.tech/installing-rmagick-on-osx-high-sierra-7ea71f57390d) or enter the commands below into terminal:

    brew uninstall imagemagick
    brew install imagemagick@6
    export PATH="/usr/local/opt/imagemagick@6/bin:$PATH"
    brew link --force imagemagick@6
    gem install rmagick

To run:

    ruby bin/run.rb

## Screenshots
!(media/screenshots/start.png)

!(media/screenshots/create_trainer.png)

!(media/screenshots/location.png)

!(media/screenshots/pokemon_fight.png)

!(media/screenshots/view_trainer.png)

!(media/screenshots/view_locations.png)

!(media/screenshots/view_pokemon.png)

## Project Requirements

### Option One - Data Analytics Project

1. Access a Sqlite3 Database using ActiveRecord.
2. You should have at minimum three models including one join model. This means you must have a many-to-many relationship.
3. You should seed your database using data that you collect either from a CSV, a website by scraping, or an API.
4. Your models should have methods that answer interesting questions about the data. For example, if you've collected info about movie reviews, what is the most popular movie? What movie has the most reviews?
5. You should provide a CLI to display the return values of your interesting methods.  
6. Use good OO design patterns. You should have separate classes for your models and CLI interface.

### Option Two - Command Line CRUD App

1. Access a Sqlite3 Database using ActiveRecord.
2. You should have a minimum of three models.
3. You should build out a CLI to give your user full CRUD ability for at least one of your resources. For example, build out a command line To-Do list. A user should be able to create a new to-do, see all todos, update a todo item, and delete a todo. Todos can be grouped into categories, so that a to-do has many categories and categories have many to-dos.
4. Use good OO design patterns. You should have separate models for your runner and CLI interface.
