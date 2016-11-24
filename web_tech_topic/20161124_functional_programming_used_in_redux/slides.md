Functional Programming Used in Redux
===
# ![](redux_logo.png)

###### Juin Chiu
###### Backend Engineer, iCook, Polydice. Inc

---
# About Me
#### Juin Chiu [@davidjuin0519](https://github.com/davidjuin0519)
**Language**:
- Ruby
- Javascript
- Scala

**Interested In**:
- Functional Programming
- Data Engineering
- Machine Learning

**Talks**:
**Exploring Functional Programming by Rebuilding Redux**
[@Ruby Conf Taiwan 2016](https://2016.rubyconf.tw)

---
# Outline

1. Lambda
2. Recursive Data Type
3. Function Composition

p.s.
- This talk might be a little bit hard if you havn't used Redux
- Examples are written in Ruby

---
# Redux
# ![](redux.png)

---
# 1. Lambda

- Named after **Lambda Calculus**
- Anonymous function
- First-class citizen
  - Can be stored in variables and data structures
  - Can be passed as a parameter to a subroutine
  - Can be returned as the result of a subroutine
- Foundation of Higher-order functions
- **Reducer** is a lambda that takes `state` and `action` and returns new `state`
# ![](reducer.png)

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

- A type for values that may contains other values of the same type.
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
t2 = { left: nil, right: nil, element: 3 }

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

- Apply One function to the result of another function to produce a third function
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
Any more concise way to do this?

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
Looks good.
But what if we have more than two functions to compose?

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
We can add arbitrary numbers of function to compose as long as these functions has the same structure

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

*Read my [posts](https://github.com/davidjuin0519/til/issues?utf8=%E2%9C%93&q=label%3ARedux%20) or attend [Ruby Conf Taiwan 2016](http://rubytaiwan.kktix.cc/events/rubyconftw2016) ;)