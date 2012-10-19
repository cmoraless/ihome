#encoding: utf-8
class Camera < ActiveRecord::Base
  belongs_to :ibox
  attr_accessible :ip, :name, :password, :port, :user
  #validaciones
  validates :name, :presence => {:message=> "^El nombre no puede estar en blanco."}, :length => { :in => 1..15, :message=>"^El nombre debe contener entre 1 y 15 caracteres." }
  validates :ip, :presence => {:message=> "^El DNS o IP no puede estar en blanco."}#, :format=> {:with => /^\d{1,3}[.]\d{1,3}[.]\d{1,3}[.]\d{1,3}$/, :message=>"^La IP no es valida."}
  validates :port, :presence => {:message=> "^El puerto no puede estar en blanco."}, :format=> {:with => /^\d+$/, :message=>"^El puerto debe ser numerico."}
  validates :user, :presence => {:message => "^El usuario no puede estar en blanco."}
  
end
