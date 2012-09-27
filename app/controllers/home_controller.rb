class HomeController < ApplicationController
  before_filter :check_mobile, :only => [:index]
  before_filter :check_user
  
  def check_user
    if User.exists?(session[:user_id]) == false
      redirect_to(root_path)
    end
  end
  
  def check_mobile
    if request.user_agent =~ /Android/i
      session[:mobile] = true
    elsif request.user_agent =~ /BlackBerry/i
      session[:mobile] = true
    elsif request.user_agent =~ /iPhone|iPad|iPod/i
      session[:mobile] = true
    elsif request.user_agent =~ /IEMobile/i
      session[:mobile] = true
    else
      session[:mobile] = false
    end
  end
  
  def changeIbox
    session[:ibox_id] = params[:id]
    redirect_to :controller=> "home", :action=>"index"
  end
  
  def index
    @user = User.find(session[:user_id])
    @iboxes = @user.iboxes
    @profiles = @user.profiles
    #si existe la session[:ibox_id] lo busca, si no pesca el primer ibox del usuario
    if session[:ibox_id]
      @ibox = Ibox.find(session[:ibox_id])
    else
      @ibox = @user.iboxes.first
    end
    
    if !@ibox.nil? #si existe el ibox del usuario agarrado anteriormente =>  Toma todos los contenedores del ibox
      session[:ibox_id] = @ibox.id
      @containers = IboxAccessoriesContainer.where("ibox_id = ?", @ibox.id)
      @cameras = @ibox.cameras
      ret = testConnection(@ibox.ip, @ibox.port, @ibox.user,@ibox.password)
      if (ret == false)
        flash[:error] = "No se ha podido establecer comunicacion con el Ibox. Revise su configuracion o conexion a internet."
      else
        #chequeo el estado de los accesorios y los updateo a su estado
        @containers.each do |container|
          container.accessories.each do |accessory|
            resacc = iboxExecute(@ibox.ip, @ibox.port, '/cgi-bin/Status.cgi?ZID=' + accessory.zid,@ibox.user,@ibox.password)
            accessory.update_attribute(:value, resacc[2].to_s.split('=')[1])
          end
        end
      end
      
    else
      flash[:notice] = "Debe habilitar su Ibox en Administracion"
    end
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
    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Errno::ECONNREFUSED, Errno::EHOSTUNREACH,
      Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError,SocketError => e
      ret = false
    end
    ret
  end
  
  # Descripción: Función que ejecuta comandos para un determinado Ibox
  # Entrada: 
  # Salida: Arreglo con la salida del comando
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
  
end



