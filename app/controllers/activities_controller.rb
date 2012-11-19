#encoding: utf-8
class ActivitiesController < ApplicationController
  def index
    
    @user = User.find(session[:user_id])
    @iboxes = @user.iboxes
    @accessories = []
    @activities = []
    if session[:ibox_id]
      @ibox = Ibox.find(session[:ibox_id])
    else
      @ibox = @user.iboxes.first
    end
    @testConnection = false
    if !@ibox.nil? #si existe el ibox del usuario agarrado anteriormente =>  Toma todos los contenedores del ibox            
      @accessoriesPubs = []
      @ibox.ibox_accessories_containers.each do |container|
        @accessoriesPubs += container.accessories.where(:isPublic=> true)
      end
      @accessoriesOwneds = @user.accessories
      @accessories = @accessoriesPubs + @accessoriesOwneds  
      
      @acts = []
      @accessories.each do |acc|
        @acts += acc.activities
      end
      @activities = @acts.sort_by(&:created_at).reverse.first(15)
    else
      flash[:notice] = "Debe habilitar su Ibox en Administración."
    end
    respond_to do |format|
      format.html  
    end
  end

  def new
    @activities = Activity.new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @activities = Activity.find(params[:id])
    respond_to do |format|
      @ibox = Ibox.find(session[:ibox_id])
      format.js
    end
  end

  def create
    @activities = Activity.new(params[:accessory])
    respond_to do |format|
      if @activities.save
        format.html { redirect_to @activities, notice: 'Accessory was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end
  
  
  def search
    @ibox = Ibox.find(session[:ibox_id])
    @user = User.find(session[:user_id])
    
    @accessoriesPubs = []
    @ibox.ibox_accessories_containers.each do |container|
      @accessoriesPubs += container.accessories.where(:isPublic=> true)
    end
    @accessoriesOwneds = @user.accessories
    @accessories = @accessoriesPubs + @accessoriesOwneds
    
    if (params[:id] != "-1")
      @accessory = Accessory.find(params[:id])
      @acts = Activity.find(:all, :conditions => ["accessory_id = ?", @accessory.id], :limit => 50)
      @activities = @acts.sort_by(&:created_at).reverse.first(15)
      if @acts.length == 0
        flash[:notice] = "No se encontraron registros para este accesorio"
        flash[:error] = ""
      end
    else
      @accessoriesPubs = []
      @ibox.ibox_accessories_containers.each do |container|
        @accessoriesPubs += container.accessories.where(:isPublic=> true)
      end
      @accessoriesOwneds = @user.accessories
      @accessories = @accessoriesPubs + @accessoriesOwneds  
      
      @acts = []
      @accessories.each do |acc|
        @acts += acc.activities
      end
      @activities = @acts.sort_by(&:created_at).reverse.first(15)
    end
    respond_to do |format|
      format.js
    end
    
  end

end
