
[TheWorkAround](http://theworkaround.com/) - My personal blog filled with rambling and ideas

    Serve Assets as static assets:
    jekyll serve

    Serve Site as changes happen
    jekyll serve --watch


#### For code Synax Highlighting:

    # Gemfile:
    gem 'devise-async'


    ~~~ ruby
    def what?
      42
    end
    ~~~


    {% highlight ruby %}
        require "rubygems"
        require 'rake'
        require 'yaml'
        require 'time'

        # Gemfile:
        gem 'devise-async'
    {% endhighlight %}


    {% highlight ruby %}
    def foo
      puts 'foo'
    end
    {% endhighlight %}


    ~~~
    def hello
      puts "hello world"
    end
    ~~~
    {:lang="ruby"}

    `aslf = '1'.to_s`{:lang="ruby"}