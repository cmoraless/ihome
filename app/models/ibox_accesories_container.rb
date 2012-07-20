class IboxAccesoriesContainer < ActiveRecord::Base
  # asociaciones:
  has_many :ibox_accesories_container_accesories
  has_many :accesories, :through => :ibox_accesories_container_accesories
  # atributos:
  attr_accessible :name
end
