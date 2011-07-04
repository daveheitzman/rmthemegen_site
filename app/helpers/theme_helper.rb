module ThemeHelper

    def theme_to_html(theme1=nil)
      @out = '<p>null theme</p>'
      if theme1
        editor_links_to = case theme1.bg_color_style
        when 0
          '/theme/'
        when 1
          '/theme/'
        when 2
          '/theme/'
        end

        editor_links_to += theme1.id.to_s
        editor_links_to = theme_path theme1.id

      @out = theme1.to_css+'<div class="theme"> <div class="preview "> <div id="preview-html "><a href="'+editor_links_to+'"><div class="editor">"'+(nice_name( theme1.theme_name) )+'"<div id="'+theme1.theme_name+'" class="preview-html">'
      @out +='<div class="line"><span class = "RUBY_SPECIFIC_CALL">require</span><span class="RUBY_STRING"> "test"</span></div>'
      @out += '<div class="line"><span class="RUBY_CONSTANT">CONSTANT</span><span class="RUBY_OPERATION_SIGN"> =</span><span class="RUBY_NUMBER">777</span></div>
   <div class="line"></div>
<div class="line"><span class="RUBY_COMMENT"># Sample comment</span></div>
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
<div class="line"><span class="RUBY_IDENTIFIER">printIndex</span> <span class = "RUBY_STRING">"Hello world!"</span></div>
<div class="line"> <span class="RUBY_HEREDOC"> And now this is heredoc!</span></div>
<div class="line"> <span class="RUBY_HEREDOC"> printIndex "Hello world again!"</span></div>
<div class="line">  <span class="RUBY_HEREDOC_ID">FOO</span></div>
<div class="line"n> <span class="RUBY_IDENTIFIER">foo</span><span class="RUBY_BRACKETS">(</span><span class="RUBY_STRING">"<span class="RUBY_EXPR_IN_STRING">#{<span class="RUBY_GVAR">$GLOBAL_TIME <span class="RUBY_OPERATION_SIGN"> >> <span class="RUBY_REGEXP">$`<span class="RUBY_EXPR_IN_STRING">} <span class="RUBY_STRING">is <span class="RUBY_INVALID_ESCAPE_SEQUENCE">\<span class="RUBY_STRING">Z sample <span class="RUBY_ESCAPE_SEQUENCE">\"<span class="RUBY_STRING">string<span class="RUBY_ESCAPE_SEQUENCE">\"<span class="RUBY_STRING">" <span class="RUBY_OPERATION_SIGN">* <span class="RUBY_NUMBER">777<span class="RUBY_BRACKETS">)<span class="RUBY_SEMICOLON">;</div>
<div class="line">  <span class="RUBY_KEYWORD">if <span class="">(<span class="">$1 <span class="">=~ <span class="">/sample regular expression/ni)<span class="RUBY_KEYWORD"> then</div>
<div class="line"> <span class="RUBY_KEYWORD"> begin</div>
<div class="line">    puts %W(sample words), CONSTANT, :fooo;</div>
<div class="line">    do_something :action => "action"</div>
<div class="line"> <span class="RUBY_KEYWORD"> end</div>
<div class="line">  1.upto(@@n) do |index| printIndex "Hello" + index end</div>
<div class="line">  \\\\\\\\\\\\\\\\\\\\</div>
<div class="line">  end</div>
<div class="line">end</div>
</a></div></div></div>  '
      @out += '<div class="info"><table><tr><td><span class="downloads">Rank: '+theme1.rank.to_s+'&nbsp;&nbsp;&nbsp;Downloads:'+ theme1.times_downloaded.to_s+'</span></td><td><span class="upvote_button">'  + ( link_to (raw "&nbsp;&nbsp;Upvote&nbsp;&nbsp;&nbsp;"), "/theme/upvote/"+(theme1.id.to_s), :remote=>true )+'</span></td></tr><tr><td><span class="download_button">'+ (link_to "Download", ("/theme/download/"+theme1.id.to_s) )+'</span></td><td><span class="downvote_button">'+( link_to "Downvote", "/theme/downvote/"+(theme1.id.to_s), :remote=>true )+
  '</span></td></tr></table>  </div>    </div></div>'

      end
      return @out

    end

    def nice_name(theme_name=nil)
      if !theme_name.nil? then
        glyphs = theme_name.split("_")
        glyphs[0][0] = glyphs[0][0,1].upcase
        glyphs[1][0] = glyphs[1][0,1].upcase
        glyphs[0] +" "+ glyphs[1]
      end
    end

    def colorize_string(str1, background_color="FFFFFF", min_contrast=0.23)
      # returns a new string with each of its characters given a random color that is at least some certain minimum
      # contrast against the background. it will be surrounded by a span.  
      @rc= RMThemeGen::ThemeGenerator.new
      @ban = '<span>'


      str1.size.times do |i|
        @ban += '<span style="color:#'+@rc.randcolor(:bg_rgb=>background_color, :min_cont =>0.24)+';">'+str1[i,1]+'</span>'
      end
      @ban
    end

    def bg_color_types_menu

  '<tr>
    <td style="background-color:black;color:white;">
      <a href="/theme/show_colortype_page/dark"><div style="text-align:center;width:100%;height:100%;">Dark Themes</div></a></td>

    <td style="text-align:center;background-color:yellow;color:black;">
      <a href="/theme/show_colortype_page/color">
        <div style="width:100%;height:100%;">Color Themes</div></a></td>

    <td style="text-align:center;background-color:#dedede;color:black;">
      <a href="/theme/show_colortype_page/light">
        <div style="width:100%;height:100%;">Light Themes</div></a></td></tr>'
    end

end
