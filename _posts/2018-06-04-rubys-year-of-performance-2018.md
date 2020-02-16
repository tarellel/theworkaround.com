---
layout: post
title: "Ruby's Year of Performance (2018)"
date: 2018-06-04 09-06-56
description: ""
tags: [performance, ruby]
comments: true
---
Many people claim Ruby is no longer relevant and quite a few people have moved on to Elixir, Go, Rust, and Node. This is because Ruby was not originally built for speed, it was built for ease of use. It does have its limitations and Rails is a monstrosity with all it’s services, workers, etc. But I’ve never had an issue with this, I started using Ruby because of its ease of use. I can from a world of using PHP and ugly spaghetti code to Ruby where coding is more of a thing of art.

But 2018 has been a big year for Ruby releases and trying to meet their [3x3](https://blog.heroku.com/ruby-3-by-3) performance goals ([RedHat Writeup](https://developers.redhat.com/blog/2018/03/22/ruby-3x3-performance-goal/)). And in the last year alone, [Arron Patterson (tenderlove)](https://twitter.com/tenderlove) and various contributors have made amazing advances in improving Ruby's performance. And the addition of a [JIT compiler](https://www.ruby-lang.org/en/news/2018/05/31/ruby-2-6-0-preview2-released/) to Ruby is no ease feat that looks like it will also have a HUGE effect on Ruby to regain some ground and no longer be known as a "slow language".
I admit [Ruby Truffle](https://github.com/oracle/truffleruby) has some extreme potential to improve Rubys performance using the [GraalVM](https://www.graalvm.org/) but since Oracle does have a tendency to take people to court and suing them, for using their various technological components.

Another modification that I have found that dramatically improves performance and reduces memory usage is by adding [jemalloc](http://jemalloc.net/). By default, the MRI version uses the glibc memalloc library.

To use jemalloc with ruby lets first install the library, so we can use it when compiling out ruby binaries.
```shell
# OSx
brew install jemalloc

# Ubuntu/Debian
sudo apt-get update
sudo apt-get install libjemalloc1 libjemalloc-dev
```

Many of people prefer [ruby-build](https://github.com/rbenv/ruby-build) for compiling new ruby versions but I prefer [RVM](https://rvm.io/) because of it's ease of use. Now to compile with jemmalloc, we need to add the flags for RVM to compile using the jemalloc library.
```shell
rvm install 2.5 -C --with-jemalloc --autolibs=disable
```

I tend to use the [Fish](https://fishshell.com/) shell, it has dramatically increased my productivity with its ease of use, auto completion libraries, and great features. So to make compiling a new RVM instance easier I created a function titled `rvm_install` so now when I want to compile a new Ruby version with the jemalloc flag I issue a command similar to the following `rvm_install 2.6` and wait. Below is a copy of the function I created, I know I should probably issue some validation to verify the value of the argument, but I'm the only one using this on my computer and it's works wonders for what I need it for.

```shell
# Install the specified Ruby version through RVM, with the jemalloc library included
function rvm_install
  # verify a version number was specified
  if count $argv > /dev/null
    echo "Installing Ruby-$argv with jemalloc"
    rvm install $argv -C --with-jemalloc
  else
    echo "Please specify a version to install."
  end
end
```


Now lets take a look at a few Ruby versions to test how well they perform with and without jemalloc. Sam Saffron's [stress test](https://github.com/SamSaffron/allocator_bench/blob/master/stress_mem.rb) is a great way to compare performance gains and memory allocation. And let me reiterate that I didn't just run this test a single time and compare the results. These use the averages after running each stress test several times.

```ruby
# Results for Ruby_v2.5.0p0
Duration: 9.542045
RSS: 137860

# Ruby_v2.5.0p0 with jemmalloc
Duration: 7.420393
RSS: 129616

Faster w/Jemalloc:
0.222347725251767 ==> 22% faster


# Ruby_v2.6.0-preview2 with jemalloc
Duration: 6.743956
RSS: 144108

# Faster than 2.5
0.09115918792980371 ==> 9% faster
```

As you can see, just adding jemalloc to MRI ruby adds quite a noticeable performance gain. And even when not using a different memory allocator, each new Ruby release has had quite a significant impact on building on the languages potential.

~ **NOTE:** These tests are performed on a MBP with OSx 10.12,  a 2.2ghz i7, 16GB of RAM, and a SSD. So the results may vary from device to device.
