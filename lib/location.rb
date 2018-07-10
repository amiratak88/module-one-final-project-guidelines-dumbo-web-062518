class Location <ActiveRecord::Base
  has_many :trainers, through: :visits
  has_many :encounters, through: :visits
  has_many :visits
end
