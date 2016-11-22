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

1. Recursive Data Type
2. Function as an Abstraction
3. Controllable Complexity

---
# 1. Recursive Data Type

- A type for values that may contains other values of the same type.
- Examples: List, Tree
- Reducer is a recursive data type similar to tree
- Function is data

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
# Example

```ruby
b = BinaryTree::EmptyNode.new.
                  includes(3).
                  includes(1).
                  includes(4).
                  includes(2).
                  includes(5)
# => #<BinaryTree::Node:0x007fc8ca848330...>

b.left
# => #<BinaryTree::Node:0x007fc8ca8487b8...>

b.right
# => #<BinaryTree::Node:0x007fc8ca8483d0...>
```

---
# Reducer

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

# 2. Function as an Abstraction

Reducer has only one method `apply`
Instead of creating a class, we can just use function as an abstraction

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
# 3. Controllable Complexity

middleware
function composition
