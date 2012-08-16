class Camera < ActiveRecord::Base
  belongs_to :ibox
  attr_accessible :ip, :name, :password, :port, :user
end
