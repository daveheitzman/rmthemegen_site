require 'rubygems'
require 'will_paginate'

class RmtTheme < ActiveRecord::Base
  
  @minimum_themes = 150 #for each category
  if ENV["RAILS_ENV"]=="development" then @minimum_themes= 25 end
  @bg_styles = [0,1,2]
  cattr_reader :per_page
  @@per_page = 12
  has_many :newsfeeds, :foreign_key => :theme_id
  has_many :theme_comments, :foreign_key => :theme_id



  def self.do_maintenance

    #this deletes the least popular XX% and refills.
      
    lowest_ranked = find( :all, :order=>"`rank` desc, `created_at` asc ",  :limit=>1)[0]
    #delete file from disk
    if lowest_ranked
      File.delete(lowest_ranked.file_path) if File.exists?(lowest_ranked.file_path)
      msg = "#{lowest_ranked.style_pretty} theme '#{lowest_ranked.nice_name}' deleted"
      msg[0]=msg[0,1].upcase
      lowest_ranked.newsfeeds << Newsfeed.create(:message =>msg)
      lowest_ranked.delete
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
      Dir.mkdir(opts[:outputdir])
    end
    theme_generator = RMThemeGen::ThemeGenerator.new
    nt = theme_generator.make_theme_file(dir1,opts[:bg_color_style],nil)
    new_theme_record = new(:theme_name => "", :to_css =>'', :times_downloaded=>0,:times_clicked=>0, :created_at=>Time.now,:last_downloaded=>Time.now,:last_clicked=>Time.now,:rank=>0, :upvotes=>0, :downvotes=>0,:bg_color_style=>0,:file_path=>File.expand_path(nt) )
    new_theme_record.to_css = theme_generator.to_css
    new_theme_record.theme_name = theme_generator.themename
    new_theme_record.bg_color_style = opts[:bg_color_style]
    new_theme_record.save

    msg = "#{new_theme_record.style_pretty} theme <a href='/theme/#{new_theme_record.id}'>'#{new_theme_record.nice_name}'</a> created"
    msg[0]=msg[0,1].upcase
    new_theme_record.newsfeeds << Newsfeed.create(:message=>msg)

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
    end
  end

  def to_html_small
  
  @out = to_css+'<a href="'+"/theme/#{id}"+'"><div class="editor_box"><div class="editor_title">"'+(nice_name)+'"</div><div class="editor small"><div id="'+theme_name+'">'
      @out +='<div class="line"><span class = "RUBY_SPECIFIC_CALL">require</span><span class="RUBY_STRING"> "test"</span></div><div class="line"><span class="RUBY_CONSTANT">CONSTANT</span><span class="RUBY_OPERATION_SIGN"> =</span><span class="RUBY_NUMBER">777</span><span class="RUBY_COMMENT">&nbsp;#comment</span></div>
   <div class="line"></div>

<div class="line"><span class="RUBY_KEYWORD">module</span><span class="RUBY_CONSTANT"> SampleModule</span></div>
<div class="line"><span class = "RUBY_SPECIFIC_CALL">  include</span> <span class = "RUBY_CONSTANT">Testcase</span></div>
   <div class="line"></div>
<div class="line"><span class="RUBY_PARAMDEF_CALL">  render </span><span class="RUBY_SYMBOL">:action</span> <span class="RUBY_OPERATION_SIGN">=></span><span class = "RUBY_STRING">\'foo\'</span></div>
<div class="line"> <span class="RUBY_KEYWORD"> def</span> <span class="RUBY_IDENTIFIER">foo</span><span class="RUBY_BRACKETS">(</span><span class="RUBY_PARAMETER_ID">parameter</span><span class="RUBY_BRACKETS">)</span></div>
<div class="line">    <span class="RUBY_LOCAL_VAR_ID">@parameter </span><span class="RUBY_OPERATION_SIGN">=</span><span class="RUBY_IDENTIFIER"> parameter</span></div>
<div class="line"> <span class="RUBY_KEYWORD"> end</span></div>
   <div class="line"></div>

<div class="line"> <span class="RUBY_LOCAL_VAR_ID"> local_var <span class="RUBY_OPERATION_SIGN">= <span class="RUBY_IDENTIFIER">eval</span> <span class="RUBY_HEREDOC_ID"><<-"FOO"</span><span class="RUBY_SEMICOLON">;</span><span class="RUBY_LINE_CONTINUATION">\</span></div>
<div class="line"><span class="RUBY_LINE_HIGHLIGHT"><span class="RUBY_IDENTIFIER">printIndex</span> <span class = "RUBY_STRING">"Hello world!"</span></span></div>
<div class="line"> <span class="RUBY_HEREDOC"> And now this is heredoc!</span></div>
<div class="line"> <span class="RUBY_HEREDOC"> printIndex "Hello world again!"</span></div>
<div class="line">  <span class="RUBY_HEREDOC_ID">FOO</span></div>

