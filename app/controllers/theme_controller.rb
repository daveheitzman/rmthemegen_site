class ThemeController < ApplicationController


  def make_banner
    #makes a banner with the regular greenish background, but random foreground colors for each letter. 
      @bgcol = "728a90"
      @rc= RMThemeGen::ThemeGenerator.new
      '<div id="container"><div id="banner"  >'+
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
  
  def index
    @ban = make_banner
    RmtTheme.do_maintenance
    flash[:notice] = "do maintenance theme called"
    #get a theme and display
    @theme1 = RmtTheme.all.shuffle!.first
  end

  def download
    theme = RmtTheme.find(params[:id])
    
  end

  def click
  end

  def upvote
    @ban = make_banner
    @theme1 = RmtTheme.find(params[:id])
    flash[:notice] = params[:id].to_s+" was upvoted"
    render "index"
  end

  def downvote
    @ban = make_banner
    @theme1 = RmtTheme.find(params[:id])
    flash[:notice] = params[:id].to_s+" was downvoted"
    render "index"
  end

end
