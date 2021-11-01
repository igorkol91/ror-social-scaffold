class PostsController < ApplicationController
  include ActionController::MimeResponds

  before_action :authenticate_user!

  def index
    @post = Post.new
    respond_to do |format|
      format.html { timeline_posts }
      format.xml  { render :xml => timeline_posts }
      format.json { render :json => timeline_posts }
    end
  end

  def show
    @posts = Post.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
      format.json { render :json => @posts }
    end
  end

  def create
    @post = current_user.posts.new(post_params)

    if @post.save
      redirect_to posts_path, notice: 'Post was successfully created.'
    else
      timeline_posts
      render :index, alert: 'Post was not created.'
    end
  end

  private

  def timeline_posts
    friend_ids = []
    current_user.friendships.each { |f| friend_ids << f.friend_id if f.status == true }
    @timeline_posts = []
    friend_ids << current_user.id
    index = 0
    while index < friend_ids.length
      @timeline_posts += Post.where('user_id = ?', friend_ids[index])
      index += 1
    end
    @timeline_posts.reverse!
  end

  def post_params
    params.require(:post).permit(:content)
  end
end
