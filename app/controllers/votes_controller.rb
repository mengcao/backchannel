class VotesController < ApplicationController
  # GET /votes
  # GET /votes.json
  before_filter :get_parent
  skip_before_filter :get_parent,:only => :destroy
  before_filter :admin?,:only => :index
  before_filter :owner?,:only => [:edit,:update,:destroy]

  def index
    @votes = Vote.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @votes }
    end
  end

  # GET /votes/1
  # GET /votes/1.json
  def show
    @vote = Vote.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @vote }
    end
  end

  # GET /votes/new
  # GET /votes/new.json
  def new
    @vote = @parent.votes.new(params[:vote])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @vote }
    end
  end

  # GET /votes/1/edit
  def edit
    @vote = Vote.find(params[:id])
  end

  # POST /votes
  # POST /votes.json
  def create
    @vote = @parent.votes.new
#   change this later for user login feature
    @vote.user_id = session[:user_id]

    respond_to do |format|
      if @vote.save
        @vote.update_post
        format.html { redirect_to :back, notice: 'Vote was successfully created.' }
        format.json { render json: @vote, status: :created, location: @vote }
      else
        format.html { render action: "new" }
        format.json { render json: @vote.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /votes/1
  # PUT /votes/1.json
  def update
    @vote = Vote.find(params[:id])

    respond_to do |format|
      if @vote.update_attributes(params[:vote])
        format.html { redirect_to @vote, notice: 'Vote was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @vote.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /votes/1
  # DELETE /votes/1.json
  def destroy
    @vote = Vote.find(params[:id])
    @vote.destroy

    respond_to do |format|
      format.html { redirect_to :back,:notice => 'Un-vote successfully.' }
      format.json { head :no_content }
    end
  end

  def owner?
    if User.find_by_id(session[:user_id]).admin == false
      @vote = Vote.find(params[:id])
      if @vote.user_id != session[:user_id]
        redirect_to :back, notice: 'You are not the owner of this vote.'
      end
    end
  end

  protected
  def get_parent
    @parent = Post.find_by_id(params[:post_id]) if params[:post_id]
    @parent = Comment.find_by_id(params[:comment_id]) if params[:comment_id]
    redirect_to root_path unless defined?(@parent)
  end

end
