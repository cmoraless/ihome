class HomeController < ApplicationController
  before_filter :check_auth
  def check_auth
    if session[:user_id] == nil
      redirect_to(root_path)
    end
  end
  
  def index
    @user = User.find(session[:user_id])
    @iboxes = @user.iboxes
    # Toma ibox seleccionado o por defecto el primero
    if (params[:id])
      @ibox = Ibox.find(params[:id])
      session[:ibox_id] = @ibox.id
    else
      @ibox = @user.iboxes.first
    end  
    
    # Toma todos los contenedores del ibox
    if !@ibox.nil?
      session[:ibox_id] = @ibox.id
      @containers = IboxAccessoriesContainer.where("ibox_id = ?", @ibox.id)
      @cameras = @ibox.cameras
      #Consumo servicio de camaras para autentificarme
      require 'net/http'
      require 'uri'  
      for i in 0..@cameras.length-1
        ws = 'http://' + @cameras[i][:ip] + ':' + @cameras[i][:port]
        uri = URI.parse(ws)
        begin
          http = Net::HTTP.new(uri.host, uri.port)
          request = Net::HTTP::Get.new(uri.request_uri)
          request.basic_auth(@cameras[i][:user], @cameras[i][:password])
          response = http.request(request)
          logger.debug "#########RESPONSEEE #{response}"
        rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
          Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError,SocketError => e
        end
      end
      #logger.debug "########### CAMERAS #{@cameras}"
    else
      flash[:notice] = "Debe habilitar su Ibox en Administracion"
    end
  end
 
end
