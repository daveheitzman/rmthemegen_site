class ThemeController < ApplicationController
  @@download_to_vote_ratio = 4  #for p opularity, it means 1 download is worth X upvotes or downvotes
  @@view_points = 1 #popularity increase for a theme getting viewed (same as a click )
  @@upvote_points = 3
  @@comment_points = 2 #pop_score increases by this much when someeone comments 
  @@downvote_points = 1
  helper :all

  def populate_themes_for_display
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
    populate_themes_for_display
    get_news

   #this is costly:
   RmtTheme.do_maintenance
   RmtTheme.rerank
  end

  def show_colortype_page
   @per_row = 5
   @rows = 5
   @the_themes_title = params[:type].gsub("+"," ")
     
   case (@the_themes_title)
       when "Popular":
         @the_themes =  RmtTheme.paginate(:order=>:rank,:conditions =>["rank > ?",0],:order=>"rank", :page=>params[:page],:per_page=>@rows * @per_row, :limit=>(RmtTheme.count/4).to_i)
         @page_label= @the_themes_title+" ( #{(RmtTheme.count/4).to_i.to_s} )"
      when "New": RmtTheme.paginate(:order=>["created_at desc" ],:per_page=>@rows * @per_row, :page=>params[:page],:limit=>(RmtTheme.count/4).to_i)
         @page_label= @the_themes_title+" ( #{(RmtTheme.count/4).to_i.to_s} )"
      when "Most Commented On": sql = "select *, (select count(*) from `theme_comments` where `rmt_themes`.id = `theme_comments`.`theme_id`) as `commentcount`  from `rmt_themes` where (select count(*) from `theme_comments` where `rmt_themes`.id = `theme_comments`.`theme_id`) > 0 order by `commentcount` desc"

         cc= RmtTheme.find_by_sql(sql).size.to_s
         @the_themes = RmtTheme.paginate_by_sql(sql,:page=>params[:page],:per_page=>@rows * @per_row)
         
         #cc = @the_themes.sum do |t| t.theme_comments.size end
         #@the_themes=RmtTheme.paginate(@the_themes,:page=>params[:page],:per_page=>@rows * @per_row)
         @page_label= @the_themes_title+" ( #{cc} )"
      when "Color Background":
         @the_themes = RmtTheme.paginate(:conditions=>["bg_color_style=?",2],:order=>"rank", :page=>params[:page],:per_page=>@rows * @per_row)
         @page_label= @the_themes_title+" ( #{RmtTheme.where("bg_color_style=2").size} )"
      when "Light Background":
         @the_themes = RmtTheme.paginate(:conditions=>["bg_color_style=?",1],:order=>"rank", :page=>params[:page],:per_page=>@rows * @per_row)
         @page_label= @the_themes_title+" ( #{RmtTheme.where("bg_color_style=1").size} )"
      when "Dark Background":
         @the_themes = RmtTheme.paginate(:conditions=>["bg_color_style=?",0],:order=>"rank", :page=>params[:page],:per_page=>@rows * @per_row)
         @page_label= @the_themes_title+" ( #{RmtTheme.where("bg_color_style=0").size} )"
      else @the_themes = RmtTheme.paginate( :page=>params[:page],:per_page=>@rows * @per_row).shuffle;
         @page_label= @the_themes_title+" ( #{RmtTheme.count} )"
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
    RmtTheme.do_maintenance
    populate_themes_for_display
    
  end


  def show
    @theme1=RmtTheme.find(params[:id])
    @theme1.pop_score += @@view_points
    @theme1.times_clicked += 1
    @theme1.save
    if session[:theme_comment]
      @comment = ThemeComment.new(session[:theme_comment])
    else
      @comment = ThemeComment.new(:theme_id=>params[:id])
    end
    @previous_comments = @theme1.theme_comments.all( :order=>"created_at desc", :limit=>10)
   #other themes you may like: 
    case @theme1.bg_color_style
       when 0: @others = RmtTheme.all( :conditions=>"bg_color_style=0").shuffle[0..2]
               @others << RmtTheme.all( :conditions=>"bg_color_style=1").shuffle[0]
               @others << RmtTheme.all( :conditions=>"bg_color_style=2").shuffle[0]
         @others.shuffle!
       when 1:  @others = RmtTheme.all( :conditions=>"bg_color_style=1").shuffle[0..2]
               @others << RmtTheme.all( :conditions=>"bg_color_style=0").shuffle[0]
               @others << RmtTheme.all( :conditions=>"bg_color_style=2").shuffle[0]
         @others.shuffle!
       when 2:  @others = RmtTheme.all( :conditions=>"bg_color_style=0").shuffle[0..2]
               @others << RmtTheme.all( :conditions=>"bg_color_style=1").shuffle[0]
               @others << RmtTheme.all( :conditions=>"bg_color_style=2").shuffle[0]
         @others.shuffle!
       else   @others = RmtTheme.all.shuffle[0..4]
    end
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
    @news = Newsfeed.all :order=>"`created_at` desc", :limit=>15
  end

end
