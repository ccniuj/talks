<div style="text-align:center">
  <img src="ruby_logo.png" style="margin-right:40px">
  <img src="plus.png" style="position: relative; top:-50px">
  <img src="lambda_logo.png" style="position: relative; top:15px;">
  <h2> Exploring Functional Programming</h2>
  <h5>by rebuilding Redux</h5>
</div>
<br/>
<div style="text-align:right">
  <h6>Juin Chiu <a href="https://github.com/davidjuin0519">@davidjuin0519</a></h6>
  <h6>Backend Engineer, iCook, Polydice. Inc</h6>
</div>

---
## The Goal
**Introduce basic functional programming concepts**
<br/>

## Why Functional Programming?

- Useful
- Elegant
- Abstract
- Mathematical

---
## What is Funcitonal Programming?
**Functions are first-class citizen**

In a nut shell:

| Object-Oriented | Functional |
| -- | -- |
| Iteration | Recursion |
| Mutable | Immutable |
| Design Pattern | Composition |

---
# What is Redux?
**Observable object tree**
with
&nbsp;&nbsp;&nbsp;&nbsp;**single insterface for updating its state**
&nbsp;&nbsp;&nbsp;&nbsp;and
&nbsp;&nbsp;&nbsp;&nbsp;**flexible event handling mechanism**

![](redux.png)

---
## Build an architecture like Redux in 3 steps

<span style="color: red">Step 1</span>: **Object with single insterface for updating its state**
<div style="text-align:center;">
  <img src="step_1.png" style="height: 80px;">
</div>

<span style="color: red">Step 2</span>: **Observable object tree**
<div style="text-align:center">
  <img src="step_2.png" style="height: 180px;">
</div>

<span style="color: red">Step 3</span>: **flexible event handling mechanism**
<div style="text-align:center">
  <img src="step_3.png" style="height: 220px;">
</div>

---
# Actually, I have built it ;)
# [Rubidux](https://github.com/davidjuin0519/rubidux)

---
# 1. Lambda

- Named after **Lambda Calculus**
- Anonymous function
- First-class citizen
  - Can be stored in variables and data structures
  - Can be passed as a parameter to a subroutine
  - Can be returned as the result of a subroutine
- Foundation of higher-order functions
- **Reducer** is a lambda that takes `state` and `action` and then returns new `state`

---
# Exercise

```ruby
# Define a lambda and bind it to variable "add_one"
add_one = -> n { n + 1 }

# Pass "add_one" to higher-order function "map"
[1, 2, 3].map(&add_one) # => [2, 3, 4]

# Define a lambda that returns another lambda
time = -> t { -> n { n*t } }

# Pass "time" to higher-order function "map"
[1, 2, 3].map(&time.(3)) # => [3, 6, 9]
```

---
# Example

```ruby
reducer = -> (state, action) {
  state ||= { a: 0, b: 0 }
  case action[:type]
  when "a_plus_one"
    { a: state[:a] + 1, b: state[:b] }
  when "b_plus_one"
    { a: state[:a], b: state[:b] + 1 }
  else
    state
  end
}
```

---
# 2. Recursive Data Type

- A type for values that may contain other values of the same type
- Example: **Tree**
- Need to build a more complicated data structure of Reducer
- **Reducer** can be thought of as a recursive data type like **Tree**

# ![](tree.png)

---
```ruby
module BinaryTree
  class Node
    attr_accessor :left, :right, :element
    def initialize(left, right, e)
      @left = left
      @right = right
      @element = e
    end
    def includes(e)
      if e > @element
        Node.new(@left, @right.includes(e), @element)
      elsif e < @element
        Node.new(@left.includes(e), @right, @element)
      else
        self
      end
    end
  end
  class EmptyNode
    def includes(e)
      Node.new(EmptyNode.new, EmptyNode.new, e)
    end
  end
end
```

---
# Exercise

```ruby
b = BinaryTree::EmptyNode.new.
                  includes(3).
                  includes(1).
                  includes(5).
                  includes(2).
                  includes(4).
                  includes(6)
# => #<BinaryTree::Node:0x007fc8ca848330...>

b.left
# => #<BinaryTree::Node:0x007fc8ca8487b8...>

b.right
# => #<BinaryTree::Node:0x007fc8ca8483d0...>
```

---
# Example

```ruby
module Reducer
  class Combined
    attr_accessor :func_map
    def initialize(**func_map)
      @func_map = func_map
    end
    def apply(state, action)
      func_map.map { |k, v| [k, v.apply(state[k], action)] }.to_h
    end
  end
  class Native
    attr_accessor :func
    def initialize(func)
      @func = func
    end
    def apply(state, action)
      func.(state, action)
    end
  end
end
```

