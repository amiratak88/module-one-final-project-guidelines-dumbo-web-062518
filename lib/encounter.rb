class Encounter < ActiveRecord::Base
  belongs_to :visit
  belongs_to :pokemon
end
