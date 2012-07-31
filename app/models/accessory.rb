class Accessory < ActiveRecord::Base
  # asociaciones:
  belongs_to :accessory_types
  has_and_belongs_to_many :profile_accessories_containers
  has_and_belongs_to_many :ibox_accessories_containers
  # atributos
  attr_accessible :name, :zid, :value, :cmdclass, :state, :isScheduled
  
end
