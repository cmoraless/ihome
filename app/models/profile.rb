class Profile < ActiveRecord::Base
  # asociacion:
  belongs_to :user
  belongs_to :ibox
  has_many :accessories, :through => :schedules

  # atributos
  attr_accessible :isActive, :name, :accessory_ids
end
