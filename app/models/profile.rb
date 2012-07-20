class Profile < ActiveRecord::Base
  # asociacion:
  belongs_to :user
  belongs_to :ibox
  # has_many :through
  has_many :profile_accesories_containers
  has_many :accesory_types, :through => :profile_accesories_containers
  # atributos
  attr_accessible :isActive, :name
end
