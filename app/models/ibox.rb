#encoding: utf-8
class Ibox < ActiveRecord::Base
  # asociaciones:
  has_many :activities
  has_many :profiles, :dependent => :destroy
  has_many :cameras, :dependent => :destroy
  has_and_belongs_to_many :users
  has_many :ibox_accessories_containers, :dependent=>:destroy                               #  estas 2 asociaciones permiten obtener los tipos de 
  has_many :accessory_types, :through => :ibox_accessories_containers #  accesorios que tiene un ibox de manera directa
  # atributos
  attr_accessible :isActive, :name, :mac, :ip, :port, :user, :password
  #validaciones
  validates :name, :presence => {:message=> "^El nombre no puede estar vacío."}, :length => { :in => 1..15, :message=>"^El nombre debe contener entre 1 y 15 carácteres." }
  validates :ip, :presence => {:message=> "^El DNS o IP no puede estar vacío."} #, :format=> {:with => /^\d{1,3}[.]\d{1,3}[.]\d{1,3}[.]\d{1,3}$/, :message=> "^La IP no es valida."}
  validates :port, :presence => {:message => "^El puerto no puede estar vacío"}, :format=> {:with => /^\d+$/, :message=> "^El puerto debe ser numérico."}
  validates :mac, :presence => {:message=>"^La mac no puede estar vacía."}, :uniqueness => {:message=>"^La mac ingresada ya existe en nuestros registros."}, :format => {:with => /^[0-9A-F]{2}(?::[0-9A-F]{2}){5}$/, :message => "^Revise el formato de la mac (las letras deben ser mayusculas)."}
end