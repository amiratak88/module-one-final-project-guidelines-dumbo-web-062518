class Visit < ActiveRecord::Base
  has_many :pokemons, through: :encounters
  belongs_to :locations
  belongs_to :trainers
  has_many :encounters
end
