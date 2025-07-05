class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to post_path(@post, anchor: "comment-#{@comment.id}")
    else
      redirect_to post_path(@post), alert: "Errore durante la creazione del commento."
    end

  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to @comment.post, notice: 'Comment was successfully destroyed.'
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.user == current_user
      if @comment.update(comment_params)
        redirect_to post_path(@comment.post, anchor: "comment-#{@comment.id}"), notice: "Commento aggiornato."
      else
        redirect_to post_path(@comment.post), alert: "Errore durante l'aggiornamento."
      end
    else
      redirect_to post_path(@comment.post), alert: "Non sei autorizzato."
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:content)
    end
end
