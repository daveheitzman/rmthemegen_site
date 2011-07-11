require 'rubygems'
require 'will_paginate'

class RmtTheme < ActiveRecord::Base
  
  @minimum_themes = 830 #for each category
  @maximum_themes = 850
  if ENV["RAILS_ENV"]=="development" then
     @minimum_themes= 5*16
     @maximum_themes= 5*16+11 
  end
  @bg_styles = [0,1,2]
  cattr_reader :per_page
  @@per_page = 12
  has_many :newsfeeds, :foreign_key => :theme_id
  has_many :theme_comments, :foreign_key => :theme_id



  def self.do_maintenance

   if RmtTheme.count > @maximum_themes
      lowest_ranked = find( :all, :order=>"`rank` desc, `created_at` asc ")[0..rand(@maximum_themes-@minimum_themes)+2]
      lowest_ranked.each {|i|
         File.delete(i.file_path) if File.exists?(i.file_path)
         msg = "#{i.style_pretty} theme '#{i.nice_name}' deleted"
         msg[0]=msg[0,1].upcase
         i.newsfeeds << Newsfeed.create(:message =>msg)
         i.delete
      }
   elsif RmtTheme.count <= @maximum_themes && RmtTheme.count > @minimum_themes
      create_theme(:bg_color_style => (rand*3).to_i)
   else # create themes until at least the minimum number exist
      while (RmtTheme.count <= @minimum_themes )
         create_theme(:bg_color_style => (rand*3).to_i)
      end
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
    new_theme_record = new(:theme_name => "", :to_css =>'', :times_downloaded=>0,:times_clicked=>0, :created_at=>Time.zone.now,:last_downloaded=>Time.zone.now,:last_clicked=>Time.zone.now,:rank=>9999999, :upvotes=>0, :downvotes=>0,:bg_color_style=>0,:file_path=>File.expand_path(nt), :pop_score => rand(5).to_i )
    new_theme_record.to_css = theme_generator.to_css
    new_theme_record.theme_name = theme_generator.themename
    new_theme_record.bg_color_style = opts[:bg_color_style]
    new_theme_record.save

    msg = "#{new_theme_record.style_pretty} theme <a href='/theme/#{new_theme_record.id}'>'#{new_theme_record.nice_name}'</a> created"
    msg[0]=msg[0,1].upcase
    new_theme_record.newsfeeds << Newsfeed.create(:message=>msg, :created_at=>Time.zone.now)

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

  def to_html_small(message)
  
  @out = to_css+'<a href="'+"/theme/#{id}"+'"><div class="editor_box"><div class="editor_title">"'+(nice_name[0..17])+'"</div><div class="editor small"><div id="'+theme_name+'">'
      @out +='<div class="line"><span class = "RUBY_SPECIFIC_CALL">require </span><span class="RUBY_KEYWORD">File.dirname</span><span class="RUBY_BRACKETS">(</span><span class="RUBY_CONSTANT">__FILE__</span><span class="RUBY_BRACKETS">)</span><span class="RUBY_OPERATION_SIGN">+</span><span class = "RUBY_STRING">"/token_list"</span></div>
