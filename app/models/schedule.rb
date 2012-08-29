class Schedule < ActiveRecord::Base
  # asociaciones:
  belongs_to :profile
  belongs_to :accessory
  # atributos:
  attr_accessible :name, :mon, :tue, :wen, :thu, :fri, :sat, :sun, :isReiterative, :timeStart, :timeEnd, 
end
