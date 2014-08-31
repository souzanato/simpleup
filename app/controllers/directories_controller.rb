class DirectoriesController < ApplicationController
  load_and_authorize_resource
  
  # GET /directories
  # GET /directories.json
  def index
    @directories = (Directory.where('private is null or private is false') + Directory.joins(:owners).where('directory_owners.user_id = ?', current_user.id) + Directory.joins(:allowed_users).where('directory_allowed_users.user_id = ?', current_user.id)).uniq

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @directories }
    end
  end

  # GET /directories/1
  # GET /directories/1.json
  def show
    @directory = Directory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @directory }
    end
  end

  # GET /directories/new
  # GET /directories/new.json
  def new
    @directory = Directory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @directory }
    end
  end

  # GET /directories/1/edit
  def edit
    @directory = Directory.find(params[:id])
  end

  # POST /directories
  # POST /directories.json
  def create
    @directory = Directory.new(params[:directory])
    @directory.owners << [current_user]

    respond_to do |format|
      if @directory.save
        format.html { redirect_to @directory, notice: 'Directory was successfully created.' }
        format.json { render json: @directory, status: :created, location: @directory }
      else
        format.html { render action: "new" }
        format.json { render json: @directory.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /directories/1
  # PUT /directories/1.json
  def update
    @directory = Directory.find(params[:id])

    respond_to do |format|
      if @directory.update_attributes(params[:directory])
        format.html { redirect_to @directory, notice: 'Directory was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @directory.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /directories/1
  # DELETE /directories/1.json
  def destroy
    @directory = Directory.find(params[:id])
    begin
      @directory.destroy
    rescue ActiveRecord::DeleteRestrictionError
      flash[:error] = 'Dependencia restrita'
      respond_to do |format|
        format.html { redirect_to @directory }
        format.json { head :no_content }
      end

    else
      respond_to do |format|
        format.html { redirect_to directories_url }
        format.json { head :no_content }
      end
    end
  end
end
