---
layout: post
title: "Resque to Sidekiq"
date: 2014-10-29 14-10-39
description: "Background processing with SideKiq"
tags: [ruby, rails, redis]
---
Background processing is an important feature with any web application to improve performance.
Not only does it free up your application for requests, it can be used to prioritize tasks and delay processes until your system has available resources.

This post is not about [delayed_job](https://github.com/collectiveidea/delayed_job), [beanstalkd](https://kr.github.io/beanstalkd/), [girl_friday](https://github.com/mperham/girl_friday), [sucker_punch](https://github.com/brandonhilkert/sucker_punch), or a [wide selection](https://www.ruby-toolbox.com/categories/Background_Jobs) of other background processors.
Even though I’ve used delayed_job which is amazingly easy to setup and use, I don’t exactly want to clog up my ActiveRecord database with database queries. The use of a key-value store tends to make things fast and simple as it is.
For background jobs, caching, and various other tasks Redis does an amazing job: it’s fast, reliable, and does over complicate the application.

Until recently I had been using [Resque](https://github.com/resque/resque) the Holy Grail of Ruby based background processors and it has worked flawlessly to the needs I required.
But one of the applications I have setup allows users to upload as many images \(using [Carrierwave](https://github.com/carrierwaveuploader/carrierwave)\) as they want at any given time.
Upon successful upload of these images the files mime-types and extensions are verified to ensure that malicous files aren't being uploaded to the server.
Than the images are processed to create thumbnails, gallery images, etc. and when you're processing numerous image files at one time without background processing this absolutely bogs down a server.
When you have some a mechanism to do this effecively in the background this doesn't have such a huge impact. But as of lately with a higher user base the image uploads have begin to display delayes in their processing times.


It may not seem like much, but when it’s a few images here and there from numerous users at any given time, the processing time begins to add up.
Especially when upon upload a thumbnail is generated and expected to be displayed almost immediately showing the available uploads for use.


One great thing about Sidekiq is that just like Resque it uses [Redis](http://redis.io/), if you’ve never used Redis before, please do us all a favor and at least give a quick try.
Compared to large SQL databases it’s very simple (key/value pair) and extremely fast, [some people](https://github.com/redis-store/redis-rails) have gone as far to use it for caching, sessions, and various other tasks.


The amazing part that makes this migration from Resque to Sidekiq fast and easy is that both libraries use Redis as their backend database to keep track of queues/tasks.
A lot of the gems and initializers just require that you to change the backend from resque to sidekiq, while others just adjust to detecting what’s available.
{% highlight ruby %}
# carrierwave_backgrounder
c.backend :resque
c.backend :sidekiq

# devise-async
Devise::Async.backend = :resque
Devise::Async.backend = :sidekiq
{% endhighlight %}

In order to get everything working propely with your gems only slight adjustments are required.
{% highlight ruby %}
# Gemfile

#gem 'resque', :require => "resque/server"
gem 'sidekiq', :github => 'mperham/sidekiq'
gem 'devise-async'
gem 'carrierwave_backgrounder'

# And if your using it for caching, sessions, etc.
gem 'redis-rails'
{% endhighlight %}
Performance wise, I have have noticed a significant increase in processing speed. Resque and delayed_job were produced when Ruby/Rails was
hitting a massive explosion of growth something was needed and needed fast. Don't get me wrong Resque is an amazing ruby gem, but if your
application is using thread-safe libraries Sidekiq will kick quite a punch when it comes to your background processes.
Upon benchmarking, Sidekiq tends to significantly outperform Resque when it comes to completing background processes.

### GoWorker
Seeing as how lately I've been dealing with [Go](http://golang.org/) not only for it smooth edge, but compiled libraries tent to perform significantly faster than interpreted languages, another option I considered (and still am looking into is) [goworker](http://www.goworker.org/).
Goworker is pretty much a drop in replacement for Resque and Sidekiq, relies on Redis as well and massively out performed them both.
But before I attempt to push this any faster and milk every drop of performance out of the application, I plan to learn quite a bit more about programming with Go.

### Performance
Performance wise, I have have noticed a significant increase in processing speed. Resque and delayed_job were produced when Ruby/Rails was
hitting a massive explosion of growth something was needed and needed fast. Don't get me wrong Resque is an amazing ruby gem, but if your
application is using thread-safe libraries Sidekiq will kick quite a punch when it comes to your background processes.
Upon benchmarking, Sidekiq tends to significantly outperform Resque when it comes to completing background processes.

### GoWorker
Seeing as how lately I've been dealing with [Go](http://golang.org/) not only for it smooth edge, but compiled libraries tent to perform significantly faster than interpreted languages, another option I considered (and still am looking into is) [goworker](http://www.goworker.org/).
Goworker is pretty much a drop in replacement for Resque and Sidekiq, relies on Redis as well and massively out performed them both.
But before I attempt to push this any faster and milk every drop of performance out of the application, I plan to learn quite a bit more about programming with Go.
