class Action < ActiveRecord::Base
  # asociaciones:
  belongs_to :profile_accessories_container
  belongs_to :accessory_type
  # atributos
  attr_accessible :hour, :state
end
