class ThemeController < ApplicationController
  @@download_to_vote_ratio = 4  # for p opularity, it means 1 download is worth X upvotes or downvotes
  @@upvote_points = 3
  @@downvote_points = 1
  helper :all
  
  before_filter :make_banner 
  
  
  def make_banner
    #makes a banner with the regular greenish background, but random foreground colors for each letter. 
      @fonts = ["Monaco","DejaVu Sans Mono", "Monospace", "Sans Serif", "Serif", "Fantasy", "Courier"]
      @bgcol = "728a90"
      @rc= RMThemeGen::ThemeGenerator.new
      @ban = '<div id="container"><div id="banner"  >'+
          '<div id="bannertext">'+
            '<span style="color:#'+@rc.randcolor(:bg_rgb=>@bgcol, :min_cont =>0.30)+';font-family:'+@fonts.shuffle.first+';">r</span>'+
            '<span style="color:#'+@rc.randcolor(:bg_rgb=>@bgcol, :min_cont=>0.30)+';font-family:'+@fonts.shuffle.first+';">m</span>'+
            '<span style="color:#'+@rc.randcolor(:bg_rgb=>@bgcol, :min_cont=>0.3)+';font-family:'+@fonts.shuffle.first+';">t</span>'+
            '<span style="color:#'+@rc.randcolor(:bg_rgb=>@bgcol, :min_cont=>0.3)+';font-family:'+@fonts.shuffle.first+';">h</span>'+
            '<span style="color:#'+@rc.randcolor(:bg_rgb=>@bgcol, :min_cont=>0.3)+';font-family:'+@fonts.shuffle.first+';">e</span>'+
            '<span style="color:#'+@rc.randcolor(:bg_rgb=>@bgcol, :min_cont=>0.3)+';font-family:'+@fonts.shuffle.first+';">m</span>'+
            '<span style="color:#'+@rc.randcolor(:bg_rgb=>@bgcol, :min_cont=>0.3)+';font-family:'+@fonts.shuffle.first+';">e</span>'+
            '<span style="color:#'+@rc.randcolor(:bg_rgb=>@bgcol, :min_cont=>0.3)+';font-family:'+@fonts.shuffle.first+';">g</span>'+
            '<span style="color:#'+@rc.randcolor(:bg_rgb=>@bgcol, :min_cont=>0.3)+';font-family:'+@fonts.shuffle.first+';">e</span>'+
            '<span style="color:#'+@rc.randcolor(:bg_rgb=>@bgcol, :min_cont=>0.3)+';font-family:'+@fonts.shuffle.first+';">n</span>'+
            '<span style="color:#'+@rc.randcolor(:bg_rgb=>@bgcol, :min_cont=>0.3)+';font-family:'+@fonts.shuffle.first+';">.</span>'+
            '<span style="color:#'+@rc.randcolor(:bg_rgb=>@bgcol, :min_cont=>0.3)+';font-family:'+@fonts.shuffle.first+';">c</span>'+
            '<span style="color:#'+@rc.randcolor(:bg_rgb=>@bgcol, :min_cont=>0.3)+';font-family:'+@fonts.shuffle.first+';">o</span>'+
            '<span style="color:#'+@rc.randcolor(:bg_rgb=>@bgcol, :min_cont=>0.3)+';font-family:'+@fonts.shuffle.first+';">m</span>'+
          '</div>    </div></div>'

  end


  def populate_themes_for_display
    @dark_themes = RmtTheme.all(:conditions=>['bg_color_style = ?',0],:order => :rank).shuffle
    @light_themes = RmtTheme.all(:conditions=>['bg_color_style = ?',1],:order => :rank).shuffle
    @color_themes = RmtTheme.all(:conditions=>['bg_color_style = ?',2],:order => :rank).shuffle
  end
  
  def index
    flash[:notice] = ''
   # flash[:notice] = "do maintenance theme called"
    #get a theme and display
   # @theme1 = RmtTheme.all.shuffle!.first
    populate_themes_for_display
    get_news
  end

  def show_colortype_page
    @dark_themes = nil
    @light_themes= nil
    @color_themes= nil
    which_page = params[:page] || 1
    case (params[:type])
      when "dark"
      @dark_themes = RmtTheme.paginate :page => which_page, :conditions=>['bg_color_style = ?',0], :order => 'rank asc'
      when "color"
      @color_themes = RmtTheme.paginate :page => which_page, :conditions=>['bg_color_style = ?',2], :order => 'rank asc'
      when "light"
      @light_themes = RmtTheme.paginate :page => which_page, :conditions=>['bg_color_style = ?',1], :order => 'rank asc'
    end
    get_news
    render "theme/colortypepage"
  end
  
  def download
    theme = RmtTheme.find(params[:id])
    if theme.file_path
      send_file(theme.file_path)
      theme.times_downloaded += 1
      theme.pop_score += @@download_to_vote_ratio*@@upvote_points
      theme.save
      theme.newsfeeds << Newsfeed.create(:message =>"Theme "+theme.nice_name()+" was downloaded")
      theme.save
    end
    do_maintenance
    populate_themes_for_display
    get_news
    RmtTheme.rerank
  end


  def show
    @theme1=RmtTheme.find(params[:id])
    @new_comment=ThemeComment.new(:theme_id=>params[:id])
    @previous_comments = @theme1.theme_comments
  end
  
  def upvote
    key = ( session[:session_id]+params[:id] ).to_s

    flash[:notice] =''
    if !session[key] #!( @@already_voted.include? (session[:session_id]+params[:id]).to_s )
      session[key] = true
      @theme1 = RmtTheme.find(params[:id] )
      @theme1.upvotes= @theme1.upvotes + 1
      @theme1.pop_score += @@upvote_points
      @theme1.newsfeeds << Newsfeed.create(:message=>"Theme '"+@theme1.nice_name+"' received 1 upvote")
      @theme1.save
    #  @@already_voted << (session[:session_id]+params[:id]).to_s
    #  flash[:notice] = "upvoting took place"+ session[:session_id].to_s+params[:id].to_s
    end
    #flash[:notice] = params[:id].to_s+" was upvoted"
    do_maintenance
    RmtTheme.rerank
    populate_themes_for_display
    get_news
    redirect_to env["HTTP_REFERER"]
    #render "index"
  end

  def downvote
  key = ( session[:session_id]+params[:id] ).to_s

  flash[:notice] =''
  if !session[key] #!( @@already_voted.include? (session[:session_id]+params[:id]).to_s )
    @theme1 = RmtTheme.find(params[:id])
    @theme1.downvotes= @theme1.downvotes + 1
    @theme1.pop_score -= @@downvote_points
    @theme1.newsfeeds << Newsfeed.create(:message=>"Theme '"+@theme1.nice_name+"' received 1 downvote")
    @theme1.save
#    @@already_voted << (session[:session_id]+params[:id]).to_s
#    flash[:notice] = "downvoting took place"+ session[:session_id].to_s+params[:id].to_s
   end
   # flash[:notice]= params[:id].to_s+" was downvoted"

  do_maintenance
  RmtTheme.rerank
  populate_themes_for_display
  get_news
  redirect_to env["HTTP_REFERER"]
#   render "index"
  end

  def get_news
    @news = Newsfeed.all :order=>"`created_at` desc", :limit=>10
  end

  def do_maintenance
    RmtTheme.do_maintenance
  end
end
