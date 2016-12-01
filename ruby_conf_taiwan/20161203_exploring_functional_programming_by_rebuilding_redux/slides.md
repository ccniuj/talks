<div style="text-align:center">
  <img src="ruby_logo.png" style="width: 150px; margin-right:40px" />
  <img src="plus.png" style="position: relative; top:-40px" />
  <img src="redux_logo.png" style="width: 150px; margin-left: 40px;" />
  <h3>Exploring Functional Programming by Rebuilding Redux</h3>
  <h6>Ruby + Redux = Rubidux</h6>
</div>
<br/>
<div style="text-align:right">
  <h6>Juin Chiu <a href="https://github.com/davidjuin0519">@davidjuin0519</a></h6>
  <h6>Backend Engineer, iCook, Polydice. Inc</h6>
</div>

---
## What is Functional Programming?
Compared to **imperative programming**:
- It is **declarative**: it describes **what you want** rather than **how you do it**
- Functions are first-class citizen
- Functions do recursion to repeat computation
- Functions are pure

---
## Why Functional Programming?

- Immutability is amazingly good for high concurrency application
- Pure functions are easy to test
- Complexity of program design can be controlled by the use of function composition

---
## What is Redux? Why Redux?
**Observable object tree** with **single interface for  state updating** and **flexible event handling mechanism**
<br />
<div style="text-align:center;">
  <img src="step_3.png" style="width: 700px;" />
</div>

---
## Implement a Redux Architecture in 3 steps

<span style="color: red">Step 1</span>: **Object with single interface for state updating**
<div style="text-align:center;">
  <img src="step_1.png" style="height: 80px;" />
</div>

<span style="color: red">Step 2</span>: **Observable object tree**
<div style="text-align:center">
  <img src="step_2_2.png" style="height: 180px;" />
</div>

<span style="color: red">Step 3</span>: **Flexible event handling mechanism**
<div style="text-align:center">
  <img src="step_3.png" style="height: 220px;" />
</div>

---
# See [Rubidux](https://github.com/davidjuin0519/rubidux) for more details
<div style="text-align:center">
  <img src="rubidux.png" style="border: 1px solid;" />
</div>

---
<div style="text-align:center;">
  <h3>Step 1: Object with Single Interface for State Updating</h3>
  <br/>
  <img src="step_1.png" style="width: 600px;" />
  <br/>
  <h3>Reducer is a <span style="color: red">Lambda</span></h3>
</div>

---
# Lambda

- Named after **Lambda Calculus**
- Anonymous function
- First-class citizen
  - Can be stored in variables and data structures
  - Can be passed as a parameter to a subroutine
  - Can be returned as the result of a subroutine
- Foundation of higher-order functions

---
# Example

```ruby
add_one = -> n { n + 1 }

add_one.(1) # => 2

[1, 2, 3].map(&add_one) # => [2, 3, 4]


time = -> t { -> n { n*t } }

time.(3) # => #<Proc:...>

[1, 2, 3].map(&time.(3)) # => [3, 6, 9]
```

---
# Implementation

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

# Usage

s = { a: 0, b: 0 }
a = { type: "a_plus_one" }

reducer.(s, a)
# => { a: 1, b: 0 }
```

---
<div style="text-align:center">
  <h3>Step 2-1: Object Tree</h3>
  <br />
  <img src="step_2_1.png" style="width: 800px;" />
  <br />
  <h3>Reducer tree is a <span style="color: red">Recursive Data Type</span></h3>
</div>

---
# Recursive Data Type

- A type for values that may contain other values of the same type
- Example: **Tree**

<br />
<div style="text-align:center">
  <img src="tree.png" style="width: 350px;" />
</div>

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
# Implementation

```ruby
module Reducer
  class Combined
    attr_accessor :func_map
    def initialize(**func_map)
      @func_map = func_map
    end
    def apply(state, action)
      func_map.map { |k, v| [k, v.apply(state[k], action)] }
              .to_h
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
# Simplified Version of Tree

