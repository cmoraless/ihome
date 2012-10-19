#encoding: utf-8
class User < ActiveRecord::Base
  # asociaciones:
  has_and_belongs_to_many :iboxes
  has_and_belongs_to_many :accessories
  has_many :profiles, :dependent => :destroy
  
  # atributos:
  #set_primary_key 'email'
  attr_accessible :address, :email, :password, :password_confirmation, :isAdmin, :name, :phone, :rut, :isSuperAdmin, :accessory_ids, :code
  attr_accessor :password
  before_save :encrypt_password
  
  #validaciones
  validates_confirmation_of :password, :message=> "^Las contraseñas no coinciden."
  validates_presence_of :password_confirmation, :message=>"^La contraseña no puede estar vacío."
  validates_presence_of :password,:message=>"^La confirmación de la contraseña no puede estar vacía."
  validates_presence_of :email, :message=>"^El correo no puede estar vacío."
  validates_presence_of :name, :message=>"^El nombre no puede estar vacío."
  validates_presence_of :phone, :message=>"^El teléfono no puede estar vacío."
  validates_presence_of :rut, :message=>"^El rut no puede estar vacío."
  validates_uniqueness_of :email, :message=>"^El correo ingresado ya existe."
  validates_presence_of :code
  #autenticacion
  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
  
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
  
end
