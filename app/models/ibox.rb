class Ibox < ActiveRecord::Base
  # asociaciones:
  has_many :profiles, :dependent => :destroy
  has_many :cameras, :dependent => :destroy
  has_and_belongs_to_many :users
  has_many :ibox_accessories_containers                               #  estas 2 asociaciones permiten obtener los tipos de 
  has_many :accessory_types, :through => :ibox_accessories_containers #  accesorios que tiene un ibox de manera directa
  # atributos
  attr_accessible :isActive, :name, :ip, :port, :user, :password
  #validaciones
  validates :name, :presence => {:message=> "^El nombre no puede estar en blanco."}
  validates :ip, :presence => {:message=> "^El DNS o IP no puede estar en blanco."} #, :format=> {:with => /^\d{1,3}[.]\d{1,3}[.]\d{1,3}[.]\d{1,3}$/, :message=> "^La IP no es valida."}
  validates :port, :presence => {:message => "^El puerto no puede estar en blanco"}, :format=> {:with => /^\d+$/, :message=> "^El puerto debe ser numerico."}
end