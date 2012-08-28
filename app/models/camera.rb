class Camera < ActiveRecord::Base
  belongs_to :ibox
  attr_accessible :ip, :name, :password, :port, :user
  #validaciones
  validates :ip, :presence => true, :format=> {:with => /^\d{1,3}[.]\d{1,3}[.]\d{1,3}[.]\d{1,3}$/}
  validates :port, :presence => true, :format=> {:with => /^\d+$/}
  validates :user, :presence => true
  
end
