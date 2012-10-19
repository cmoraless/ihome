#encoding: utf-8
class IboxAccessoriesContainer < ActiveRecord::Base
  # asociaciones:
  belongs_to :ibox
  belongs_to :accessory_type
  has_and_belongs_to_many :accessories
  # atributos:
  attr_accessible :name
end
