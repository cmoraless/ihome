class AccessoriesController < ApplicationController
  # GET /accessories
  # GET /accessories.json
  def index
    @accessories = Accessory.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @accessories }
    end
  end

  # GET /accessories/1
  # GET /accessories/1.json
  def show
    @accessory = Accessory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @accessory }
    end
  end

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
        format.html { redirect_to @accessory, notice: 'Accessory was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @accessory.errors, status: :unprocessable_entity }
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
    ip = '200.28.166.104'
    port = '1166'
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
    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
      Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError,SocketError => e
      flash[:notice] = "Lo sentimos, el servicio no se encuentra disponible actualmente."
    end
  end
end
