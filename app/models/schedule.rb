#encoding: utf-8
class Schedule < ActiveRecord::Base
  # asociaciones:
  belongs_to :profile
  belongs_to :accessory
  has_and_belongs_to_many :actions
  # atributos:
  attr_accessible :name, :profile_ids, :profile_attributes, :actions_attributes
  accepts_nested_attributes_for :actions
end
