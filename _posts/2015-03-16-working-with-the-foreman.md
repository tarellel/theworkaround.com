---
layout: post
title: "Working with the Foreman"
date: 2015-03-16 15-03-21
description: "Using Ruby's forman gem to make managing applications easier"
tags: [ruby, rails]
---
Lets to work on using [Foreman](https://github.com/ddollar/foreman) and when I say Foreman I'm not referring to Eric Forman the goof for a son on [The 70's Show](http://www.imdb.com/title/tt0165598/?ref_=nv_sr_1). I'm talking about the Ruby gem Foreman for making your applications easier to manage and deploy.

![Eric Forman](https://i.imgur.com/vlQFjab.jpg){: .img-fluid .w-100}

For those unfamiliar with Foreman it is a way to initialize your application and its components without making a mess. Before I started using this wonderful gem, whenever I would want to test and/or run an application I would have numerous tabs open and start numerous tasks in order to even get started (Rails Server, Sidekiq, etc.). But with foreman this can all be done with a single command.

![Before Foreman](/img/before_foreman_tabs.png){: .img-fluid .w-100}

With Foreman all you need to do is install the gem, create a ``Procfile`` and put your desired tasks in it. A Profile will contain the designated tasks which you wish to have initiated when you begin the application. An example of starting the rails server with foreman could look something similar to the following

~~~ ruby
web: bundle exec rails server
~~~

Or if you wish to call you server application specifically you can use something similar to the example below.

~~~  ruby
web: bundle exec thin start
~~~

I know what you're thinking, "But wait this doesn't change anything, this is just another file to put into my Rails applications directory." But let me explain a little bit, every new line that you add to the Profile can have a task followed by it's specific command that you would normally use in the command line. For example say you run Resque, Solr, Guard, or a number of other tasks when you run your server, add these tasks and they will start with the server when you run the foreman command.


~~~ ruby
web:    bundle exec thin start
solr:   rake sunspot:solr:run
worker: bundle exec rake resque:work QUEUE=*
guard:  bundle exec guard
~~~

So now instead of having 4 or 5 different tabs open for your terminal all you need to type in the command line is ``foreman start`` and you are ready to go. Below is an example of something similar that you will be output when setup and ran properly.

~~~ shell
master!$ foreman start
18:14:06 web.1     | started with pid 1247
18:14:06 sidekiq.1 | started with pid 1248
18:14:12 web.1     | => Booting Thin
18:14:12 web.1     | => Rails 4.2.0 application starting in development on http://localhost:3000
18:14:12 web.1     | => Run `rails server -h` for more startup options
18:14:12 web.1     | => Ctrl-C to shutdown server
18:14:12 web.1     | Thin web server (v1.6.3 codename Protein Powder)
18:14:12 web.1     | Maximum connections set to 1024
18:14:12 web.1     | Listening on localhost:3000, CTRL+C to stop
~~~

### Conclusion
Using Foreman has been a wonderful resource for developing applications and initiating everything I need in order to jump into development mode. Foremen is not only used for development, it also has numerous features built in it for [production](https://github.com/ddollar/foreman/wiki/Exporting-for-production) uses as well. Including but not limited to the ``foreman export`` commands which creates application initialization for upstart and linux (using /etc/init) upon starting or rebooting of your computer.


### References
- [Rails TDD environment setup with Guard and Foreman](http://blog.crowdint.com/2012/03/01/rails-tdd-environment-setup-with-guard-and-foreman.html)
- [Rails 4 with Unicorn & Foreman](http://www.ralphonrails.com/rails/2014/02/04/new-rails-4-project.html)
- [Introducing Foreman](http://blog.daviddollar.org/2011/05/06/introducing-foreman.html)
- [Foreman Wiki](https://github.com/ddollar/foreman/wiki)
