class ThemeCommentsController < ApplicationController
  def edit
  end
  def create
    session[:theme_comment]=params[:theme_comment]
    @theme1 = RmtTheme.find(params[:theme_comment][:theme_id])
    @comment = ThemeComment.new(params[:theme_comment])
    if validate_recap(params,@comment.errors) && @comment.save
      @comment = ThemeComment.new
      session[:theme_comment]=nil
     msg = "A comment was left for #{@theme1.style_pretty} theme <a href='/theme/#{@theme1.id}'>'#{@theme1.nice_name}'</a>"
      msg[0]=msg[0,1].upcase
      @theme1.newsfeeds << Newsfeed.create(:message=>msg)
    end
    redirect_to(theme_path(params[:theme_comment][:theme_id]))
  end
end
