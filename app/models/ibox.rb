class Ibox < ActiveRecord::Base
  # asociaciones:
  has_many :profiles
  has_many :cameras
  has_and_belongs_to_many :users
  has_many :ibox_accessories_containers                               #  estas 2 asociaciones permiten obtener los tipos de 
  has_many :accessory_types, :through => :ibox_accessories_containers #  accesorios que tiene un ibox de manera directa
  # atributos
  attr_accessible :isActive, :name, :ip, :port, :user, :password
  #validaciones
  validates :name, :presence => true
  validates :ip, :presence => true
  validates :port, :presence => true
  validates :user, :presence => true
end
