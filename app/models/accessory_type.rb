class AccessoryType < ActiveRecord::Base
  # asociaciones
  has_many :accessories
  # has_many :through para perfiles
  has_many :profile_accessories_containers
  has_many :profiles, :through => :profile_accessories_containers
  # has_many :through para iboxs
  has_many :ibox_accessories_containers
  has_many :iboxes, :through => :ibox_accessories_containers
  # atributos
  attr_accessible :name
end
