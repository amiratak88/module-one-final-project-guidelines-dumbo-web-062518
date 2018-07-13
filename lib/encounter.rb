class Encounter < ActiveRecord::Base
  belongs_to :visit
  belongs_to :pokemon

  def the_place
    Location.find(Visit.find(self.visit_id).location_id).name
  end

end
