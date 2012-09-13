class Profile < ActiveRecord::Base
  # asociacion:
  belongs_to :user
  belongs_to :ibox
  has_many :schedules, :dependent => :destroy
  has_many :accessories, :through => :schedules

  # atributos
  attr_accessible :isActive, :name, :accessory_ids, :schedules_attributes
  accepts_nested_attributes_for :schedules
  
  def self.destroyAll
    Profile.destroy_all
  end
  
end