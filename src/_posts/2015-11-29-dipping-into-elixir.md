---
layout: post
title: "Dipping into Elixir"
date: 2015-11-29 22-11-58
description: ""
tags: [development, elixir, programming]
comments: true
---

### Elixir

Elixir seems to be next big craze among a portion of the Ruby community, everyone is migrating to try and find out what's cool. First is was [node](https://nodejs.org/en/), than [GO](https://golang.org/), and now it's [Elixir](http://elixir-lang.org/). The ruby community always seems to be in a state of flux with it's developers wanting the latest and greatest technologies. They'll try the latest new programming language because it's faster, supports XYZ functionality, or has feature JKL. But there's no beating the readability of ruby code and it's easy to learn for a beginner. Elixir does come close in many ways, seeing as how [the creator](http://blog.plataformatec.com.br/) of Elixir was also a Core RubyOnRails developer, I'm sure he took a load of inspiration from programming in Ruby to make Elixir as readable and DRY as possible.

At the moment there seems to be a noticeable movement in the Ruby Community to try out and use Elixir. I believe this migration isn't just because it's the hip-new programming language to try. Elixir is a shiny new toy, but it's built upon a stable and time tested programming language - [Erlang](http://www.erlang.org/) which is a 30 year old language. Erlang is proven and tested to run readability, seeing as how some of it's features make it scalable and fault tolerant. Another very noticeable feature build into Erlang/Elixir is they support concurrency a heck of a lot better than Ruby does. We do have [threads](http://ruby-doc.org/core-2.2.2/Thread.html) and [sidekiq](http://sidekiq.org/) that we can use, but that gets messy, can cause memory leaks, and complicate your application. I also know for a fact several people have taken the dive because [José Valim](http://blog.plataformatec.com.br/) a major core developer and contributor in the Ruby/Rails scene is also the primary creator of the Elixir Programming language.

I for one can say, I have also spent a large amount of time lately looking into building with and learning the Elixir language. I'm not saying I'm completely giving up on using Ruby or switching my programming languages of preference. The reason I looked into Elixir is to broaden my perspectives, it's always good for a programmer to try new languages, new programming concepts, and learn new techniques on how things are done.

---

## Let's take a look at Elixir

### This isn't an Object-Oriented language

I have never really worked with a purely Function Programming Language before. Sure I've checked out samples here and there, but everything I've generally played with has been primarily Object-Oriented. For those who don't know exactly what I'm talking about, below is an example showing comparative differences between the two types.

```ruby
str = "Hello World"

# Functional
String.length(str)  # -> 11

# Object-Oriented
str.length  # -> 11
```

The line `String.length` may look like a basic usage of object-orientation, but Elixir uses modules which to put it simple is using functional namespaces to assign the functions. This makes it easy to distinguish how your function and it's data will be processed `String.blah, Enum.blah, System.blah, etc`.

Another way to look at it in a tree view is similar to the example shown:

```elixir
# Elixir string namespace and functions: http://elixir-lang.org/docs/stable/elixir/String.html
defmodule String do
  def length(str) do
    # ...
  end

  def strip(str) do
    # ...
  end
end
```

Elixir also has the ability to assign anonymous functions, which has it's uses once you've gotten to know the basics of the language.

```elixir
foo = fn (x) -> "Hello #{x}!" end
foo.("Rick")
```

Another very appealing set of features that Elixir has is that it has the ability to conditionally process functions based on the supplied values.

```elixir
defmodule Foo do
  def bar(0), do: 0
  def bar(n), do: IO.puts n

  def bar(n) when n > 100 do
    IO.puts "We've got a big number here!"
  end
end

Foo.bar(0)    # => 0
Foo.bar(10)   # => 10
Foo.bar(172)  # => We've got a big number here!
```

This may not be seem like much but it's an amazing feature rather than having to stack you're program full of [guard clauses](http://refactoring.com/catalog/replaceNestedConditionalWithGuardClauses.html), you can have each and every conditionally matched value processed in a different manner. This also cleans up your function by drawing out the guard clauses and as you learn Elixir this works greatly to your advantage when processing values using a recursion based method. (A guard claus is used to prevent your function from building a nest of conditions and creating an ugly mess.)


```ruby
# something similar in Ruby using inline guard functions
class Foo
  def bar(n)
    return 0 if n == 0
    return "We've got a big number here!" if n > 100
    puts n
  end
end

task = Foo.new
task.bar(72)  # => 72
```

### Looping
One thing that completely blows my mind with Elixir is there's no actual build in loops ie: `while, unless, until, for, each, and many others`. If you want to loop through a value, hash, string, or data of some kind it's up to you to to process these using a form of recursion. Other than the occasional exercise involving [FizzBuzz](https://en.wikipedia.org/wiki/Fizz_buzz), [Fibonacci sequence](https://en.wikipedia.org/wiki/Fibonacci_number), or build some sort of state-machine looping through until an event happens, the concept of processing based on recursion may have been more of a theoretical concept that we haven't used much. If you're like me you've enjoyed the spenders of using Object-Oriented code to loop through data. And I'm fully aware that even with ruby our simple loops and blocks are based on conditional recursion build with C.

```elixir
defmodule Foo do
  def bar(0), do: 0
  def bar(n) when n > 0 do
    IO.puts n
    bar(n-1)
  end
end

Foo.bar(10)
# => 10 9 8 7 6 5 4 3 2 1
```

### Immutable Data
Another feature that makes Elixir so appealing to some people is that date is immutable. Who? What? Who? This means unlike numerous object-oriented languages in order to change a variables data it must be assigned. Rather than with ruby that once it's been processed, the processed data is now the new value. You may ask yourself why? Well it's a great safety mechanism to protect and retain your datas original value when processing it. Shown below is are two examples showing the different between immutable and mutable data-types.

```elixir
# Elixir
list = [:a, :b, :c] # => [:a, :b, :c]
List.delete(list, :b) # => [:a, :c]
list  # => [:a, :b, :c]

list = List.delete(list, :b) # => [:a, :c]
list # => [:a, :c]
```

```ruby
# Ruby
a = [:a. :b, :c]  # => [:a, :b, :c]
a.delete(:b)  # => [:a, :c]
a #[:a, :c]
```

### My Opinion

This doesn't even begin to scratch the surface, there are so many great features that are built into Elixir that make it an great language to learn. If you're looking to learn a programming language with the ease of use that ruby has and the performance of a compile language this may be what your looking for. There is a lot to learn and using recursion can get complicated. But if you're like me and you've been part of the ruby block for the last several years this makes you feel like your actually programming again rather than building eloquent code. In my opinion Ruby is great for making easy to read and maintainable code. Elixir on the other hand is great for getting things done the way you want it, you can also create high performance and concurrent applications; which will free up various bottlenecks with memory and processing time. Yes Elixirs code may be quite a bit harder to read and occasionally requires you to resort to using barebones Erlang every now and than, but it's still got a ways to go. Unlike Ruby which has had years to mature, Elixir is still a young language finding it's place in the programming community.

~ This doesn't mean I've given up on using ruby, it's my tool of trade. But it never hurts to see what else is out there and to try new things along the way.
