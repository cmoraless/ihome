class Action < ActiveRecord::Base
  # asociaciones:
  belongs_to :profile_accessories_container
  has_one :accessory_type
  # atributos
  attr_accessible :hour, :state
end
