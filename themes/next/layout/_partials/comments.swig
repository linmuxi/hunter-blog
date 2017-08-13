{% if page.comments %}
  <div class="comments" id="comments">
    {% if (theme.duoshuo and theme.duoshuo.shortname) or theme.duoshuo_shortname %}
      <div class="ds-thread" data-thread-key="{{ page.path }}"
           data-title="{{ page.title }}" data-url="{{ page.permalink }}">
      </div>
    {% elseif theme.facebook_sdk.enable and theme.facebook_comments_plugin.enable %}
      <div class="fb-comments"
           data-href="{{ page.permalink }}"
           data-numposts="{{ theme.facebook_comments_plugin.num_of_posts }}"
           data-width="{{ theme.facebook_comments_plugin.width }}"
           data-colorscheme="{{ theme.facebook_comments_plugin.scheme }}">
      </div>
    {% elseif theme.disqus_shortname %}
      <div id="disqus_thread">
        <noscript>
          Please enable JavaScript to view the
          <a href="//disqus.com/?ref_noscript">comments powered by Disqus.</a>
        </noscript>
      </div>

    <!-- 20170813 by hunterlin -->
    {% elseif theme.laibili.enable %}
      <!-- 来必力City版安装代码 -->
      <div id="lv-container" data-id="city" data-uid="MTAyMC8zMDE0NS82NzAw">
        <script type="text/javascript">
         (function(d, s) {
             var j, e = d.getElementsByTagName(s)[0];

             if (typeof LivereTower === 'function') { return; }

             j = d.createElement(s);
             j.src = 'https://cdn-city.livere.com/js/embed.dist.js';
             j.async = true;

             e.parentNode.insertBefore(j, e);
         })(document, 'script');
        </script>
      <noscript> 为正常使用来必力评论功能请激活JavaScript</noscript>
      </div>
      <!-- City版安装代码已完成 -->

    {% elseif theme.hypercomments_id %}
    {% endif %}
  </div>
{% endif %}
