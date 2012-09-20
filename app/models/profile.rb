class Profile < ActiveRecord::Base
  # asociacion:
  belongs_to :user
  belongs_to :ibox
  has_many :schedules, :dependent => :destroy
  has_many :accessories, :through => :schedules

  # atributos
  attr_accessible :isActive, :name, :accessory_ids, :schedules_attributes
  accepts_nested_attributes_for :schedules
  

  def self.destroyAll
    time = Time.new
    currentDay = time.wday
    currentTime = time.strftime("%H:%M:00")  
    
    profiles = Profile.where(:isActive => true)
    profiles.each do |profile|
    
      schedules =  profile.schedules
      schedules.each do |schedule|
        
        startActions = schedule.actions.where("day_begin = ? AND time_start = ? AND repeat_dayly = ?", currentDay, currentTime, false)
        endActions = schedule.actions.where("day_end = ? AND time_end = ? AND repeat_dayly = ?", currentDay, currentTime, false)
        
        startDaylyActions = schedule.actions.where("time_start = ? AND repeat_dayly = ?",  currentTime, true)
        endWeeklyActions = schedule.actions.where("time_end = ? AND repeat_dayly = ?", currentTime, true)

        startActions +=  startDaylyActions
        endActions += endWeeklyActions
        
        startActions.each do |saction|
          puts "comenzo accion"
          self.control(profile.ibox.id, schedule.accessory.id, 1)
        end
        endActions.each do |eaction|
          puts "termino accion"
          self.control(profile.ibox.id, schedule.accessory.id, 0)
          if (eaction.repeat_weekly == false)
            eaction.destroy
          end
        end
      end
    end
  end
  
  def self.control(ibox_id, accessory_id, option)
    puts "hola" + ibox_id.to_s
    require 'net/http'
    require 'uri'
    ibox = Ibox.find(ibox_id)
    accessory = Accessory.find(accessory_id)
    ip = ibox.ip
    port = ibox.port
    ws = 'http://' + ip + ':' + port
    url = URI.parse(ws)
    begin
      # encendido
      if option == 1
        if accessory.kind == 'MultiLevelSwitch'
          req = Net::HTTP::Get.new(url.path + '/cgi-bin/Switch.cgi?VALUE=' + '9' + '&ZID=' + accessory.zid)
          accessory.update_attribute(:value, 9)
        end
        if accessory.kind == 'BinarySwitch'
          req = Net::HTTP::Get.new(url.path + '/cgi-bin/Switch.cgi?OP=' + '1' + '&ZID=' + accessory.zid)
          accessory.update_attribute(:value, 1)
        end
      # apagado
      else
        if accessory.kind == 'MultiLevelSwitch'
          req = Net::HTTP::Get.new(url.path + '/cgi-bin/Switch.cgi?VALUE=' + '0' + '&ZID=' + accessory.zid)
          accessory.update_attribute(:value, 0)
        end
        if accessory.kind == 'BinarySwitch'
          req = Net::HTTP::Get.new(url.path + '/cgi-bin/Switch.cgi?OP=' + '0' + '&ZID=' + accessory.zid)
          accessory.update_attribute(:value, 0)
        end          
      end
      req.basic_auth 'root', ''
      res = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }
    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
      Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError,SocketError => e
    end
  end


end