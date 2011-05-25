require 'rubygems'
require 'will_paginate'

class RmtTheme < ActiveRecord::Base
  @minimum_themes = 500 # total across all categories
  if ENV["RAILS_ENV"]=="development" then @minimum_themes= 25 end
  @bg_styles = [0,1,2]
  cattr_reader :per_page
  @@per_page = 12
  has_many :newsfeeds, :foreign_key => :theme_id
  has_many :theme_comments, :foreign_key => :theme_id

  def self.do_maintenance

    #this deletes the least popular XX% and refills.
      #not implemented yet
    lowest_ranked = find( :all, :order=>"`rank` desc, `created_at` asc ",  :limit=>1)[0]
    #delete file from disk
    if lowest_ranked
      File.delete(lowest_ranked.file_path) if File.exists?(lowest_ranked.file_path)
      lowest_ranked.newsfeeds << Newsfeed.create(:message =>"#{lowest_ranked.style_pretty} theme '"+ lowest_ranked.nice_name+"', ranked #{lowest_ranked.rank} has been deleted")
      lowest_ranked.delete
        #get list of category #'s in case there's more than just 0,1,2
    end
    
    while ( where("`bg_color_style`=?", 0).size < @minimum_themes )
      create_theme(:bg_color_style => (rand*3).to_i)
    end

  end

  def self.rerank
    #this reranks all themes based on popularity score
    @all = all :order=>"pop_score desc"
    ActiveRecord::Base.transaction do
      i=0
      @all.each_index do |ee|
        @all[i].rank = i+1
        @all[i].save
        i += 1
      end
    end
  end

  def self.create_theme(newopts={})
    dir1 = (File.dirname(__FILE__)+"/../../public/themes/")
    opts = {:bg_color_style=>(rand*3).to_i, :outputdir => dir1.to_s}.merge(newopts)
    if !File.exists?(opts[:outputdir])
#      Dir.mkdir(File.dirname(opts[:outputdir]))
      Dir.mkdir(opts[:outputdir])
    end
    theme_generator = RMThemeGen::ThemeGenerator.new
    nt = theme_generator.make_theme_file(dir1,opts[:bg_color_style],nil)
    new_theme_record = new(:theme_name => "", :to_css =>'', :times_downloaded=>0,:times_clicked=>0, :created_at=>Time.now,:last_downloaded=>Time.now,:last_clicked=>Time.now,:rank=>0, :upvotes=>0, :downvotes=>0,:bg_color_style=>0,:file_path=>File.expand_path(nt) )
    #File.delete(File.expand_path(nt)) if File.exists?(File.expand_path(nt))
    new_theme_record.to_css = theme_generator.to_css
    new_theme_record.theme_name = theme_generator.themename
    new_theme_record.bg_color_style = opts[:bg_color_style]
    new_theme_record.save
    new_theme_record.newsfeeds << Newsfeed.create(:message =>"New #{new_theme_record.style_pretty} theme: '"+new_theme_record.nice_name + "' created")
    new_theme_record.save
    # create theme (ie save file)
    # populate CSS into database
    # put in other db stuff 
  end

  def nice_name
    if !theme_name.nil? then
      glyphs = theme_name.split("_")
      glyphs[0][0] = glyphs[0][0,1].upcase
      glyphs[1][0] = glyphs[1][0,1].upcase
      glyphs[0] +" "+ glyphs[1]
    end
  end

  def style_pretty
    case bg_color_style
      when 0: "dark"
      when 2: "color"
      when 1: "light"
    end  end

end
