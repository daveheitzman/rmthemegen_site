class WelcomeController < ApplicationController


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

#    @c=Color::RGB.new(100,200,100)
 #   @rc= RMThemeGen::ThemeGenerator.new
  end

end
