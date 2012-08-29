class AccessoriesController < ApplicationController
  #ACA HACER LOS BEFORE FILTERS
  
  # GET /accessories/new
  # GET /accessories/new.json
  def new
    @accessory = Accessory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @accessory }
    end
  end

  # GET /accessories/1/edit
  def edit
    @accessory = Accessory.find(params[:id])
  end

  # POST /accessories
  # POST /accessories.json
  def create
    @accessory = Accessory.new(params[:accessory])

    respond_to do |format|
      if @accessory.save
        format.html { redirect_to @accessory, notice: 'Accessory was successfully created.' }
        format.json { render json: @accessory, status: :created, location: @accessory }
      else
        format.html { render action: "new" }
        format.json { render json: @accessory.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /accessories/1
  # PUT /accessories/1.json
  def update
    @accessory = Accessory.find(params[:id])

    respond_to do |format|
      if @accessory.update_attributes(params[:accessory])
        @ibox = Ibox.find(session[:ibox_id])
        @containers = IboxAccessoriesContainer.where("ibox_id = ?", @ibox.id)
        @accessories = []
        @containers.each do |container|
        @accessories << container.accessories
        logger.debug "############### #{container.accessories[0][:name]}"
      end  
        format.js
      else
        format.js { render :action => "edit" }
      end
    end
  end

  # DELETE /accessories/1
  # DELETE /accessories/1.json
  def destroy
    @accessory = Accessory.find(params[:id])
    @accessory.destroy

    respond_to do |format|
      format.html { redirect_to accessories_url }
      format.json { head :no_content }
    end
  end
  
  def control
    #logger.debug "######## ENTRE A CONTROL #######"
    require 'net/http'
    require 'uri'
    ibox = Ibox.find(session[:ibox_id])
    ip = ibox.ip
    port = ibox.port
    ws = 'http://' + ip + ':' + port
    url = URI.parse(ws)
    #params[:zid] = '0016E62703';
    #params[:value] = '1' 
    begin
      if params[:kind] == 'MultiLevelSwitch'
        req = Net::HTTP::Get.new(url.path + '/cgi-bin/Switch.cgi?VALUE=' + params[:value] + '&ZID=' + params[:zid])
      end
      if params[:kind] == 'BinarySwitch' or params[:kind] == 'BinarySensor'
        req = Net::HTTP::Get.new(url.path + '/cgi-bin/Switch.cgi?OP=' + params[:value] + '&ZID=' + params[:zid])
      end
      req.basic_auth 'root', ''
      res = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }
      @body = res.body
      @accessory = Accessory.find_by_zid(params[:zid])
      @accessory.update_attribute(:value, params[:value].to_i)      
    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
      Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError,SocketError => e
      flash[:notice] = "Lo sentimos, el servicio no se encuentra disponible actualmente."
    end
  end
end
