class Encounter < ActiveRecord::Base
  belongs_to :visit
  belongs_to :pokemon
end

def pokemon_locale
  Location.find(Visit.find(self.visit_id).location_id)
end
