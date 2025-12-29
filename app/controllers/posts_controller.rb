class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized, except: [:index, :show]

  def index
    @posts = Post.includes(:user, :comments).recent.page(params[:page]).per(10)
  end

  def show
    @comment = Comment.new
  end

  def new
    @post = Post.new
    authorize @post
  end

  def create
    @post = current_user.posts.build(post_params)
    authorize @post

    if @post.save
      redirect_to @post, notice: 'Пост успешно создан.'
    else
      render :new
    end
  end

  def edit
    authorize @post
  end

  def update
    authorize @post

    if @post.update(post_params)
      redirect_to @post, notice: 'Пост успешно обновлен.'
    else
      render :edit
    end
  end

  def destroy
    authorize @post
    @post.destroy
    redirect_to posts_path, notice: 'Пост успешно удален.'
  end

  def like
    @post = Post.find(params[:id])
    vote(1)
  end

  def dislike
    @post = Post.find(params[:id])
    vote(-1)
  end

  def unvote
    @post = Post.find(params[:id])
    @post.likes.find_by(user: current_user)&.destroy
    redirect_back fallback_location: @post
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :image)
  end

  def vote(value)
    like = @post.likes.find_or_initialize_by(user: current_user)
    like.value = value

    if like.save
      redirect_back fallback_location: @post
    else
      redirect_back fallback_location: @post, alert: 'Ошибка при голосовании'
    end
  end
end