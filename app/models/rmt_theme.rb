class RmtTheme < ActiveRecord::Base

  
  def self.do_maintenance
    #if fewer than 100 themes exist it ensures 100 exist
    while (find :all).size < 10
      create_theme
    end
    #this deletes the least popular 10% and refills.
  end

  def self.create_theme
    usedir = File.dirname(__FILE__)+"/../../public/themes/"
    if !File.exists?(usedir)
      Dir.mkdir(File.dirname(usedir))
    end

    theme_generator = RMThemeGen::ThemeGenerator.new
    nt = theme_generator.make_theme_file(usedir)
    new_theme_record = new(:theme_name => "", :to_css =>'', :times_downloaded=>0,:times_clicked=>0, :created_at=>Time.now,:last_downloaded=>Time.now,:last_clicked=>Time.now,:rank=>0, :upvotes=>0, :downvotes=>0,:bg_color_style=>0)
    new_theme_record.to_css = theme_generator.to_css
    new_theme_record.theme_name = theme_generator.schemename
    new_theme_record.save
    # create theme (ie save file)
    # populate CSS into database
    # put in other db stuff 
  end

end
