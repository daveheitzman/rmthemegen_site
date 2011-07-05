class ThemeController < ApplicationController
  @@download_to_vote_ratio = 4  # for p opularity, it means 1 download is worth X upvotes or downvotes
  @@upvote_points = 3
  @@downvote_points = 1
  helper :all
  
  before_filter :make_banner 
  
  
  def make_banner
    #makes a banner with the regular greenish background, but random foreground colors for each letter. 
      @fonts = ["Monaco","DejaVu Sans Mono", "Monospace", "Sans Serif", "Serif", "Fantasy", "Courier"]
      @bgcol = "FFFFFF"
      @rc= RMThemeGen::ThemeGenerator.new
      @ban = '<span>'+
            '<span style="color:#'+@rc.randcolor(:bg_rgb=>@bgcol, :min_cont =>0.30)+';">r</span>'+
            '<span style="color:#'+@rc.randcolor(:bg_rgb=>@bgcol, :min_cont=>0.30)+';">m</span>'+
            '<span style="color:#'+@rc.randcolor(:bg_rgb=>@bgcol, :min_cont=>0.3)+';">t</span>'+
            '<span style="color:#'+@rc.randcolor(:bg_rgb=>@bgcol, :min_cont=>0.3)+';">h</span>'+
            '<span style="color:#'+@rc.randcolor(:bg_rgb=>@bgcol, :min_cont=>0.3)+';">e</span>'+
            '<span style="color:#'+@rc.randcolor(:bg_rgb=>@bgcol, :min_cont=>0.3)+';">m</span>'+
            '<span style="color:#'+@rc.randcolor(:bg_rgb=>@bgcol, :min_cont=>0.3)+';">e</span>'+
            '<span style="color:#'+@rc.randcolor(:bg_rgb=>@bgcol, :min_cont=>0.3)+';">g</span>'+
            '<span style="color:#'+@rc.randcolor(:bg_rgb=>@bgcol, :min_cont=>0.3)+';">e</span>'+
            '<span style="color:#'+@rc.randcolor(:bg_rgb=>@bgcol, :min_cont=>0.3)+';">n</span>'+
            '<span style="color:#'+@rc.randcolor(:bg_rgb=>@bgcol, :min_cont=>0.3)+';">.</span>'+
            '<span style="color:#'+@rc.randcolor(:bg_rgb=>@bgcol, :min_cont=>0.3)+';">c</span>'+
            '<span style="color:#'+@rc.randcolor(:bg_rgb=>@bgcol, :min_cont=>0.3)+';">o</span>'+
            '<span style="color:#'+@rc.randcolor(:bg_rgb=>@bgcol, :min_cont=>0.3)+';">m</span>' +'</span>'
  end


  def populate_themes_for_display
    @dark_themes = RmtTheme.all(:conditions=>['bg_color_style = ?',0],:order => :rank).shuffle
    @light_themes = RmtTheme.all(:conditions=>['bg_color_style = ?',1],:order => :rank).shuffle
    @color_themes = RmtTheme.all(:conditions=>['bg_color_style = ?',2],:order => :rank).shuffle

    @theme_categories =[{},{},{},{},{},{}]#,"Popular", "New", "Most Commented On", "Color", "Dark", "Light"
    @theme_categories[0]["Popular"] = RmtTheme.find(:all,:order=>:rank,:limit=>4)
    @theme_categories[1]["New"] = RmtTheme.find(:all, :order=>["created_at asc" ], :limit=>4)
    sql = "select *, (select count(*) from `theme_comments` where `rmt_themes`.id = `theme_comments`.`theme_id`) as `commentcount`  from `rmt_themes` order by commentcount desc limit 4"
    @theme_categories[2]["Most Commented On"] = RmtTheme.find_by_sql(sql)
    @theme_categories[3]["Color Backgrounds"] = RmtTheme.where(:bg_color_style=>2).limit(4)
    @theme_categories[4]["Light Backgrounds"] = RmtTheme.where(:bg_color_style=>1).limit(4)
    @theme_categories[5]["Dark Backgrounds"] = RmtTheme.where(:bg_color_style=>0).limit(4)

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
    @theme1 = RmtTheme.find(params[:id])
    if @theme1.file_path
      send_file(@theme1.file_path)
      @theme1.times_downloaded += 1
      @theme1.pop_score += @@download_to_vote_ratio*@@upvote_points
      @theme1.save
      msg = "#{@theme1.style_pretty} theme <a href='/theme/#{@theme1.id}'>'#{@theme1.nice_name}'</a> was downloaded"
      msg[0]=msg[0,1].upcase
      @theme1.newsfeeds << Newsfeed.create(:message=>msg)
      @theme1.save
    end
    do_maintenance
    populate_themes_for_display
    get_news
  end


  def show
    @theme1=RmtTheme.find(params[:id])
    if session[:theme_comment]
      @comment = ThemeComment.new(session[:theme_comment])
    else
      @comment = ThemeComment.new(:theme_id=>params[:id])
    end
    @previous_comments = @theme1.theme_comments.all( :order=>"created_at desc", :limit=>10)
  end
  
  def upvote
    key = ( session[:session_id]+params[:id] ).to_s
    flash[:notice] =''
    if !session[key] 
      session[key] = true
      @theme1 = RmtTheme.find(params[:id] )
      @theme1.upvotes= @theme1.upvotes + 1
      @theme1.pop_score += @@upvote_points
      msg = "#{@theme1.style_pretty} theme <a href='/theme/#{@theme1.id}'>'#{@theme1.nice_name}'</a> received 1 upvote"
      msg[0]=msg[0,1].upcase
      @theme1.newsfeeds << Newsfeed.create(:message=>msg)
      @theme1.save
    end
   # do_maintenance
   # RmtTheme.rerank
   populate_themes_for_display
   get_news
   redirect_to env["HTTP_REFERER"]
  end

  def downvote
    key = ( session[:session_id]+params[:id] ).to_s
    flash[:notice] =''
    if !session[key] #!( @@already_voted.include? (session[:session_id]+params[:id]).to_s )
      @theme1 = RmtTheme.find(params[:id])
      @theme1.downvotes= @theme1.downvotes + 1
      @theme1.pop_score -= @@downvote_points
      msg = "#{@theme1.style_pretty} theme <a href='/theme/#{@theme1.id}'>'#{@theme1.nice_name}'</a> received 1 downvote"
      msg[0]=msg[0,1].upcase
      @theme1.newsfeeds << Newsfeed.create(:message=>msg)
      @theme1.save
     end
    #do_maintenance
    #RmtTheme.rerank
    populate_themes_for_display
    get_news
    redirect_to env["HTTP_REFERER"]
  end

  def get_news
    @news = Newsfeed.all :order=>"`created_at` desc", :limit=>10
  end

  def do_maintenance
    RmtTheme.do_maintenance
  end
end
