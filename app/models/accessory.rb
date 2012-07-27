class Accessory < ActiveRecord::Base
  # asociaciones:
  #belongs_to :accessory_types
  # has_many :through para perfiles
  #has_many :profile_accessories_container_accessories
  #has_many :profile_accessories_containers, :throught => :profile_accessories_container_accessories
  # has_many :through para iboxs
  #has_many :ibox_accessories_container_accessories
  #has_many :ibox_accessories_containers, :throught => :ibox_accessories_container_accessories
  # atributos
  attr_accessible :isScheduled, :name, :zid, :kind, :alias, :cmdclass, :state, :isScheduled
  
end
