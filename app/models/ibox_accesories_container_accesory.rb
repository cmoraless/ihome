class IboxAccesoriesContainerAccesory < ActiveRecord::Base
  # asociaciones:
  belongs_to :ibox_accesories_container
  belongs_to :accesory
  #atributos
  attr_accessible :name
end
