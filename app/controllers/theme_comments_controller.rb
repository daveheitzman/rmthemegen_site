class ThemeCommentsController < ApplicationController

  def edit
  end

  def create
    ThemeComment.create(params[:theme_comment])
    redirect_to(theme_path(params[:theme_comment][:theme_id]))
  end
end
