class ProfileAccesoriesContainer < ActiveRecord::Base
  # asociacion:
  belongs_to :perfil
  has_one :accesory_type
  has_one :action
  # has_many :through para accesorios
  has_many :profile_accesories_container_accesories
  has_many :accesories, :through => :profile_accesories_container_accesories
  # has_many :through para tipos de accesorios
  belongs_to :profile
  belongs_to :accesory_type
  # atributos:
  attr_accessible :name
end
