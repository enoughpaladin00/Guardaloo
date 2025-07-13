class BookmarksController < ApplicationController
  before_action :authenticate_user!

  def toggle
    bookmark = current_user.bookmarks.find_by(tmdb_id: params[:tmdb_id])

    if bookmark
      bookmark.destroy
      @bookmarked = false
    else
      current_user.bookmarks.create(tmdb_id: params[:tmdb_id], title: params[:title], poster_path: params[:poster_path])
      @bookmarked = true
    end

    respond_to do |format|
      format.js
    end
  end
end
