class CreateWeatherTypesTable < ActiveRecord::Migration[5.0]
  def change
    create_table :weather_types do |t|
      t.string :type
      t.string :pokemon_type
    end
  end
end
