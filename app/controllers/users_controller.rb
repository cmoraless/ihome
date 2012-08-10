class UsersController < ApplicationController
  layout 'homeadmin', :only => [:newAdmin]
  layout 'admin', :only => [:newNoAdmin]
  # GET /users
  # GET /users.json
  def index
    @users = User.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def newAdmin
    @user = User.new
    respond_to do |format|
      #format.html # new.html.erb
      #format.json { render json: @user }
      format.js
    end
  end
  
  def newNoAdmin
    #logger.debug "######## ENTRE A NEW NO ADMIN #######"
    @remoto = false
    @user = User.new
    respond_to do |format|
      #format.html # new.html.erb
      #format.json { render json: @user }
      format.js
    end
  end

  # GET /users/1/edit
  def edit
    @remoto = true
    @user = User.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        if @user.isAdmin == false
          @ibox = Ibox.find(session[:ibox_id])
          @ibox.users << @user
          format.html { redirect_to :controller=>'admin', :action=>'index'}
          format.js
        else 
          format.html { redirect_to :controller=>'homeadmin', :action=>'index'}
        end
      else
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @remoto = true
    @user = User.find(params[:id])
    if @user.isAdmin == false
      @ibox = Ibox.find(session[:ibox_id])
      @users = @ibox.users
    end
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.js
      else
        format.js
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    isAdmin = true
    @user = User.find(params[:id])
    if @user.isAdmin == false
      isAdmin = false
    end
    @user.destroy
    if isAdmin == false
      @ibox = Ibox.find(session[:ibox_id])
      @users = @ibox.users
    end
    respond_to do |format|
      format.js
    end
  end
  
end
