---
layout: post
title: "Slimming Down"
date: 2014-11-05 18-11-48
description: ""
tags: [rails, ruby, slim]
---
I have used Slim on various projects and have grown to thoroughly enjoy using it. [Slim](http://slim-lang.com/index.html) is a simple, lightweight, and fast Rails templating alternative to ERB or HAML. I prefer it over HAML because of it's use of use and it takes almost nothing to get started.

### Setup
In order to been using Slim with your Rails application, simple add the following line to your Gemfile.

~~~ ruby
gem "slim-rails"
~~~

And continue making your views as usual, but instead of using the file extension of <code>*.html.erb</code> your being the file extension <code>*.html.slim</code>. Than you can  begin formatting your views using the Slim syntax right away. It doesn't take a magician playing tricks all night in order to get running, it has a very simple setup and the syntax is quite easy to grasp and get started on. If you know how to format views (using ruby and HTML) using Rails basic templating engine ERB, switch to Slim will be a piece of cake. And what makes it even easier is you can render layouts, partials, includes, etc. with both erb and Slim interchangeably. Say for example your applications primary layout is <code>application.html.erb</code> you can include a partial: <code>header.html.slim</code>.


### Comparing ERB and Slim
Not only is Slim fast and clean, it's quite a bit less cluttered than using erb. When using slim you simplify and clean up your templates and allow for a much more readable structure and tag hierarchy. For example compare the following examples

~~~ erb
# ERB
<ul class="candylist">
  <% @candy.each do |candy| %>
    <li><%= candy.type %></li>
  <% end %>
</ul>
~~~


~~~ ruby
# Slim
ul.candylist
  - @candy.each do |candy|
    li = candy.type
~~~

And no matter which option you choose to go with, they both output the exact same thing.

~~~ html
<ul class="candylist">
  <li>Jaw Breaker</li>
  <li>Lollipop</li>
  <li>Pop Rocks</li>
  <li>Skittles</li>
</ul>
~~~

The Slim template engine removes the complexities and unnecessary clustering of tags associated with using ERB. Slim is very concise, free flowing, and easy to read. Look at the example above and tell me it isn't dead simple to understand exactly what is going on without a ton of extra tags. Another great thing I absolutely love is, Whitespace Matters! Some may argue "blah blah blah, this is to much like Python and kills the whole concept of ERB/Ruby". Well if you're already writing legible and structured code in the first place, than you should already be indenting and tabbing to begin with.


#### Bad Example
~~~ ruby
# Slim
ul
li
p.splash
| Hello World

# Outputs
<ul><ul>
<li></li>
<p class="splash">Hello World</p>
~~~

#### Better Example
~~~ ruby
# Slim
ul
  li
    p.splash
      | Hello World

# Outputs
<ul>
  <li>
    <p class="splash">Hello World</p>
  <li>
<ul>

~~~


For those of you into all the big buzz words flying around, just think of it as the CoffeeScript, Sass, Less, or any other abstraction engine except for HTML. It's quick, clean, and easy to use.
