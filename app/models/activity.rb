class Activity < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :ibox
  attr_accessible :actioner, :action, :actioned, :comment, :ibox_id
end
