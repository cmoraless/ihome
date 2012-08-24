class HomeController < ApplicationController
  before_filter :check_auth
  before_filter :check_mobile, :only => [:index]
  def check_auth
    if session[:user_id] == nil
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
      
      #Consumo servicio de camaras para autentificarme      
=begin
      require 'net/http'
      require 'uri'  
      for i in 0..@cameras.length-1
        ws = 'http://' + @cameras[i][:ip] + ':' + @cameras[i][:port]
        uri = URI.parse(ws)
        begin
          http = Net::HTTP.new(uri.host, uri.port)
          request = Net::HTTP::Get.new(uri.request_uri)
          #request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("mbustamante:admin")
          request.basic_auth(@cameras[i][:user], @cameras[i][:password])
          response = http.request(request)
          logger.debug "#########RESPONSEEE #{response}"
        rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
          Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError,SocketError => e
        end
      end
=end
   else
      flash[:notice] = "Debe habilitar su Ibox en Administracion"
    end
  end
 
end
