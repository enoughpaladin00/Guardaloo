class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]  # Richiede login tranne per index/show
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]  # Autorizza solo il proprietario
  # before_action :set_post, only: [:show, :edit, :update, :destroy]

  # SENZA FILTRO
  # def index
  #   @posts = Post.includes(:user).order(created_at: :desc)  # Caricamento eager degli user
  #   if params[:filter] == "my_posts" && user_signed_in?
  #     @posts = Post.where(user: current_user)
  #   elsif params[:filter].present?
  #     @posts = Post.where(user_id: params[:filter])
  #   else
  #     @posts = Post.all
  #   end
  # end

  #FILTRO SOLO UTENTI
  # def index
  #   if params[:filter] == "my_posts" && user_signed_in?
  #     @posts = Post.where(user: current_user)
  #   elsif params[:filter].present?
  #     @posts = Post.where(user_id: params[:filter])
  #   else
  #     @posts = Post.all
  #   end

  #   @posts = @posts.includes(:user).order(created_at: :desc)
  # end

  #FILTRO COMPLETO
  def index
    @posts = Post.includes(:user, :comments)
    @top_movies = TmdbService.top_10_streaming_movies

    # Filtro "Solo i miei post"
    if params[:filter] == "my_posts" && user_signed_in?
      @posts = @posts.where(user: current_user)
    end

    # Filtro testuale su titolo, contenuto del post o commenti
    if params[:query].present?
      keyword = params[:query].downcase

      @posts = @posts.select do |post|
        post.title.downcase.include?(keyword) ||
        post.content.downcase.include?(keyword) ||
        post.comments.any? { |c| c.content.downcase.include?(keyword) }
      end
    end

    # Ordina sempre per data
    @posts = @posts.sort_by(&:created_at).reverse
  end

  def show
    @post = Post.find(params[:id])
    if user_signed_in?
      @comment = Comment.new(post: @post, user: current_user)  # Safer alternative
    end
  end


  def new
    @top_movies = TmdbService.top_10_streaming_movies
    if user_signed_in?
      @post = current_user.posts.build
    else
      redirect_to new_user_session_path, alert: "You need to sign in to create a post"
    end
  end

  def edit
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.movie_title.present?
      # Chiama il servizio per cercare il film tramite titolo
      movie = TmdbService.search_movie_by_title(@post.movie_title).first

      if movie
        @post.movie_id = movie["id"]
        @post.movie_poster_path = movie["poster_path"]
      end
    end

    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render :new
    end
  end


def update
  if @post.update(post_params)
    if @post.movie_title.present?
      movie = TmdbService.search_movie_by_title(@post.movie_title).first
      if movie
        @post.update_columns(movie_id: movie["id"], movie_poster_path: movie["poster_path"])
      end
    end
    redirect_to @post, notice: 'Post was successfully updated.'
  else
    render :edit
  end
end


  def destroy
    @post = Post.find(params[:id])
    if @post.user == current_user
      @post.destroy
      redirect_to posts_path, notice: "Post eliminato con successo"
    else
      redirect_to posts_path, alert: "Non puoi eliminare questo post"
    end
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :content, :movie_title, :movie_id, :movie_poster_path)
    end

end
