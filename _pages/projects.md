---
title: Projects
layout: default
permalink: "/projects/"
---
<header class="post-header">
  <h1 class="post-title">{{ page.title }}</h1>
</header>

<div class="post-content">
  <p>This page serves as the directory of my public project pages.</p>
</div>

<ul class="post-list">
  {% for project in site.projects %}
    <li>
      <h3>
        <a class="post-link" href="{{ project.url | relative_url }}">
          {{ project.title | escape }}
        </a>
      </h3>
      {%- if project.excerpt -%}
        <div class="post-excerpt">
          {{ project.excerpt }}
        </div>
      {%- endif -%}
    </li>
  {% endfor %}
</ul>