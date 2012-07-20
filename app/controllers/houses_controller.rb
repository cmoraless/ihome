class HousesController < ApplicationController
  layout "homeadmin"
  def index
    @houses = House.all
    respond_to do |format|
      format.html  # index.html.erb
      format.json  { render :json => @houses }
    end
  end
  
  def new
    @house = House.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @house}
    end
  end

  def create
    @house = House.new(params[:house])
    respond_to do |format|
      if @house.save
        format.html  { redirect_to(@house, :notice => 'Post was successfully created.') }
        format.json  { render :json => @house, :status => :created, :location => @house }
      else
        format.html  { render :action => "new" }
        format.json  { render :json => @house.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    @house = House.find(params[:id]) 
    respond_to do |format|
      format.html  # show.html.erb
      format.json  { render :json => @house }
    end
  end

  def edit
    @house = House.find(params[:id])
  end

  def update
    @house = House.find(params[:id])
    respond_to do |format|
      if @house.update_attributes(params[:house])
        format.html  { redirect_to(@house, :notice => 'Post was successfully updated.') }
        format.json  { head :no_content }
      else
        format.html  { render :action => "edit" }
        format.json  { render :json => @house.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @house = House.find(params[:id])
    @house.destroy
 
    respond_to do |format|
      format.html { redirect_to houses_url }
      format.json { head :no_content }
    end
  end

end