<div class="line"> <span class="RUBY_IDENTIFIER">foo</span><span class="RUBY_BRACKETS">(</span><span class="RUBY_STRING">"</span><span class="RUBY_EXPR_IN_STRING">#{</span><span class="RUBY_GVAR">$GLOBAL_TIME</span> <span class="RUBY_OPERATION_SIGN"> >></span> <span class="RUBY_REGEXP">$`</span><span class="RUBY_EXPR_IN_STRING">}</span> <span class="RUBY_STRING">is</span> <span class="RUBY_INVALID_ESCAPE_SEQUENCE">\</span></div><div class="line"><span class="RUBY_STRING">Z sample</span> <span class="RUBY_ESCAPE_SEQUENCE">\"</span><span class="RUBY_STRING">string</span><span class="RUBY_ESCAPE_SEQUENCE">\"</span><span class="RUBY_STRING">"</span><span class="RUBY_OPERATION_SIGN">*</span> <span class="RUBY_NUMBER">777</span><span class="RUBY_BRACKETS">)</span><span class="RUBY_SEMICOLON">;</span></div>

<div class="line"><span class="RUBY_KEYWORD">if</span> <span class="RUBY_BRACKETS">(</span><span class="RUBY_REGEXP">$1</span><span >=~</span> <span>/sample reg ex/)</span><span class="RUBY_KEYWORD"> then</span></div>

<div class="line"> <span class="RUBY_KEYWORD"> begin</span></div>
<div class="line">puts %W(s w), CONS, :foo;</div>
<div class="line">do_something :action => "action"</div>
<div class="line"><span class="RUBY_KEYWORD"> end</span></div>
<div class="line">1.upto<span class="RUBY_BRACKET">(</span><span class="RUBY_CVAR">@@n</span><span class="RUBY_BRACKET">)</span> do |index| printIndex "Hello" + index end</div>
<div class="line">\\\\\\\\\\</div>
<div class="line">end</div>
<div class="line">end</div>


</div></div></div>
</a>'
    return @out
  end



   def to_html_medium
      @out = to_css+'<div class="editor_box editor_box_medium"><div class="editor_title">"'+(nice_name)+'"</div><div class="download_button" style="float:right;"><a href=""> Download</a></div><div class="editor editor_medium"><div id="'+theme_name+'" >'

          @out +='<div class="line"><span class = "RUBY_SPECIFIC_CALL">require </span><span class="RUBY_KEYWORD">File.dirname</span><span class="RUBY_BRACKETS">(</span><span class="RUBY_CONSTANT">__FILE__</span><span class="RUBY_BRACKETS">)</span><span class="RUBY_OPERATION_SIGN">+</span><span class = "RUBY_STRING">"/token_list"</span></div>
