class CommentsController < ApplicationController
  before_action :set_post
  after_action :verify_authorized

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    authorize @comment

    if @comment.save
      redirect_to @post, notice: 'Комментарий добавлен.'
    else
      redirect_to @post, alert: 'Ошибка при добавлении комментария.'
    end
  end

  def destroy
    @comment = @post.comments.find(params[:id])
    authorize @comment

    @comment.destroy
    redirect_to @post, notice: 'Комментарий удален.'
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end