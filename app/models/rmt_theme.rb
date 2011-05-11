class RmtTheme < ActiveRecord::Base
  @minimum_themes = 25 #per category
  @bg_styles = [0,1,2]
  
  def self.do_maintenance
    #if fewer than 100 themes exist it ensures 100 exist
    #get list of category #'s in case there's more than just 0,1,2
    @bg_styles.each do |style|
      while ( where("`bg_color_style`=?", style).size < @minimum_themes )
        create_theme(:bg_color_style => style)
      end
    end
    #this deletes the least popular 10% and refills.
  end

  def self.create_theme(newopts={})
    dir1 = (File.dirname(__FILE__)+"/../../public/themes/")
    opts = {:bg_color_style=>0, :outputdir => dir1.to_s}.merge(newopts)
    if !File.exists?(opts[:outputdir])
      Dir.mkdir(File.dirname(opts[:outputdir]))
    end

    theme_generator = RMThemeGen::ThemeGenerator.new
#    nt = theme_generator.make_theme_file(opts[:outputdir], opts[:bg_color_style])
    nt = theme_generator.make_theme_file(dir1,opts[:bg_color_style])

    
#    nt = theme_generator.make_theme_file(opts)


     #:usedir=>usedir,:bg_color_style=>opts[:bg_color_style])
    new_theme_record = new(:theme_name => "", :to_css =>'', :times_downloaded=>0,:times_clicked=>0, :created_at=>Time.now,:last_downloaded=>Time.now,:last_clicked=>Time.now,:rank=>0, :upvotes=>0, :downvotes=>0,:bg_color_style=>0,:file_path=>File.basename(nt) )
    new_theme_record.to_css = theme_generator.to_css
    new_theme_record.theme_name = theme_generator.schemename
    new_theme_record.bg_color_style = opts[:bg_color_style]
    new_theme_record.save
    # create theme (ie save file)
    # populate CSS into database
    # put in other db stuff 
  end

end
