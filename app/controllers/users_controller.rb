class UsersController < ApplicationController
  layout 'homeadmin', :only => [:newAdmin]
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
      format.html # new.html.erb
      format.json { render json: @user }
      format.js
    end
  end
  
  def newNoAdmin
    logger.debug "######## ENTRE A NEW NO ADMIN #######"
    @user = User.new
    render :layout => "admin"
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
      format.js
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
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
        end
        format.html { redirect_to @user, notice: 'user was successfully created.'}
        format.json { render json: @user, status: :created, location: @user }
      else
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
  
end
