class User < ActiveRecord::Base
  # asociaciones:
  has_and_belongs_to_many :iboxes
  has_many :profiles
  # atributos:
  set_primary_key 'email'
  attr_accessible :address, :email, :password, :isAdmin, :name, :phone, :rut
  validates_uniqueness_of :email
end
