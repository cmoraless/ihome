class Profile < ActiveRecord::Base
  # asociacion:
  belongs_to :user
  belongs_to :ibox
  has_and_belongs_to_many :accessories

  # atributos
  attr_accessible :isActive, :name, :accessory_ids
end
