#encoding: utf-8
class CamerasController < ApplicationController
  before_filter :check_auth_admin, :except => [:stream_image, :testConnection]
  
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
  
  # GET /cameras/new
  # GET /cameras/new.json
  def new
    @camera = Camera.new
    respond_to do |format|
      @ibox = Ibox.find(session[:ibox_id])
      @cameras = @ibox.cameras
      format.js
    end
  end

  # GET /cameras/1/edit
  def edit
    @edit = true
    @camera = Camera.find(params[:id])
    respond_to do |format|
      @ibox = Ibox.find(session[:ibox_id])
      @cameras = @ibox.cameras
      format.js
    end
  end

  # POST /cameras
  # POST /cameras.json
  def create
    @camera = Camera.new(params[:camera])
    @repetido = false
    @currentIbox = Ibox.find(session[:ibox_id])
    @cameras = @currentIbox.cameras
    for i in 0..@cameras.length-1
      if @cameras[i][:ip] == @camera[:ip] and @cameras[i][:port] == @camera[:port]
        @repetido = true
      end
    end
    respond_to do |format|
      if @repetido == false #si la camara no esta repetida
        if @camera.save
          @ibox = Ibox.find(session[:ibox_id])
          @ibox.cameras << @camera
          @cameras = @ibox.cameras
          flash[:notice] = "Se ha creado correctamente la cámara."
          flash[:error] = ""
          format.js
        else
          format.js {render :action => 'new'}        
        end
      else
        flash[:notice] = ""
        flash[:error] = "La cámara ingresada ya existe."
        format.js {render :action=> 'new'}
      end
    end
  end

  # PUT /cameras/1
  # PUT /cameras/1.json
  def update
    @camera = Camera.find(params[:id])
    respond_to do |format|
      if @camera.update_attributes(params[:camera])
        @ibox = Ibox.find(session[:ibox_id])
        @cameras = @ibox.cameras
        flash[:notice] = "Se ha actualizado correctamente la cámara."
        flash[:error] = ""
        format.js
      else
        @edit = true
        format.js {render :action => 'edit'}
      end
    end
  end

  # DELETE /cameras/1
  # DELETE /cameras/1.json
  def destroy
    @camera = Camera.find(params[:id])
    @camera.destroy
    respond_to do |format|
      @ibox = Ibox.find(session[:ibox_id])
      @cameras = @ibox.cameras
      format.js
    end
  end
  
  def back
    respond_to do |format|
      @currentUser = User.find(session[:user_id])
      @ibox = Ibox.find(session[:ibox_id])
      @iboxes = @currentUser.iboxes
      @cameras = @ibox.cameras      
      format.js
    end
  end
 
  #funcion que muestra la imagen cuando el usuario esta navegando desde un dispositivo movil
  def stream_image
    if Ibox.find(session[:ibox_id])
      @currentIbox = Ibox.find(session[:ibox_id])
      @cameras = @currentIbox.cameras
      autorizado = false
      for i in 0..@cameras.length-1
        if @cameras[i][:id].to_s == params[:id].to_s
          autorizado = true
          break
        end
      end
      if autorizado    
        camera = Camera.find(params[:id])
        require 'net/http'
        require 'uri'
        ws = 'http://' + camera.ip + ':' + camera.port
        url = URI.parse(ws)
        if testConnection(params[:id]) == true  
          begin
            req = Net::HTTP::Get.new(url.path + '/image/jpeg.cgi')
            req.basic_auth camera.user, camera.password
            res = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }
            send_data res.body, :type=> 'image/jpeg'      
          rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
            Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError,SocketError => e
          end
        else
          redirect_to view_context.image_path('camara_error.png')
        end
      else
        redirect_to :controller=>"home", :action=>"index"
      end
    end
  end

  #funcion que prueba la conexion de la camara si es correcta en movil
  def testConnection(id)
    require 'net/http'
    require 'uri'
    camera = Camera.find(id)
    ws = 'http://' + camera.ip + ':' + camera.port
    url = URI.parse(ws)
    ret = true
    begin
      http = Net::HTTP.new(url.host, url.port)      
      http.open_timeout = 3
      http.read_timeout = 3
      response = http.start do |https|
        https.request_get(url.path + '/image/jpeg.cgi')
      end
    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Errno::ECONNREFUSED,Errno::EHOSTUNREACH,
      Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError,SocketError => e
      ret = false
    end
    ret    
  end
  
  def camCommand2
    require 'net/http'
    require 'uri'
    
    url = 'http://' +  params[:ip] + ':' +  params[:port] + '/' + params[:instruction]
    logger.debug "#################################### URL= #{url}" 

    resp = Net::HTTP.get_response(URI.parse(url))
    logger.debug "#################################### respuesta= #{resp.body}"     
    format.js
  end   
  
  def camCommand  
    require 'net/http'
  
    url = 'http://' +  params[:ip] + ':' +  params[:port] + '/' + params[:instruction]
    uri = URI(url)
    http = Net::HTTP.new(url)
    request = Net::HTTP::Get.new(uri.request_uri)
    request['Cookie'] = "user=admin"
    request['Cookie'] = "usr=admin"
    request['Cookie'] = "pwd=admin"
    request['Cookie'] = "password=admin"
    request['Cookie'] = "bRememberMe=0"
    request['Cookie'] = "userLastLogin="
    request['Cookie'] = "passwordLastLogin="
    request['Cookie'] = "usrLevel=0"
    request['Cookie'] = "bShowMenu=1"
    r = http.request(request)
    logger.debug "#################################### respuesta= #{r}"     
    format.js
  end

  def camCommand3    
    require 'net/http'
    
    http = Net::HTTP.new('www.google.com')
    http.start do |sess|
      # hdrs = {}  # or {'Some_header' => 'some content'}
      # hdrs['Cookie'] = 'invalid;cookie;string--garbage1'
      hdrs = nil  # send no headers
      resp = sess.get('/', hdrs)
      case resp.code.to_i
      when 200, 302
        resp.each {|r| p r}; puts '+++++'
        cookie = resp['Set-Cookie']
        if cookie
          puts cookie.split(/;/)
          puts '-----', resp.body
        else
          puts 'No cookie received'
        end
      else
        puts "Error - code(#{resp.code}) - #{resp.msg}"
      end
    end
  end
    
end
