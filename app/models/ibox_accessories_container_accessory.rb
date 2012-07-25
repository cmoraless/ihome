class IboxAccessoriesContainerAccessory < ActiveRecord::Base
  # asociaciones:
  belongs_to :ibox_accessories_container
  belongs_to :accessory
  #atributos
  attr_accessible :name
end
