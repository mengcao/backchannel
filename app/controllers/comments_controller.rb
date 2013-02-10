class CommentsController < ApplicationController
  # GET /comments
  # GET /comments.json
  before_filter :get_parent,:owner?
  skip_before_filter :owner?,:only => [:index,:show,:new,:create]
  skip_before_filter :get_parent,:only => [:index,:show,:edit,:update,:destroy]

  def index
    @comments = Comment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.json
  def new
    @comment = @parent.comments.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = @parent.comments.new(params[:comment])
    @comment.user_id = session[:user_id]

    respond_to do |format|
      if @comment.save
        @comment.update_post
        format.html { redirect_to post_path(@comment.post), notice: 'Comment was successfully created.' }
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.html { render action: "new" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.json
  def update
    @comment = Comment.find(params[:id])
    @post = @comment.post
    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to post_path(@post), notice: 'Comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
    @post = @comment.post
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to post_path(@post) }
      format.json { head :no_content }
    end
  end

  protected
  def get_parent
    @parent = Post.find_by_id(params[:post_id]) if params[:post_id]
    @parent = Comment.find_by_id(params[:comment_id]) if params[:comment_id]
    redirect_to root_path unless defined?(@parent)
  end

  def owner?
    @comment = Comment.find(params[:id])
    if @comment.user_id != session[:user_id]
      redirect_to post_path(@comment.post), notice: 'You are not the owner of this comment.'
    end
  end
end
