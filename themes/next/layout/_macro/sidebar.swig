{% macro render(display_toc) %}
  <div class="toggle sidebar-toggle">
    <span class="toggle-line toggle-line-first"></span>
    <span class="toggle-line toggle-line-middle"></span>
    <span class="toggle-line toggle-line-last"></span>
  </div>

  <aside class="sidebar">
    <div class="sidebar-inner">

      {%- set display_toc = page.toc.enable and display_toc %}
      {%- if display_toc %}
        {%- set toc = toc(page.content, { class: "nav", list_number: page.toc.number, max_depth: page.toc.max_depth }) %}
        {%- set display_toc = toc.length > 1 and display_toc %}
      {%- endif %}

      <ul class="sidebar-nav motion-element">
        <li class="sidebar-nav-toc">
          {{ __('sidebar.toc') }}
        </li>
        <li class="sidebar-nav-overview">
          {{ __('sidebar.overview') }}
        </li>
      </ul>

      <!--noindex-->
      <div class="post-toc-wrap sidebar-panel">
        {%- if display_toc %}
          <div class="post-toc motion-element">{{ toc }}</div>
        {%- endif %}
      </div>
      <!--/noindex-->

      <div class="site-overview-wrap sidebar-panel">
        {{ partial('_partials/sidebar/site-overview.swig', {}, {cache: theme.cache.enable}) }}

        {{- next_inject('sidebar') }}
      </div>

      {%- if theme.back2top.enable and theme.back2top.sidebar %}
        <div class="back-to-top motion-element">
          <i class="fa fa-arrow-up"></i>
          <span>0%</span>
        </div>
        
      {% if site.tags.length > 1 %}
      <script type="text/javascript" charset="utf-8" src="{{ url_for('/js/tagcloud.js') }}"></script>
      <script type="text/javascript" charset="utf-8" src="{{ url_for('/js/tagcanvas.js') }}"></script>
      <div class="widget-wrap">
          <div id="myCanvasContainer" class="widget tagcloud">
          <canvas width="220" height="250" id="resCanvas" style="width=100%">
              {{ list_tags() }}
          </canvas>
          </div>
      </div>
      {% endif %}

      {%- endif %}

{% if site.tags.length > 1 %}
<script type="text/javascript" charset="utf-8" src="/js/tagcloud.js"></script>
<script type="text/javascript" charset="utf-8" src="/js/tagcanvas.js"></script>
<div class="widget-wrap">
    <h3 class="widget-title">标签云</h3>
    <div id="myCanvasContainer" class="widget tagcloud">
        <canvas width="250" height="250" id="resCanvas" style="width=100%">
            {{ list_tags() }}
        </canvas>
    </div>
</div>
{% endif %}


    </div>
  </aside>
  <div id="sidebar-dimmer"></div>
{% endmacro %}

      <div class="site-overview-wrap sidebar-panel{% if not display_toc or toc(page.content).length <= 1 %} sidebar-panel-active{% endif %}">
        <div class="site-overview">
          
          ...

          {% if theme.recent_posts %}
              <div class="links-of-blogroll motion-element {{ "links-of-blogroll-" + theme.recent_posts_layout  }}">
                <div class="links-of-blogroll-title">
                  <!-- modify icon to fire by szw -->
                  <i class="fa fa-history fa-{{ theme.recent_posts_icon | lower }}" aria-hidden="true"></i>
                  {{ theme.recent_posts_title }}
                </div>
                <ul class="links-of-blogroll-list">
                  {% set posts = site.posts.sort('-date') %}
                  {% for post in posts.slice('0', '5') %}
                    <li>
                      <a href="{{ url_for(post.path) }}" title="{{ post.title }}" target="_blank">{{ post.title }}</a>
                    </li>
                  {% endfor %}
                </ul>
              </div>
          {% endif %}

        {% if theme.custom_file_path.sidebar %}
          {% set custom_sidebar = '../../../../' + theme.custom_file_path.sidebar %}
        {% else %}
          {% set custom_sidebar = '../_custom/sidebar.swig' %}
        {% endif %}
        {% include custom_sidebar %}
        </div>
      </div>