class Accessory < ActiveRecord::Base
  # asociaciones:
  belongs_to :accessory_type
  has_and_belongs_to_many :profiles
  has_and_belongs_to_many :users
  has_and_belongs_to_many :ibox_accessories_containers
  # atributos
  attr_accessible :name, :zid, :kind, :value, :cmdclass, :state, :isScheduled, :isPublic, :user_ids
  
end
