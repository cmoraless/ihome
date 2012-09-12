class Action < ActiveRecord::Base
  # asociaciones:
  has_and_belongs_to_many :schedules
  # atributos
  attr_accessible :dayBegin, :dayEnd, :isReiterative, :timeStart, :timeEnd
end
