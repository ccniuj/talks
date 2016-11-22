require 'pry'

class List
  attr_accessor :head, :tail

  def initialize(elements)
    @head = elements[0]
    @tail = elements[1..-1].any? ? List.new(elements[1..-1]) : nil
  end
end

module BinaryTree
  class Node
    attr_accessor :left, :right, :element

    def empty?
      false
    end

    def initialize(left, right, e)
      @left = left
      @right = right
      @element = e
    end

    def contains?(e)
      if e > @element
        @right.contains?(e)
      elsif e < @element
        @left.contains?(e)
      else
        true
      end
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
    def empty?
      true
    end

    def contains?(e)
      false
    end

    def includes(e)
      Node.new(EmptyNode.new, EmptyNode.new, e)
    end
  end
end

b = BinaryTree::EmptyNode.new.includes(3).includes(1).includes(4).includes(2).includes(5)

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

r_ab = -> (state, action) {
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
  foo: Reducer::Combined.new(ab: Reducer::Native.new(r_ab))
)

state = {
  foo: {
    ab: { a: 0, b: 0 }
  }
}

binding.pry

p "debug"
