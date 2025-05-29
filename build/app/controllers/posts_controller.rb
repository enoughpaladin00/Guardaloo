class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]  # Richiede login tranne per index/show
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]  # Autorizza solo il proprietario
  # before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.includes(:user).order(created_at: :desc)  # Caricamento eager degli user
  end


  def show
    @post = Post.find(params[:id])
    if user_signed_in?
      @comment = Comment.new(post: @post, user: current_user)  # Safer alternative
    end
  end


  def new
    if user_signed_in?
      @post = current_user.posts.build
    else
      redirect_to new_user_session_path, alert: "You need to sign in to create a post"
    end
  end

  def edit
  end

  def create
    @post = current_user.posts.build(post_params)  # Crea post associato all'utente corrente

    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render :new
    end
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_url, notice: 'Post was successfully destroyed.'
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :content)
    end
end
