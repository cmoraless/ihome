class User < ActiveRecord::Base
  # asociaciones:
  has_and_belongs_to_many :iboxes
  has_many :profiles
  
  # atributos:
  #set_primary_key 'email'
  attr_accessible :address, :email, :password, :password_confirmation, :isAdmin, :name, :phone, :rut
  attr_accessor :password
  before_save :encrypt_password
  
  #validaciones
  validates_confirmation_of :password
  validates_presence_of :password_confirmation
  validates_presence_of :password, :on => :create
  validates_presence_of :email,:name,:phone,:rut
  validates_uniqueness_of :email
  
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
