class ProfileAccesoriesContainerAccesory < ActiveRecord::Base
  # asociaciones:
  belongs_to :profile_accesories_container
  belongs_to :accesory
  # atributos:
  attr_accessible :name
end
