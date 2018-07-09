class Visit < ActiveRecord::Base
  has_many :encounters
  belongs_to :locations
  belongs_to :trainers
end