<div class="line">&nbsp; </div>
<div class="line"><span class="RUBY_CONSTANT">CONSTANT</span><span class="RUBY_OPERATION_SIGN"> =</span><span class="RUBY_NUMBER"> 777</span><span class="RUBY_COMMENT">&nbsp;&nbsp; #TODO: change to 778</span></div>
       <div class="line"></div>

    <div class="line"><span class="RUBY_KEYWORD">module</span><span class="RUBY_CONSTANT"> SampleModule</span><span class="RUBY_OPERATION_SIGN"> < </span><span class="RUBY_CONSTANT"> ParentModule</span></div>
    <div class="line"><span class = "RUBY_SPECIFIC_CALL">&nbsp;&nbsp;include</span> <span class = "RUBY_CONSTANT">Testcase</span></div>
       <div class="line"></div>
    <div class="line"><span class="RUBY_PARAMDEF_CALL">&nbsp;&nbsp;render </span><span class="RUBY_SYMBOL">:action</span> <span class="RUBY_OPERATION_SIGN">=></span><span class = "RUBY_STRING">\'foo\'</span></div>
    <div class="line"> <span class="RUBY_KEYWORD">&nbsp;&nbsp;def</span><span class="RUBY_METHOD_NAME"> foo</span><span class="RUBY_BRACKETS">(</span><span class="RUBY_PARAMETER_ID">parameter</span><span class="RUBY_BRACKETS">)</span></div>
    <div class="line"><span class="RUBY_LOCAL_VAR_ID">&nbsp;&nbsp;&nbsp;&nbsp;@object_var </span><span class="RUBY_OPERATION_SIGN">=</span><span class="RUBY_IVAR"> parameter</span></div>
    <div class="line"> <span class="RUBY_KEYWORD">&nbsp;&nbsp;end</span></div>
       <div class="line">&nbsp;</div>

    <div class="line"> <span class="RUBY_LOCAL_VAR_ID">&nbsp;&nbsp;local_var <span class="RUBY_OPERATION_SIGN">= <span class="RUBY_IDENTIFIER">eval</span> <span class="RUBY_HEREDOC_ID"><<-"FOO"</span><span class="RUBY_SEMICOLON">;</span><span class="RUBY_LINE_CONTINUATION">\</span></div>
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
</div></div>'



   if message.size > 0 then
     @out += '<div "editor_small_message">'+message+'</div>'
   end

   @out += '</div></a>'
   return @out
  end



   def to_html_medium
      @out = to_css+'<div class="editor_box_medium"><div class="editor_title">"'+(nice_name)+'"</div><div class="download_button" style="float:right;"></div><div class="editor editor_medium"><div id="'+theme_name+'" >'

          @out +='<div class="line"><span class = "RUBY_SPECIFIC_CALL">require </span><span class="RUBY_KEYWORD">File.dirname</span><span class="RUBY_BRACKETS">(</span><span class="RUBY_CONSTANT">__FILE__</span><span class="RUBY_BRACKETS">)</span><span class="RUBY_OPERATION_SIGN">+</span><span class = "RUBY_STRING">"/token_list"</span></div>
