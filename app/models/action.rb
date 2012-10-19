#encoding: utf-8
class Action < ActiveRecord::Base
  # asociaciones:
  has_and_belongs_to_many :schedules
  # atributos
  attr_accessible :day_begin, :day_end, :repeat_weekly, :repeat_dayly, :time_start, :time_end
end
