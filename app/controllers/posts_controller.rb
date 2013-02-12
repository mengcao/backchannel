class PostsController < ApplicationController
  # GET /posts
  # GET /posts.json
  before_filter :owner?, :only => [:edit,:update,:destroy]
  before_filter :login?, :only => [:new,:create,:edit,:update,:destroy]

  def index
    @posts = Post.search(params[:search])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
    if !session[:show_voters]
      session[:show_voters] = Hash.new
      session[:show_voters][:comments] = []
      session[:show_voters][:post] = false
    else
      if !session[:show_voters][:post]
        session[:show_voters][:post] = false
      end
      if !session[:show_voters][:comments]
        session[:show_voters][:comments] = []
      end
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(params[:post])
    @post.user_id = session[:user_id]

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

  def owner?
    if User.find_by_id(session[:user_id]).admin == false
      @post = Post.find(params[:id])
      if @post.user_id != session[:user_id]
        redirect_to post_path(@post), notice: 'You are not the owner of this post.'
      end
    end
  end

  def toggle_voters
    if session[:show_voters][:post] == true
      session[:show_voters][:post] = false
    else
      session[:show_voters][:post] = true
    end
    redirect_to :back
  end
end
