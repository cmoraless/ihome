class Ibox < ActiveRecord::Base
  # asociaciones:
  belongs_to :house
  has_many :profiles
  # has_many :through para tipos de accesorios
  has_many :ibox_accesories_containers
  has_many :accesory_types, :through => :ibox_accesories_containers
  # atributos
  attr_accessible :isActive, :name
end
