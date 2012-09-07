class Schedule < ActiveRecord::Base
  # asociaciones:
  belongs_to :profile
  belongs_to :accessory
  # atributos:
  attr_accessible :dayBegin, :dayEnd, :isReiterative, :timeStart, :timeEnd, :profile_ids, :profile_attributes 
end
