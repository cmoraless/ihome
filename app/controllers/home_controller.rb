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
      #ret = testConnection(@ibox.ip, @ibox.port, @ibox.user,@ibox.password)
      #if (ret == false)
      #  flash[:error] = "Error en la conexion con el Ibox. Revise su configuracion o conexion local o de internet"
      #end
      
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
      #request = Net::HTTP::Get.new(uri.request_uri)
      request = Net::HTTP::Get.new(url.path + '/cgi-bin/Get.cgi?get=SET' )
      request.basic_auth user, password
      response = http.request(request)
    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Errno::ECONNREFUSED,
      Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError,SocketError => e
      ret = false
    end
    ret
  end
  
end


      
=begin      
      if (Net::HTTP.start(url.host, url.port) { |http| http.request(req) } )
        ret = true
      else
        ret = false
      end
=end      


