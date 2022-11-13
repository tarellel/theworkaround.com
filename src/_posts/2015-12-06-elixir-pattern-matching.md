---
layout: post
title: "Elixir Pattern Matching"
date: 2015-12-06 15-12-34
description: "A brief look at Elixirs Pattern matching and the power the equal sign operator."
tags: [development, elixir, programming]
comments: true
---
## Special Characters have meaning as well

Learning any new programming language is a always a great challenge. There's always new techniques, methods, and syntax to learn. But it is also a great experience to expand you knowledge and learn new tricks and with Elixir this is also the case. As with many programming languages there are numerous keywords and special characters that have meaning. They can assign a value, perform some sort of logic test, run a method, etc. And in this article we will taking a brief look at Elixir based Pattern Matching.

### Pattern matching

In numerous programming languages the equal symbol `=` is generally an assignment operator. Which means you set XYZ variable to the value of JKL `xyz = 'FooBar'`. You can usually assign an object, a value, a function, or many other datatypes to a variable. With Elixir this is still the case, but with exceptions. In Elixir, the equals operator means to match the left side of the `=` sign to the the right side.


```elixir
iex> x = 7
# => 7
iex> y = 5
# => 5
iex> 7 = y
# => ** (MatchError) no match of right hand side value: 5
```

You may be wondering what this error is about. Well the variable `y` was assigned the value of 5, meaning that in the last line you are stating that 7 = 5. This value should always be false. Now if the variable was on the left side of the equal sign the value of 7 would have been assigned the variable.

### Taking it a step farther
Once you begin using pattern matching, it can become a very powerful feature in you application. Not only can you do pattern matching with basic variables and datatypes, you can also match values with tuples and lists. This can be a double edged sword, it can either complicate the heck out of your program or make things work extremely effectively. Pattern matching assignment is a great tool when working with tuples/lists, because it allows us to pick which values we wish to assign and use.


```elixir
costanza = %{name: "George", age: 27, likes: "Sports"}
# => %{age: 27, likes: "Sports", name: "George"}

# lets verify name is an unassigned variable
name
# => ** (CompileError) iex:2: undefined function name/0

%{name: name} = costanza
# => %{age: 27, likes: "Sports", name: "George"}

name
# => "George"
```

Lets put this in prospective of an HTTP request/response, to assign

```elixir
{result, value} = {:error, 404}
# => {:error, 404}

result
# => :error
```

Now rather than assigning values, lets look at an example of pattern matching based on conditional comparisons.

```elixir
{:ok, reponse} = {:error, 404}
# => ** (MatchError) no match of right hand side value: {:error, 404}

{:status, reponse} = {:status, 200}
# => {:status, 200}

{200, response} = {200, "html/text;"}
# => {200, "html/text;"}
```
In the first example you can see the left hand and right hand of the `=` operator are not equal and do not having matching :atoms so they can not be assigned values to their corresponding variables. But the second example does have matching atoms/object so their values can be associated with one another. By using this pattern matching techniques, you are not solely limited to using :atoms to match the values, you can use various data types. If you look at the third example you can see that they correspond with each other with an integer that has the value of `200`. This may look like a mess, why would you want to do this? Well the sample below might shine some like on this. With pattern matching you could assign the values based on a functions response values, using a simple HTTP request I will try to show you that it isn't so hard to understand how and why these values may be passed.

```elixir
defmodule Http do
  def request do
    # ...
    {:status, 404}
  end
end

{:status, response} = Http.request()
# => {:status, 404}

response
# => 404
```



### Functional Pattern Matching

When declaring and calling functions you can continue to do pattern matching based on the declared values without using the equals `=` assignment operator. Generally function pattern matching is used for with making recursion effective and manageable.

```elixir
defmodule Seinfield do
  def cast([], _), do: [] # STOP: when end of list has been reached

  def cast(list), do: cast(list, 1) # start index from 1 when beginning to map through the list
  def cast([head | tail], count) do
    IO.puts "#{count}: #{head}"
    cast(tail, (count+1))
  end
end

characters = ["George","Jerry","Kramer","Elaine","Newman"]
# => ["George", "Jerry", "Kramer", "Elaine", "Newman"]

Seinfield.cast(characters)

# => George
# Jerry
# Kramer
# Elaine
# Newman
```

I know this is an extreme example jumping from basic variable declarations to module/function matching. But if you look at the cast function, you'll notice that when passing parameters using a list Elixir will match to the lists `[head |tail]` to make break down in forms of context here is what it would look like with the characters list passed through it.

```elixir
[head | tail]
["George" | "Jerry","Kramer","Elaine","Newman"]
```


### Clearing it up
I hope you have better understanding of Elixirs pattern matching capabilities and that the equal sign is not just an assignment operator in Elixir. Elixir has a massive amount of capabilities and some of these may be confusing as hell, but pattern matching helps bring it one step closer to help make everything easier to understand and use.
