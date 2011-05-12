class ThemeController < ApplicationController
  @@download_to_vote_ratio = 4  # for popularity, it means 1 download is worth X upvotes or downvotes
  @@upvote_points = 3
  @@downvote_points = 1
  before_filter :make_banner, :do_maintenance
  
  def make_banner
    #makes a banner with the regular greenish background, but random foreground colors for each letter. 
      @fonts = ["Monaco","DejaVu Sans Mono", "Monospace", "Sans Serif", "Serif", "Fantasy", "Courier"]
      @bgcol = "728a90"
      @rc= RMThemeGen::ThemeGenerator.new
      @ban = '<div id="container"><div id="banner"  >'+
          '<div id="bannertext">'+
            '<span style="color:#'+@rc.randcolor(:bg_rgb=>@bgcol, :min_cont=>0.30)+';font-family:'+@fonts.shuffle.first+';">r</span>'+
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
#    @dark_themes = RmtTheme.where(['bg_color_style = ?',0], :conditions=>"order by rank")
    @dark_themes = RmtTheme.all(:conditions=>['bg_color_style = ?',0],:order => :rank)
#    @dark_themes = RmtTheme.where(['bg_color_style = ?',0], :conditions=>"order by rank")
    @light_themes = RmtTheme.where(['bg_color_style = ?',1])
    @light_themes = RmtTheme.all(:conditions=>['bg_color_style = ?',1],:order => :rank)
    @color_themes = RmtTheme.all(:conditions=>['bg_color_style = ?',2],:order => :rank)
  end
  def index

    flash[:notice] = ''
   # flash[:notice] = "do maintenance theme called"
    #get a theme and display
   # @theme1 = RmtTheme.all.shuffle!.first
    populate_themes_for_display
  end

  def show_colortype_page
    @dark_themes = nil
    @light_themes= nil
    @color_themes= nil
    case (params[:type])
      when "dark"
      @dark_themes = RmtTheme.where('bg_color_style = ?',0)
      when "color"
      @color_themes = RmtTheme.where('bg_color_style = ?',2)
      when "light"
      @light_themes = RmtTheme.where('bg_color_style = ?',1)
    end
    render "theme/colortypepage"
  end
  
  def download
    theme = RmtTheme.find(params[:id])
    if theme.file_path
      send_file(theme.file_path, :type =>"text/xml")
      theme.times_downloaded += 1
      theme.pop_score += @@download_to_vote_ratio*@@upvote_points
      theme.save
    end
    populate_themes_for_display
  end



  def upvote
    @theme1 = RmtTheme.find(params[:id] )
    @theme1.upvotes= @theme1.upvotes + 1
    @theme1.pop_score += @@upvote_points
    @theme1.save
    flash[:notice] = params[:id].to_s+" was upvoted"

    populate_themes_for_display
    render "index"
  end

  def downvote
    @theme1 = RmtTheme.find(params[:id])
    @theme1.downvotes= @theme1.downvotes + 1
    @theme1.pop_score -= @@downvote_points
    @theme1.save
    flash[:notice]= params[:id].to_s+" was downvoted"
    populate_themes_for_display
    render "index"
  end

  def do_maintenance
    RmtTheme.do_maintenance
  end
end