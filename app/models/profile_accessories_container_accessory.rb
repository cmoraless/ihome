class ProfileAccessoriesContainerAccessory < ActiveRecord::Base
  # asociaciones:
  belongs_to :profile_accessories_container
  belongs_to :accessory
  # atributos:
  attr_accessible :name
end