No need for manipulating the data
=> No distinction between `Node` and `EmptyNode`
=> Use `Hash` to represent the tree structure

```ruby
def merge
  -> (left, right, element) {
    {
      left: left,
      right: right,
      element: element
    }
  }
end

t1 = { left: nil, right: nil, element: 1 }
t2 = { left: nil, right: nil, element: 2 }
t = merge.(t1, t2, 3)
# { :left    => { :left=>nil, :right=>nil, :element=>1 },
#   :right   => { :left=>nil, :right=>nil, :element=>2 },
#   :element => 3 }
```

---
# Simplified Implementation

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
```ruby
# Usage

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

reducer = combine.(
            foo: combine.(
              ad: ab
            )
          )
s = { foo: { ab: { a: 0, b: 0 } } }
a = { type: 'a_plus_one' }
reducer.(s, a) # => {:foo=>{:ab=>{:a=>1, :b=>0}}}
```

---
<div style="text-align:center">
  <h3>Step 2-2: Observable Object Tree</h3>
  <br />
  <img src="step_2_2.png" style="width: 900px;" />
  <br />
</div>
  <h5>1. Wrap the reducer tree in <span style="color: red">Store</span> to maintain the state</h5>
  <h5>2. Expose a function <span style="color: red">Dispatch</span> to update the state</h5>
  <h5>3. Expose a function <span style="color: red">Subscribe</span> to define callback of state update</h5>

---
<div style="text-align:center">
  <h3>Step 3: Flexible Event Handling Mechanism</h3>
  <br />
  <img src="step_3.png" style="width: 900px;" />
  <h3>Construct middlewares by <span style="color: red">Composition</span></h3>
</div>

---
# Composition

- `h(x) = f(g(x))`
- Apply one function to the result of another function to produce a third function
- Control complexity by breaking larger function into smaller functions

---
# Example 1
```ruby
add_one  = -> n { n + 1 }
time_two = -> n { n * 2 }

composed = -> n { time_two.(add_one.(n)) }

[1, 2, 3].map(&composed)
# => [4, 6, 8]
```
What if we have more than two functions to compose?

---
# Example 2
```ruby
add_one  = -> n { n + 1 }
time_two = -> n { n * 2 }
add_four = -> n { n + 4 }

compose  = -> f { -> g { -> n { g.(f.(n)) } } }

init     = -> n { n }
composed = init
[add_one, time_two, add_four].each do |f|
  composed = compose.(composed).(f)
end

[1, 2, 3].map(&composed)
# => [8, 10, 12]
```
The value of `composed` is mutated. Is there any more concise way?

---
# Example 3
```ruby
add_one  = -> f { -> n { f.(n+1) } }
time_two = -> f { -> n { f.(n*2) } }
add_four = -> f { -> n { f.(n+4) } }

compose  = -> funcs {
  init = -> n { n }
  funcs.reverse.reduce(init) {|result, f| f.(result)}
}

composed = compose.([add_one, time_two, add_four])

[1, 2, 3].map(&composed) # => [8, 10, 12]
```

---
# Implementation
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

# Similar to example 3

# add_one  = -> f { -> n { f.(n+1) } }
# time_two = -> f { -> n { f.(n*2) } }
# add_four = -> f { -> n { f.(n+4) } }
```

---
# Implementation
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

# Similar to example 3

# compose  = -> funcs {
#   init = -> n { n }
#   funcs.reverse.reduce(init) { |result, f| f.(result) }
# }
```

---
# Implementation
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

# Similar to example 3

# func = compose.([add_one, time_two])
```

---
```ruby
# Usage

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

new_dispatch = apply.(m1, m2).(STATE, DISPATCH)
new_dispatch.(ACTION)
# => "In middleware 1"
# => "In middleware 2"
# update state
# => "Out middleware 2"
# => "Out middleware 1"
```

---
# How to use it?

---
# Summary

### What I have covered
Some concepts in Functional Programming such as:

- Lambda
- Recursive data type
- Composition

### What I havn't covered

- Immutable
- Lazy evaluation
- Monad
- ...

---
# Thanks for your listening!