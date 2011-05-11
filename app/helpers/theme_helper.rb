module ThemeHelper

    def theme_to_html(theme1=nil)
      @out = '<p>null theme</p>'
      if theme1
      
      @out = theme1.to_css+'<div class="theme " > <div class="preview clear"> <div id="preview-html"><div class="editor clear " ><a href="" class ="clear"> '+' <a href="/">'+(nice_name( theme1.theme_name) )+'</a>'+'<div id="'+theme1.theme_name+'" class="preview-html">'
      @out +='<div class="line"><span class = "RUBY_SPECIFIC_CALL">require</span><span class = "RUBY_STRING"> "test"</span></div>'
      @out += '<div class="line"><span = "RUBY_CONSTANT">CONSTANT</span><span class="RUBY_OPERATION_SIGN"> =</span><span  class="RUBY_NUMBER"> 777</span></div>
   <div class="line"></div>
<div class="line"><span class="RUBY_COMMENT"># Sample comment</span></div>
   <div class="line"></div>

<div class="line"><span class="RUBY_KEYWORD">module</span><span="RUBY_CONSTANT"> SampleModule</span></div>
<div class="line"><span class = "RUBY_SPECIFIC_CALL">  include</span> <span = "RUBY_CONSTANT">Testcase</span></div>
   <div class="line"></div>

<div class="line"><span class="RAILS_SPECIFIC_CALL">  render </span><span class="RUBY_SYMBOL">:action</span> <span class="RUBY_OPERATION_SIGN">=></span><span class = "RUBY_STRING">\'foo\'</span></div>
<div class="line"> <span class="RUBY_KEYWORD"> def</span> <span class="RUBY_IDENTIFIER_ID">foo<span class="">(<span class="RUBY_IDENTIFIER">parameter<span class="RUBY_PARENTHESIS">)</div>
<div class="line">    <span class="RUBY_LOCAL_VAR_ID">@parameter </span><span class="RUBY_OPERATION_SIGN">=</span><span class="RUBY_PARAMETER_ID"> parameter</span></div>
<div class="line"> <span class="RUBY_KEYWORD"> end</span></div>
   <div class="line"></div>

<div class="line"> <span class=""> local_var <span class="">= <span class="RUBY_IDENTIFIER">eval</span> <span class="RUBY_HEREDOC_ID"><<-"FOO"</span><span class="RUBY_SEMICOLON">;</span><span class="RUBY_LINE_CONTINUATION">\</span></div>
<div class="line"><span class="RUBY_IDENTIFIER">printIndex</span> <span class = "RUBY_STRING">"Hello world!"</span></div>
<div class="line"> <span class="RUBY_HEREDOC"> And now this is heredoc!</span></div>
<div class="line"> <span class="RUBY_HEREDOC"> printIndex "Hello world again!"</span></div>
<div class="line">  <span class="RUBY_HEREDOC_ID">FOO</span></div>
<div class="line"> <span class="RUBY_IDENTIFIER">foo</span><span class="RUBY_PARENTHESIS">(</span><span class="">"<span class="">#{<span class="">$GLOBAL_TIME <span class=""> >> $`<span class="">} <span class="">is <span class="">\<span class="">Z sample <span class="">\"<span class="">string<span class="">\"<span class="">" <span class="">* <span class="">777<span class="">)<span class="">;</div>
<div class="line">  <span class="">if <span class="">(<span class="">$1 <span class="">=~ <span class="">/sample regular expression/ni)<span class=""> then</div>
<div class="line">  begin</div>
<div class="line">    puts %W(sample words), CONSTANT, :fooo;</div>
<div class="line">    do_something :action => "action"</div>
<div class="line">  end</div>
<div class="line">  1.upto(@@n) do |index| printIndex "Hello" + index end</div>
<div class="line">  \\\\\\\\\\\\\\\\\\\\</div>
<div class="line">  end</div>
<div class="line">end</div>

</div>
</a>
</div>  </div>'
      @out += '<div class="info"> <span class="downloads">Downloads: '+theme1.times_downloaded.to_s+' Rank: 33 </span><br /><span class="toppick">'+ (link_to "Download", ("themes/"+theme1.file_path.to_s) )+'</span>'  + ( link_to "Upvote", "/theme/upvote/"+(theme1.id.to_s) )+( link_to "Downvote", "/theme/downvote/"+(theme1.id.to_s) )+'  </div>    </div></div>'

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
