class Encounter < ActiveRecord::Base
  belongs_to :visit
  belongs_to :pokemon
end

def pokemon_by_location
  Visit.find(self.visit_id)
end
