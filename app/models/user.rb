class User < ActiveRecord::Base
  # asociaciones:
  has_and_belongs_to_many :iboxes
  has_many :profiles, :dependent => :destroy
  
  # atributos:
  #set_primary_key 'email'
  attr_accessible :address, :email, :password, :password_confirmation, :isAdmin, :name, :phone, :rut, :isSuperAdmin, :accessory_ids
  attr_accessor :password
  before_save :encrypt_password
  
  #validaciones
  validates_confirmation_of :password, :message=> "^Los passwords no coinciden."
  validates_presence_of :password_confirmation, :message=>"^El password no puede estar en blanco."
  validates_presence_of :password,:message=>"^La confirmacion del password no puede estar en blanco."
  validates_presence_of :email, :message=>"^El correo no puede estar en blanco."
  validates_presence_of :name, :message=>"^El nombre no puede estar en blanco."
  validates_presence_of :phone, :message=>"^El telefono no puede estar en blanco."
  validates_presence_of :rut, :message=>"^El rut no puede estar en blanco."
  validates_uniqueness_of :email, :message=>"^El correo ingresado ya existe."
  
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
