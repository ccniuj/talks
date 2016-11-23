require 'pry'

def include
  -> (tree, element) {
    -> {
      if element > tree[:element]
        include.(right, element)
      elsif element < tree[:element]

      else
        tree
      end
          
      {
        left: left.(),
        right: right.(),
        element: element
      }
    }
  }
end

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

add_one = -> f { -> n { f.(n+1) } }
time_two = -> f { -> n { f.(n*2) } }

compose = -> funcs {
  last = funcs[-1]
  rest = funcs[0..-2].reverse
  init = -> n { n }
  funcs.reverse.reduce(init) { |acc, curr| curr.(acc) }
}

func = compose.([add_one, time_two])

binding.pry

p "debug"
