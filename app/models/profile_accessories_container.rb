#encoding: utf-8
class ProfileAccessoriesContainer < ActiveRecord::Base
  # asociacion:
  belongs_to :profile
  belongs_to :accessory_type
  has_many :actions
  has_and_belongs_to_many :accessories
  # atributos:
  attr_accessible :name
end
