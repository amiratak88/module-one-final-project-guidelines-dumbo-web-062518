class AddGenderColumnToTrainers < ActiveRecord::Migration[5.0]
  def change
    add_column :trainers, :gender, :string
  end
end
