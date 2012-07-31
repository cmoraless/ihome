class Profile < ActiveRecord::Base
  # asociacion:
  belongs_to :user
  belongs_to :ibox
  has_many :profile_accessories_containers

  # atributos
  attr_accessible :isActive, :name
end
