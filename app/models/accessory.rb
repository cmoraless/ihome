#encoding: utf-8
class Accessory < ActiveRecord::Base
  # asociaciones:
  belongs_to :accessory_type
  has_many :activities
  has_many :schedules
  has_many :profiles, :through => :schedules
  has_and_belongs_to_many :users
  has_and_belongs_to_many :ibox_accessories_containers
  # atributos
  attr_accessible :name, :zid, :kind, :x, :y, :w, :h, :value, :cmdclass, :state, :isScheduled, :isPublic, :user_ids, :accessory_type_id, :ibox_accessories_container_id
  # validaciones
  validates :name, :presence => {:message=> "^El nombre no puede estar vacío."}, :length => { :in => 1..12, :message=>"^El nombre debe contener entre 1 y 12 carácteres." }

 # validates :isPublic, :presence => true
end
