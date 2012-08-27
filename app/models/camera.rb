class Camera < ActiveRecord::Base
  belongs_to :ibox
  attr_accessible :ip, :name, :password, :port, :user
  #validaciones
  validates :ip, :presence => true
  validates :port, :presence => true
  validates :user, :presence => true
  
end
