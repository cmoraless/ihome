class Accesory < ActiveRecord::Base
  # asociaciones:
  belongs_to :accesory_types
  # has_many :through para perfiles
  has_many :profile_accesories_container_accesories
  has_many :profile_accesories_containers, :throught => :profile_accesories_container_accesories
  # has_many :through para iboxs
  has_many :ibox_accesories_container_accesories
  has_many :ibox_accesories_containers, :throught => :ibox_accesories_container_accesories
  # atributos
  attr_accessible :isScheduled, :name, :state
end
