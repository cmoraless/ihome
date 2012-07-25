class IboxAccessoriesContainer < ActiveRecord::Base
  # asociaciones:
  has_many :ibox_accessories_container_accessories
  has_many :accessories, :through => :ibox_accessories_container_accessories
  # atributos:
  attr_accessible :name
end