---
# Example

```ruby
ab = -> (state, action) {
  case action[:type]
  when "a_plus_one"
    { a: state[:a]+1, b: state[:b] }
  when "b_plus_one"
    { a: state[:a], b: state[:b]+1 }
  else
    state
  end
}

r = Reducer::Combined.new(
  foo: Reducer::Combined.new(ab: Reducer::Native.new(ab))
)
s = { foo: { ab: { a: 0, b: 0 } } }
a = { type: 'a_plus_one' }

r.apply(s, a)
# => {:foo=>{:ab=>{:a=>1, :b=>0}}}
```

---
# Simplified Version

1. Assume no other operations like `includes`
2. Use `Hash` to represent the tree structure
3. No distinction between `Node` and `EmptyNode`

```ruby
def merge(left, right, element)
  {
    left: left,
    right: right,
    element: element
  }
end

t1 = { left: nil, right: nil, element: 1 }
t2 = { left: nil, right: nil, element: 2 }

t = merge(t1, t2, 3)
# { :left    => { :left=>nil, :right=>nil, :element=>1 },
#   :right   => { :left=>nil, :right=>nil, :element=>2 },
#   :element => 3 }
```

---
# Simplified Version

Equivalent implementation of `combineReducer`:

```ruby
def combine
  -> **reducers {
    -> (state, action) {
      state ||= {}
      reducers.
        map { |key, reducer|
          [key, reducer.(state[key], action)] }.
        to_h
    }
  }
end
```

---
# 3. Function Composition

- Apply one function to the result of another function to produce a third function
- Control complexity by breaking larger function into smaller functions
- **Middleware** is built on function composition

---
# Exercise
```ruby
add_one  = -> n { n + 1 }
time_two = -> n { n * 2 }

[1, 2, 3].map { |n| time_two.(add_one.(n)) }
# => [4, 6, 8]
```
Question: Any more concise way to do this?

---
# Exercise
```ruby
add_one  = -> n { n + 1 }
time_two = -> n { n * 2 }

compose = -> f { -> g { -> n { g.(f.(n)) } } }

func = compose.(add_one).(time_two)

[1, 2, 3].map(&func)
# => [4, 6, 8]
```
Looks good, but what if we have more than two functions to compose?

---
# Exercise
```ruby
add_one  = -> f { -> n { f.(n+1) } }
time_two = -> f { -> n { f.(n*2) } }

compose  = -> funcs {
  init = -> n { n }
  funcs.reverse.reduce(init) { |acc, curr| curr.(acc) }
}

func = compose.([add_one, time_two])

[1, 2, 3].map(&func) # => [4, 6, 8]
```
We can compose arbitrary numbers of functions as long as they have the same structure.

---
# Example
```ruby
def create
  -> fn {
    -> **middleware_api {
      -> _next {
        -> action {
          fn.(_next, action, **middleware_api)
        }
      }
    }
  }
end
```

---
# Example
```ruby
def compose
  -> *funcs {
    if funcs.size == 1
      funcs[0]
    else
      -> init {
        funcs.
          reverse.
          reduce(init) { |composed, f| f.(composed) }
      }
    end
  }
end
```

---
# Example
```ruby
def apply
  -> *middlewares {
    -> (get_state, dispatch) {
      middleware_api = {
        get_state: get_state,
        dispatch: -> action { new_dispatch.(action) }
      }
      chain = middlewares.map { |middleware|
                middleware.(middleware_api) }
      new_dispatch = compose.(*chain).(dispatch)
    }
  }
end
```

---
# Example
```ruby
m1 = create.(
  -> (_next, action, **middleware_api) {
    puts "In middleware 1"
    _next.(action)
    puts "Out middleware 1"
  }
)

m2 = create.(
  -> (_next, action, **middleware_api) {
    puts "In middleware 2"
    _next.(action)
    puts "Out middleware 2"
  }
)

apply.(m1, m2).(STATE, DISPATCH).(ACTION)
# => "In middleware 1"
# => "In middleware 2"
# => "Out middleware 2"
# => "Out middleware 1"
```

---
# Summary

### What I have covered
Some concepts in Functional Programming such as:

- Lambda
- Recursive Data Type
- Composition

### What I havn't covered

- Immutable
- Lazy Evaluation
- Monad

---
# Thanks for your listening ;)