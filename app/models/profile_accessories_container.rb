class ProfileAccessoriesContainer < ActiveRecord::Base
  # asociacion:
  belongs_to :perfil
  has_one :accessory_type
  has_one :action
  # has_many :through para accesorios
  has_many :profile_accessories_container_accessories
  has_many :accessories, :through => :profile_accessories_container_accessories
  # has_many :through para tipos de accesorios
  belongs_to :profile
  belongs_to :accessory_type
  # atributos:
  attr_accessible :name
end
