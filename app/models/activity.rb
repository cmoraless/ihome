class Activity < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :accessory
  belongs_to :ibox
  belongs_to :profile
  belongs_to :user
  attr_accessible :value, :comment, :ibox_id, :profile_id, :accessory_id, :user_id, :created_at
end
