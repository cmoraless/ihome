class IboxesController < ApplicationController
  # GET /iboxes
  # GET /iboxes.json
  layout "admin"
  def index
    @iboxes = Ibox.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @iboxes }
    end
  end

  # GET /iboxes/1
  # GET /iboxes/1.json
  def show
    @ibox = Ibox.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ibox }
    end
  end

  # GET /iboxes/new
  # GET /iboxes/new.json
  def new
    @ibox = Ibox.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ibox }
    end
  end

  # GET /iboxes/1/edit
  def edit
    @ibox = Ibox.find(params[:id])
  end

  # POST /iboxes
  # POST /iboxes.json
  def create
    @ibox = Ibox.new(params[:ibox])

    respond_to do |format|
      if @ibox.save
        format.html { redirect_to @ibox, notice: 'Ibox was successfully created.' }
        format.json { render json: @ibox, status: :created, location: @ibox }
      else
        format.html { render action: "new" }
        format.json { render json: @ibox.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /iboxes/1
  # PUT /iboxes/1.json
  def update
    @ibox = Ibox.find(params[:id])

    respond_to do |format|
      if @ibox.update_attributes(params[:ibox])
        format.html { redirect_to @ibox, notice: 'Ibox was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @ibox.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /iboxes/1
  # DELETE /iboxes/1.json
  def destroy
    @ibox = Ibox.find(params[:id])
    @ibox.destroy

    respond_to do |format|
      format.html { redirect_to iboxes_url }
      format.json { head :no_content }
    end
  end
end
