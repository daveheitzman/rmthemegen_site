module ThemeHelper

    def theme_to_html(theme1=nil)
      @out = '<p>null theme</p>'
      if theme1
      @out = theme1.to_css+'<div class="theme"> <div class="preview "> <div id="preview-html "><div class="editor  " >"'+(nice_name( theme1.theme_name) )+'"<div id="'+theme1.theme_name+'" class="preview-html">'
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
<div class="line"> <span class="RUBY_IDENTIFIER">foo</span><span class="RUBY_BRACKETS">(</span><span class="RUBY_STRING">"<span class="RUBY_EXPR_IN_STRING">#{<span class="RUBY_GVAR">$GLOBAL_TIME <span class="RUBY_OPERATION_SIGN"> >> <span class="RUBY_REGEXP">$`<span class="RUBY_EXPR_IN_STRING">} <span class="RUBY_STRING">is <span class="RUBY_INVALID_ESCAPE_SEQUENCE">\<span class="RUBY_STRING">Z sample <span class="RUBY_ESCAPE_SEQUENCE">\"<span class="RUBY_STRING">string<span class="RUBY_ESCAPE_SEQUENCE">\"<span class="RUBY_STRING">" <span class="RUBY_OPERATION_SIGN">* <span class="RUBY_NUMBER">777<span class="RUBY_BRACKETS">)<span class="RUBY_SEMICOLON">;</div>
<div class="line">  <span class="RUBY_KEYWORD">if <span class="">(<span class="">$1 <span class="">=~ <span class="">/sample regular expression/ni)<span class="RUBY_KEYWORD"> then</div>
<div class="line"> <span class="RUBY_KEYWORD"> begin</div>
<div class="line">    puts %W(sample words), CONSTANT, :fooo;</div>
<div class="line">    do_something :action => "action"</div>
<div class="line"> <span class="RUBY_KEYWORD"> end</div>
<div class="line">  1.upto(@@n) do |index| printIndex "Hello" + index end</div>
<div class="line">  \\\\\\\\\\\\\\\\\\\\</div>
<div class="line">  end</div>
<div class="line">end</div>

</div>
</div>
</div>  '
      @out += '<div class="info"> <span class="downloads">Rank: '+theme1.rank.to_s+' &nbsp;&nbsp;Downloaded:'+ theme1.times_downloaded.to_s+' </span><br /><span class="toppick">'+ (link_to "Download", ("/theme/download/"+theme1.id.to_s) )+'</span>'  + ( link_to "Upvote", "/theme/upvote/"+(theme1.id.to_s) )+"&nbsp;&nbsp;&nbsp;"+( link_to "Downvote", "/theme/downvote/"+(theme1.id.to_s) )+'  </div>    </div></div>'

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


end
