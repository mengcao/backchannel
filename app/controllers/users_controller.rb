class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  before_filter :login?, :except => [:new, :login, :create]
  before_filter :admin?, :except => [:login, :logout]

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
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
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
    @user.admin = false

    respond_to do |format|
      if @user.save
        if (session[:user_admin] == true)
          format.html { redirect_to @user, notice: 'User was successfully created.' }
        else
          format.html { redirect_to :root, notice: 'User was successfully created.  Please login when ready.'}
        end
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
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

  def login
    @user = User.where(:name => params[:login][:name]).where(:password => params[:login][:password]).first
    if @user
      session[:user_id] = @user.id
      session[:user_admin] = @user.admin
      redirect_to :back
    else
      flash[:notice] = "Wrong user name or wrong password!"
      redirect_to :back
    end
  end

  def logout
    session[:user_id] = nil
    session[:user_admin] = nil
    redirect_to :root
  end
end
