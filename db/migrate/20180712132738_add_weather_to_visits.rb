class AddWeatherToVisits < ActiveRecord::Migration[5.0]
  def change
    add_column :visits, :weather, :string
  end
end
