class ThemeController < ApplicationController
  @@download_to_vote_ratio = 10 # for popularity, it means 1 download is worth X upvotes or downvotes 
  before_filter :make_banner, :do_maintenance
  
  def make_banner
    #makes a banner with the regular greenish background, but random foreground colors for each letter. 
      @bgcol = "728a90"
      @rc= RMThemeGen::ThemeGenerator.new
      @ban = '<div id="container"><div id="banner"  >'+
          '<div id="bannertext">'+
            '<span style="color:#'+@rc.randcolor(:bg_rgb=>@bgcol, :min_cont=>0.30)+';">r</span>'+
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
            '<span style="color:#'+@rc.randcolor(:bg_rgb=>@bgcol, :min_cont=>0.3)+';">m</span>'+
          '</div>    </div></div>'

  end


  def populate_themes_for_display
    @dark_themes = RmtTheme.where('bg_color_style = ?',0)
    @light_themes = RmtTheme.where('bg_color_style = ?',1)
    @color_themes = RmtTheme.where('bg_color_style = ?',2)

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
      theme.save
    end
    populate_themes_for_display
  end



  def upvote
    @theme1 = RmtTheme.find(params[:id] )
    @theme1.upvotes= @theme1.upvotes + 1
    @theme1.save
    flash[:notice] = params[:id].to_s+" was upvoted"
    populate_themes_for_display
    render "index"
  end

  def downvote
    @theme1 = RmtTheme.find(params[:id])
    @theme1.downvotes= @theme1.downvotes + 1
    @theme1.save
    flash[:notice]= params[:id].to_s+" was downvoted"
    populate_themes_for_display
    render "index"
  end

  def do_maintenance
    RmtTheme.do_maintenance
  end
end
