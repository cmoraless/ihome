class AccesoryType < ActiveRecord::Base
  # asociaciones
  has_many :accesories
  # has_many :through para perfiles
  has_many :profile_accesories_containers
  has_many :profiles, :through => :profile_accesories_containers
  # has_many :through para iboxs
  has_many :ibox_accesories_containers
  has_many :iboxes, :through => :ibox_accesories_containers
  # atributos
  attr_accessible :name
end