<div class="line">&nbsp; </div>
<div class="line"><span class="RUBY_CONSTANT">CONSTANT</span><span class="RUBY_OPERATION_SIGN"> =</span><span class="RUBY_NUMBER"> 777</span><span class="RUBY_COMMENT">&nbsp;&nbsp; #TODO: change to 778</span></div>
       <div class="line"></div>

    <div class="line"><span class="RUBY_KEYWORD">module</span><span class="RUBY_CONSTANT"> SampleModule</span><span class="RUBY_OPERATION_SIGN"> < </span><span class="RUBY_CONSTANT"> ParentModule</span></div>
    <div class="line"><span class = "RUBY_SPECIFIC_CALL">&nbsp;&nbsp;include</span> <span class = "RUBY_CONSTANT">Testcase</span></div>
       <div class="line"></div>
    <div class="line"><span class="RUBY_PARAMDEF_CALL">&nbsp;&nbsp;render </span><span class="RUBY_SYMBOL">:action</span> <span class="RUBY_OPERATION_SIGN">=></span><span class = "RUBY_STRING">\'foo\'</span></div>
    <div class="line"> <span class="RUBY_KEYWORD">&nbsp;&nbsp;def</span><span class="RUBY_METHOD_NAME"> foo</span><span class="RUBY_BRACKETS">(</span><span class="RUBY_PARAMETER_ID">parameter</span><span class="RUBY_BRACKETS">)</span></div>
    <div class="line"><span class="RUBY_LOCAL_VAR_ID">&nbsp;&nbsp;&nbsp;&nbsp;@object_var </span><span class="RUBY_OPERATION_SIGN">=</span><span class="RUBY_IVAR"> parameter</span></div>
    <div class="line"> <span class="RUBY_KEYWORD">&nbsp;&nbsp;end</span></div>
       <div class="line">&nbsp;</div>

    <div class="line"> <span class="RUBY_LOCAL_VAR_ID">&nbsp;&nbsp;local_var <span class="RUBY_OPERATION_SIGN">= <span class="RUBY_IDENTIFIER">eval</span> <span class="RUBY_HEREDOC_ID"><<-"FOO"</span><span class="RUBY_SEMICOLON">;</span><span class="RUBY_LINE_CONTINUATION">\</span></div>
    <div class="line"><span class="RUBY_IDENTIFIER">&nbsp;&nbsp;printIndex</span> <span class = "RUBY_STRING">"Hello world!"</span></div>
    <div class="line CARET_ROW_COLOR"> <span class="RUBY_HEREDOC">&nbsp;&nbsp;This is heredoc text!</span></div>
    <div class="line">  <span class="RUBY_HEREDOC_ID">&nbsp;&nbsp;FOO</span></div>
    <div class="line">&nbsp;</div>

    <div class="line"> <span class="RUBY_IDENTIFIER">&nbsp;&nbsp;foo</span><span class="RUBY_BRACKETS">(</span><span class="RUBY_STRING">"</span><span class="RUBY_EXPR_IN_STRING">#{</span><span class="RUBY_GVAR">$GLOBAL_TIME</span> <span class="RUBY_OPERATION_SIGN"> >></span> <span class="RUBY_NTH_REF">$`</span><span class="RUBY_EXPR_IN_STRING">}</span> <span class="RUBY_STRING">is</span> <span class="RUBY_INVALID_ESCAPE_SEQUENCE">\</span></div>
<div class="line"><span class="RUBY_STRING">&nbsp;&nbsp;Z sample</span> <span class="RUBY_ESCAPE_SEQUENCE">\"</span><span class="RUBY_STRING">string</span><span class="RUBY_ESCAPE_SEQUENCE">\"</span><span class="RUBY_STRING">"</span><span class="RUBY_OPERATION_SIGN">*</span> <span class="RUBY_NUMBER">777</span><span class="RUBY_BRACKETS">)</span><span class="RUBY_SEMICOLON">;</span></div>


    <div class="line">  <span class="RUBY_KEYWORD">&nbsp;&nbsp;if</span> <span class="RUBY_BRACKETS">(</span><span class="RUBY_NTH_REF">$1</span> <span  class="RUBY_OPERATION_SIGN">=~</span> <span class="RUBY_REGEXP">/sample reg ex/)</span><span class="RUBY_KEYWORD"> then</span></div>

    <div class="line"> <span class="RUBY_KEYWORD">&nbsp;&nbsp;begin</span></div>
    <div class="line"><span class="RUBY_IDENTIFIER">&nbsp;&nbsp;&nbsp;&nbsp;puts&nbsp  </span><span class="RUBY_WORDS">%W(two words)</span><span class="RUBY_COMMA">,</span><span class="RUBY_CONSTANT">CONSTANT</span><span class="RUBY_COMMA">,</span><span class="RUBY_SYMBOL">:foo</span><span class="RUBY_SEMICOLON">;</span></div>
    <div class="line"><span class="RUBY_IDENTIFIER">&nbsp;&nbsp;&nbsp;&nbsp;do_something</span><span class="RUBY_SYMBOL">&nbsp;:action</span><span class="RUBY_HASH_ASSOC"> =></span><span class="RUBY_STRING">&nbsp;"action"</span></div>
    <div class="line"><span class="RUBY_KEYWORD">&nbsp;&nbsp;end</span></div>
    <div class="line"><span class="RUBY_NUMBER">&nbsp;&nbsp;1</span><span class="RUBY_IDENTIFIER">.upto</span><span class="RUBY_BRACKETS">(</span><span class="RUBY_CVAR">@@n</span><span class="RUBY_BRACKETS">)</span><span class="RUBY_KEYWORD">&nbsp;do</span><span class="RUBY_OPERATION_SIGN">&nbsp;|</span><span class="RUBY_PARAMETER_ID">index</span><span class="RUBY_OPERATION_SIGN">|</span><span class="RUBY_IDENTIFIER">&nbsp;foopr</span><span class="RUBY_STRING">&nbsp;"Hello"</span><span class="RUBY_OPERATION_SIGN">+</span><span class="RUBY_PARAMETER_ID">index</span><span class="RUBY_KEYWORD">&nbsp;end</span></div>
    <div class="line"><span class="RUBY_BAD_CHARACTER">\\\\\\\\\\</span></div>
    <div class="line"><span class="RUBY_KEYWORD">end</span></div>


    </div></div>
      <table class="editor_medium_buttons"><tbody>
      <tr><td>Created: '
      Time::DATE_FORMATS[:rmtg]="%b %d, %Y at %I:%M %p"
      @out+=created_at.localtime.to_formatted_s(:rmtg)+'<br/>Views: <span style="color:#E9A172;font-weight: heavy;font-size: 1.1em">'+times_clicked.to_s+'</span>&nbsp;&nbsp;Rank: <span style="color:#E9A172;font-weight: heavy;font-size: 1.1em">'+rank.to_s+'</span> / '+RmtTheme.count.to_s+'</td><td></td><td><a class="button-plugin" href="'+("/theme/upvote/#{id}" )+'">Like</a></td></tr>
      <tr><td>Likes: ' +upvotes.to_s+' Dislikes: '+downvotes.to_s+' Comments: '+theme_comments.count.to_s+' Downloads: '+times_downloaded.to_s+'</td><td><a class="button-plugin" href="'+("/theme/download/#{id}" )+'">Download</a></td><td><a class="button-plugin" href="'+("/theme/downvote/#{id}")+'">Dislike</a></td></tr>
      </tbody></table> </div>'
     return @out
   end
end
