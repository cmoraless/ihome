class ProfileAccessoriesContainer < ActiveRecord::Base
  # asociacion:
  belongs_to :profile
  belongs_to :accessory_type
  has_one :action
  has_and_belongs_to_many :accessories
  # atributos:
  attr_accessible :name
end
