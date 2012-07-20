class Action < ActiveRecord::Base
  # asociaciones:
  belongs_to :profile_accesories_container
  has_one :accesory_type
  # atributos
  attr_accessible :hour, :state
end
