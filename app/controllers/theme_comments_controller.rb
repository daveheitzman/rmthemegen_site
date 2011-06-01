class ThemeCommentsController < ApplicationController

  def edit
  end

  def create
    session[:theme_comment]=params[:theme_comment]
    @comment = ThemeComment.new(params[:theme_comment])
    if validate_recap(params,@comment.errors) && @comment.save
      @comment = ThemeComment.new
      session[:theme_comment]=nil
    end
    redirect_to(theme_path(params[:theme_comment][:theme_id]))
  end
end
