class House < ActiveRecord::Base
  # asociaciones:
  has_many :iboxes
  has_many :users
  # atributos
  attr_accessible :address, :state
end
