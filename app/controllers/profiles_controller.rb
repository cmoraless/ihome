class ProfilesController < ApplicationController
  # GET /profiles
  # GET /profiles.json
  def index
    @profiles = Profile.all
    @user = User.find(session[:user_id])
    @perfiles = @user.profiles
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @profiles }
    end
  end
  
  
  def control
    @profile = Profile.find_by_id(params[:id])
    @profile.update_attribute(:isActive, params[:value])   
  end


  # GET /profiles/1
  # GET /profiles/1.json
  def show
    @profile = Profile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @profile }
    end
  end

  # GET /profiles/new
  # GET /profiles/new.json
  def new
    @profile = Profile.new
    @user = User.find(session[:user_id])
    @ibox = Ibox.find(session[:ibox_id])
    respond_to do |format|
      format.js
    end
  end

  # GET /profiles/1/edit
  def edit
    @user = User.find(session[:user_id])
    @profile = Profile.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  # GET /profiles/1/edit
  def schedule  
    @user = User.find(session[:user_id])
    @profile = Profile.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  # POST /profiles
  # POST /profiles.json
  def create
    @profile = Profile.new(params[:profile])
    @user = User.find(session[:user_id])
    @ibox = Ibox.find(session[:ibox_id])
    respond_to do |format|
      if @profile.save
        @user.profiles << @profile
        @ibox.profiles << @profile
        format.html { redirect_to @profile, notice: 'Profile was successfully created.' }
        format.json { render json: @profile, status: :created, location: @profile }
        format.js 
      else
        format.html { render action: "new" }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /profiles/1
  # PUT /profiles/1.json
  def update
    @profile = Profile.find(params[:id])
    @user = User.find(session[:user_id])
    respond_to do |format|
      if @profile.update_attributes(params[:profile])
        flash[:error] = ""
        flash[:notice] = "El usuario se ha actualizado correctamente."
        format.js   
      else
        flash[:error] = "Ha ocurrido un error al actualizar el usuario. Revise los campos."
        flash[:notice] = ""
        #format.js {render :partial => "profile", :collection => @user.profiles}  
        format.js
      end
    end
  end
  

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy
    @profile = Profile.find(params[:id])
    @user = User.find(session[:user_id])
    @profile.destroy

    respond_to do |format|
      format.js 

    end
  end
  
  
end
