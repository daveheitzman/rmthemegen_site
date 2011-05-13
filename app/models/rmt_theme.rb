require 'rubygems'
require 'will_paginate'

class RmtTheme < ActiveRecord::Base
  @minimum_themes = 25 #per category
  @bg_styles = [0,1,2]
  cattr_reader :per_page
  @@per_page = 12


  def self.do_maintenance
    #if fewer than 100 themes exist it ensures 100 exist
    #get list of category #'s in case there's more than just 0,1,2

    while ( where("`bg_color_style`=?", 0).size < @minimum_themes )
      @bg_styles.each do |style|
      create_theme(:bg_color_style => style)
      end
    end
    #this deletes the least popular 10% and refills.
      #not implemented yet
    
    #this reranks all of them based on popularity score
    @all = all :order=>"pop_score desc"
    ActiveRecord::Base.transaction do
      @all.each_index do |i|
        @all[i].rank = i+1
        @all[i].save
      end
    end
  end

  def self.create_theme(newopts={})
    dir1 = (File.dirname(__FILE__)+"/../../public/themes/")
    opts = {:bg_color_style=>0, :outputdir => dir1.to_s}.merge(newopts)
    if !File.exists?(opts[:outputdir])
      Dir.mkdir(File.dirname(opts[:outputdir]))
    end
    theme_generator = RMThemeGen::ThemeGenerator.new
    nt = theme_generator.make_theme_file(dir1,opts[:bg_color_style])
    new_theme_record = new(:theme_name => "", :to_css =>'', :times_downloaded=>0,:times_clicked=>0, :created_at=>Time.now,:last_downloaded=>Time.now,:last_clicked=>Time.now,:rank=>0, :upvotes=>0, :downvotes=>0,:bg_color_style=>0,:file_path=>File.expand_path(nt) )
    new_theme_record.to_css = theme_generator.to_css
    new_theme_record.theme_name = theme_generator.schemename
    new_theme_record.bg_color_style = opts[:bg_color_style]
    new_theme_record.save
    # create theme (ie save file)
    # populate CSS into database
    # put in other db stuff 
  end



end
