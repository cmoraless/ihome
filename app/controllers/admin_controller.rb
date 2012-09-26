class AdminController < ApplicationController
  before_filter :check_auth_admin
  
  def check_auth_admin    
    if User.exists?(session[:user_id])
      @currentUser = User.find(session[:user_id])
      if @currentUser.isAdmin == false and @currentUser.isSuperAdmin == false      
        respond_to do |format|
          format.html {redirect_to(home_index_path)}
          format.js {render :js => "window.location.replace('#{url_for(:controller => 'home', :action => 'index')}');"}
        end
      end
    else
      respond_to do |format|
        format.html {redirect_to(root_path)}
        format.js {render :js => "window.location.replace('#{url_for(:controller => 'sessions', :action => 'new')}');"}    
      end
    end
  end
  
  def changeIbox
    session[:ibox_id] = params[:id]
    redirect_to :controller=> "admin", :action=>"index"
  end
  
  def index
    @user = User.find(session[:user_id])
    @iboxes = @user.iboxes
    
    if @iboxes.empty?
      flash[:notice] = "Debe tener por lo menos un IBox para agregar/editar usuarios."
    elsif session[:ibox_id]
      @ibox = Ibox.find(session[:ibox_id])
      @users = @ibox.users
      @cameras = @ibox.cameras
      @containers = IboxAccessoriesContainer.where("ibox_id = ?", @ibox.id)
      @accessories = []
      @containers.each do |container|
        @accessories << container.accessories        
      end
      if testConnection(@ibox.ip,@ibox.port,@ibox.user,@ibox.password)
        @conditions = get_sensors_conditions
      else
        flash[:error] = "No se ha podido establecer comunicacion con el Ibox. Revise su configuracion o conexion a internet."
      end 
    end
    
  end
  
  def view
  
  end
  
  #funcion que ejecuta un comando consumiendo un webservice en el ibox que es pasado por parametro (instruction)
  def iboxExecute(ibox_ip, ibox_port, instruction, user, password)
    require 'net/http'
    require 'uri'
    ws = 'http://' + ibox_ip + ':' + ibox_port
    url = URI.parse(ws)
    begin
      req = Net::HTTP::Get.new(url.path + instruction )
      req.basic_auth user, password
      res = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }
      #escribo archivo de texto con la salida del web service
      path = Rails.root + 'tmp/server.txt'
      f_out = File.new(path,'w')
      f_out.puts res.body
      f_out.close
      res = Array.new
      f_in = File.open(path,'r') do |f|
        while line = f.gets
          res << line.to_s.chomp
        end
      end
    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
      Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError,SocketError => e
    end
    res
  end
  
  def get_sensors_conditions
    #leo las condiciones de los sensores del ibox
    @ibox = Ibox.find(session[:ibox_id])
    res = iboxExecute(@ibox.ip, @ibox.port, '/cgi-bin/Get.cgi?get=CONDITION', @ibox.user, @ibox.password)
    @conditions = Array.new
    @sensors_conditions = Array.new
    @accessories_conditions = Array.new
    containers = IboxAccessoriesContainer.where("ibox_id = ?", session[:ibox_id])    
    accessory_id = -1
    sensor_id = -1    
    for i in 0..res.length/7-1
      #busco el id del sensor y del accesorio de la condicion para mostrarlo 
      containers.each do |container|
        container.accessories.each do |accessory|
          if accessory.zid == res[0+7*i].to_s.split('=')[1].to_s
            sensor = Accessory.find(accessory.id)
            @sensors_conditions << sensor
          elsif accessory.zid == res[3+7*i].to_s.split('=')[1].to_s
            accessory = Accessory.find(accessory.id)
            @accessories_conditions << accessory
          end
        end    
      end
      @conditions << {:id => (i+1), :zid => res[0+7*i].to_s.split('=')[1], :value => res[1+7*i].to_s.split('=')[1], :hiorlo => res[2+7*i].to_s.split('=')[1], :czid => res[3+7*i].to_s.split('=')[1],
        :action => res[4+7*i].to_s.split('=')[1], :cvalue => res[5+7*i].to_s.split('=')[1], :sendmail => res[6+7*i].to_s.split('=')[1] } 
    end
    @conditions
  end
  
  def testConnection(ibox_ip, ibox_port, user, password)
    require 'net/http'
    require 'uri'
    ws = 'http://' + ibox_ip + ':' + ibox_port
    url = URI.parse(ws)
    ret = true
    begin
      http = Net::HTTP.new(url.host, url.port)      
      http.open_timeout = 3
      http.read_timeout = 3
      response = http.start do |https|
        https.request_get(url.path + '/cgi-bin/Get.cgi?get=SET')
      end
    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Errno::ECONNREFUSED,
      Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError,SocketError => e
      ret = false
    end
    ret
  end
  
  
end
