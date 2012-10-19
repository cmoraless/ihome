#encoding: utf-8
class AccessoryType < ActiveRecord::Base
  # asociaciones
  has_many :accessories
  has_many :actions
  has_many :profile_accessories_containers
  has_many :iboxes, :through => :ibox_accessories_containers
  # atributos
  attr_accessible :name
  # validaciones
  validates_presence_of :name, :message => "^El nombre no puede estar en blanco."
end
