require "rubidux"
require "pry"

# Reducers
R_AB = -> (state, action) {
  case action[:type]
  when :INITIALIZE
    { a: 0, b: 0 }
  when :A_PLUS_ONE
    { a: state[:a]+1, b: state[:b] }
  when :B_PLUS_ONE
    { a: state[:a], b: state[:b]+1 }
  else
    state
  end
}

R_CD = -> (state, action) {
  case action[:type]
  when :INITIALIZE
    { c: 0, d: 0 }
  when :C_PLUS_ONE
    { c: state[:c]+1, d: state[:d] }
  when :D_PLUS_ONE
    { c: state[:c], d: state[:d]+1 }
  else
    state
  end
}

R_EF = -> (state, action) {
  case action[:type]
  when :INITIALIZE
    { e: 0, f: 0 }
  when :E_PLUS_ONE
    { e: state[:e]+1, f: state[:f] }
  when :F_PLUS_ONE
    { e: state[:e], f: state[:f]+1 }
  else
    state
  end
}

R_GH = -> (state, action) {
  case action[:type]
  when :INITIALIZE
    { g: 0, h: 0 }
  when :G_PLUS_ONE
    { g: state[:g]+1, h: state[:h] }
  when :H_PLUS_ONE
    { g: state[:g], h: state[:h]+1 }
  else
    state
  end
}

# Combine
foo = Rubidux::Reducer.combine.(ab: R_AB, cd: R_CD)
bar = Rubidux::Reducer.combine.(ef: R_EF, gh: R_GH)
r = Rubidux::Reducer.combine.(foo: foo, bar: bar)

# Middlewares
m1 = Rubidux::Middleware.create.(
  -> (_next, action, **middleware_api) {
    p "In middleware 1"
    result = _next.(action)
    p "Out middleware 1"
    result
  }
)

m2 = Rubidux::Middleware.create.(
  -> (_next, action, **middleware_api) {
    p "In middleware 2"
    result = _next.(action)
    p "Out middleware 2"
    result
  }
)

e = Rubidux::Middleware.apply.(m1, m2)

# Store
store = Rubidux::Store.new(reducer: r, enhancer: e)
store.subscribe.(-> { p "I am called!" })
store.subscribe.(-> { p "I am called 2!" })

binding.pry

p "foo"
