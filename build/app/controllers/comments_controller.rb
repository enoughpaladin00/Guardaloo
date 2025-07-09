class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: [ :destroy, :update ]
  before_action :authorize_comment_action!, only: [ :destroy, :update ]

  def create
    @user = current_user
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
    @user = current_user
    @comment = Comment.find(params[:id])
    if current_user == @comment.user || current_user == @comment.post.user || current_user.admin? || current_user.moderator?
      @comment.destroy
      redirect_to @comment.post, notice: "Commento eliminato con successo."
    else
      redirect_to @comment.post, alert: "Non sei autorizzato a eliminare questo commento."
    end
  end

  def update
    @user = current_user
    @comment = Comment.find(params[:id])
    if current_user == @comment.user || current_user == @comment.post.user || current_user.admin? || current_user.moderator?
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

  def set_comment
    @user = current_user
    @comment = Comment.find(params[:id])
  end

  def authorize_comment_action!
    # Solo admin o moderator possono modificare/eliminare qualsiasi commento
    # L’utente normale solo i propri commenti
    unless current_user.admin? || current_user.moderator? || @comment.user == current_user
      redirect_to post_path(@comment.post), alert: "Non sei autorizzato a modificare o eliminare questo commento."
    end
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
