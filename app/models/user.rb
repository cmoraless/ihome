class User < ActiveRecord::Base
  # asociaciones:
  belongs_to :house
  has_many :profiles
  # atributos:
  set_primary_key "email"
  attr_accessible :address, :email, :isAdmin, :name, :phone, :rut
end