<div class="line">&nbsp; </div>
<div class="line"><span class="RUBY_CONSTANT">CONSTANT</span><span class="RUBY_OPERATION_SIGN"> =</span><span class="RUBY_NUMBER"> 777</span><span class="RUBY_COMMENT">&nbsp;&nbsp; #TODO: change to 778</span></div>
       <div class="line"></div>

    <div class="line"><span class="RUBY_KEYWORD">module</span><span class="RUBY_CONSTANT"> SampleModule</span><span class="RUBY_OPERATION_SIGN"> < </span><span class="RUBY_CONSTANT"> ParentModule</span></div>
    <div class="line"><span class = "RUBY_SPECIFIC_CALL">  include</span> <span class = "RUBY_CONSTANT">Testcase</span></div>
       <div class="line"></div>
    <div class="line"><span class="RUBY_PARAMDEF_CALL">  render </span><span class="RUBY_SYMBOL">:action</span> <span class="RUBY_OPERATION_SIGN">=></span><span class = "RUBY_STRING">\'foo\'</span></div>
    <div class="line"> <span class="RUBY_KEYWORD"> def</span> <span class="RUBY_IDENTIFIER">foo</span><span class="RUBY_BRACKETS">(</span><span class="RUBY_PARAMETER_ID">parameter</span><span class="RUBY_BRACKETS">)</span></div>
    <div class="line">    <span class="RUBY_LOCAL_VAR_ID">&nbsp;&nbsp;&nbsp;@object_var </span><span class="RUBY_OPERATION_SIGN">=</span><span class="RUBY_IVAR"> parameter</span></div>
    <div class="line"> <span class="RUBY_KEYWORD"> end</span></div>
       <div class="line">&nbsp;</div>

    <div class="line"> <span class="RUBY_LOCAL_VAR_ID"> local_var <span class="RUBY_OPERATION_SIGN">= <span class="RUBY_IDENTIFIER">eval</span> <span class="RUBY_HEREDOC_ID"><<-"FOO"</span><span class="RUBY_SEMICOLON">;</span><span class="RUBY_LINE_CONTINUATION">\</span></div>
    <div class="line"><span class="RUBY_IDENTIFIER">printIndex</span> <span class = "RUBY_STRING">"Hello world!"</span></div>
    <div class="line CARET_ROW_COLOR"> <span class="RUBY_HEREDOC"> This is heredoc text!</span></div>
    <div class="line">  <span class="RUBY_HEREDOC_ID">FOO</span></div>
    <div class="line">&nbsp;</div>

    <div class="line"> <span class="RUBY_IDENTIFIER">foo</span><span class="RUBY_BRACKETS">(</span><span class="RUBY_STRING">"</span><span class="RUBY_EXPR_IN_STRING">#{</span><span class="RUBY_GVAR">$GLOBAL_TIME</span> <span class="RUBY_OPERATION_SIGN"> >></span> <span class="RUBY_REGEXP">$`</span><span class="RUBY_EXPR_IN_STRING">}</span> <span class="RUBY_STRING">is</span> <span class="RUBY_INVALID_ESCAPE_SEQUENCE">\</span></div><div class="line"><span class="RUBY_STRING">Z sample</span> <span class="RUBY_ESCAPE_SEQUENCE">\"</span><span class="RUBY_STRING">string</span><span class="RUBY_ESCAPE_SEQUENCE">\"</span><span class="RUBY_STRING">"</span><span class="RUBY_OPERATION_SIGN">*</span> <span class="RUBY_NUMBER">777</span><span class="RUBY_BRACKETS">)</span><span class="RUBY_SEMICOLON">;</span></div>

    <div class="line">  <span class="RUBY_KEYWORD">if</span> <span>(</span><span>$1</span> <span  class="RUBY_OPERATION_SIGN">=~</span> <span class="RUBY_REGEXP">/sample reg ex/)</span><span class="RUBY_KEYWORD"> then</span></div>

    <div class="line"> <span class="RUBY_KEYWORD">begin</span></div>
    <div class="line"><span class="RUBY_IDENTIFIER">puts</span><span class="RUBY_WORDS">%W(two words)</span><span class="RUBY_COMMA">,</span><span class="RUBY_CONSTANT">CONSTANT</span><span class="RUBY_COMMA">,</span><span class="RUBY_SYMBOL">:foo</span><span class="RUBY_SEMICOLON">;</span></div>
    <div class="line"><span class="RUBY_IDENTIFIER">do_something</span><span class="RUBY_SYMBOL">:action</span><span class="RUBY_HASH_ASSOC"> =></span><span class="RUBY_STRING">"action"</span></div>
    <div class="line"><span class="RUBY_KEYWORD"> end</span></div>
    <div class="line"><span class="RUBY_NUMBER">1</span><span class="RUBY_IDENTIFIER">.upto</span><span class="RUBY_BRACKETS">(</span><span class="RUBY_CVAR">@@n</span><span class="RUBY_BRACKETS">)</span><span class="RUBY_KEYWORD">do</span> <span class="RUBY_OPERATION_SIGN">|</span><span class="RUBY_PARAMETER_ID">index</span><span class="RUBY_OPERATION_SIGN">|</span><span class="RUBY_IDENTIFIER">printIndex</span><span class="RUBY_STRING">"Hello"</span><span class="RUBY_OPERATION_SIGN">+</span><span class="RUBY_PARAMETER_ID">index</span><span class="RUBY_KEYWORD">end</span></div>
    <div class="line"><span class="RUBY_BAD_CHARACTER">\\\\\\\\\\</span></div>
    <div class="line"><span class="RUBY_KEYWORD">end</span></div>
    <div class="line"><span class="RUBY_KEYWORD">end</span></div>


    </div></div>
      <table class="editor_medium_buttons"><tbody>
      <tr><td><a class="button-plugin" href="">button</a></td><td><a class="button-plugin" href="">button</a></td><td><a class="button-plugin" href="">Like</a></td></tr>
      <tr><td><a class="button-plugin" href="">button</a></td><td><a class="button-plugin" href="">something</a></td><td><a class="button-plugin" href="">Dislike</a></td></tr>
      </tbody></table>
 class="button Here we put buttons and all kinds of stuff outer</div>
    '
        return @out
   end
end
