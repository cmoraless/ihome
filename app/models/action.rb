class Action < ActiveRecord::Base
  # asociaciones:
  has_and_belongs_to_many :schedules
  # atributos
  attr_accessible :dayBegin, :dayEnd, :repeatAtWeek, :repeatAtDay, :timeStart, :timeEnd
end
