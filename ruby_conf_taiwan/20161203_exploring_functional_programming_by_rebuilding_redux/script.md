# Exploring Functional Programming by Rebuilding Redux

Good afternoon! My name is Juin, a backend engineer from iCook. Today I will give a talk about functional programming. Perhaps Some of you have used functional programming or have heard of it. There are many reources to get started learning functional programming, but I think the best way to learn it is to use it to build something. So today I would like to demonstrate how to build an architecture like Redux step by step, and meanwhile introduce the related concepts.

---
## What is Functional Programming?

So what is functional programming in a nutshell? It is a programing paradigm, which is a way of organizing programs. It's different from what we have knew, being imperative programming. Ruby is an imperative language; however it has some features to let us do functional programming. Here I just list some of the features. 

First, functions are first-class citizen. This means that function can be defined, passed as arguments, returned as result of other function.

Secondly, functions do recursion to repeat computations. This is different from what we are familiar with since we use `each` and `while` to do the daily job. Recursion can also be used to define data types, called recursive data types.

Thirdly, functions are pure. Pure means no side effects. A pure function will always return the same output for same input. Again, this is different from what we do in our daily job. Ruby is designed to be an OO language, and OO design means to mutate the state of an object, and thus the output of the OO method depends on its internal state. This behavior is different from functinoal prorgramming design, where data is usually immutable.

---
## Why Functional Programming?

Functional programming exists for more than 50 years. Why does everybody talk about it since recently? Well, there are few reasons. 

Perhaps the most important reason is that Immutability is amazingly good for high concurrency application, since immutability garantees the consistency of the data no matter how many times it is accessed. 

Besides immutability, pure functions are easy to test since it always returns the same output everytime.

It is always hard to build large and complex software. In OO, we need to understand the design pattern to deal with the complexity of design. In functional programming, function composition is the way to control the complexity, but more flexible than design patterns.

---
## What is Redux? Why Redux?

Redux is a popular javascript framework in react stack of front-end development. It is used to manage the state for all react components. At my point of view, i think Redux is essentially an **observable object tree** with **single interface for  state updating** and **flexible event handling mechanism**.

I have used Redux and I was facinated by its subtlety and usability. Most importantly, these are achieved by the use of funcitonal programming. That is why I choose Redux to rebuild.

---
## Implement a Redux Architecture in 3 steps
We are going to implement a Redux Architecture in 3 steps.

We will start from the simplest thing: a reducer. Reducer is the building block of Redux. It takes an state and an action and returns a new state. It defines how the object should update its state.

Then, In order to express more complicated structure of state, We will develop a way to organize multiple reducers to construct a single, new reducer. From the outside, the new reducer looks just like the one defined in step 1. Additionally, We will find a way to store the state and expose the interface to update the state.

Finally, we will make what is built in step 2 more capable of dealing with different kinds of actions other than just updating state.

---
## See Rubidux for more details

One last thing before we start. What I am going to do is all open-sourced. You can just check it out. It is called Rubidux. You can read its spec to see its functionality or jsut browse the source code to see what is happening under the hood.

---
## Step 1: Object with Single Interface for State Updating

So let's begin. The building block of Redux is reducer. What is reducer? It is a function, clearly. Furthermore, it is not just a function, it must be able to be passed as an argument. It is a **Lambda**.

---
## Lambda

So here comes the first functional programming concept: Lambda. The name Lambda is from lambda calculus. It is essentially an anonymous function. Lambda is first-class citizen, which means it can be defined anywhere, can be passed as a parameter, and can be returned as a result. Lambda is the foundation of higher-order functions.

---
## Example

Here are few examples of Ruby lambda. To define a lambda, use the rightward arrow followed by arguments and a code block. To call it , just use a dot. We can assign this lambda to a variable. And we can pass this variable to other functions. Furthermmore, a lambda can return another lambda. This is called higher-order function.

---
## Implementation

The implementation of reducer is easy. It is nothing but a lambda. A reducer defines how to renew the state depending on the action type. So it has switch case to decide what to do. Given a state and a action with the key "type", a reducer has to always return the same output. it must be pure.

---
## Step 2-1: Object Tree

Now we have the building block. Reducer itself is not jsut a function, it is also the data. It won't be useful if we can't build more complicated data structure. In this step, we will to develop a way to organize multiple reducers to create a new reducer. It will look just like a tree. It is a recursive data type.

---
## Recursive Data Type

A recursive data type refers to a type for values that may contain other values of the same type. For example, a binary tree has children which itself is also a binary tree.

---
## Example

Here is an way to implement the binary tree. There are two types of node, either node or emptynode. What I want to show is here is the similarity between a tree and a reducer.

---
## Implementation

Here is an way to implement reducer. This is close to what I have showed in the last slide. It also has two types: native and combined. However, this implementation can be simplified. Let me show you how.

---
## Simplified Version of Tree

Let's rethink about the tree. How could that implementation be simplified? If we just want to express the hierarchey of the data, than we don't need methods for manipulating the data. This imples that the distinction beteen node and emptynode is not necessary. As a result, hash is already sufficient to express the data hierarchey. We just need to implement a function to merge multiple trees to a single tree, which is nothing but a hash.

---
## Simplfied Impementation

Same idea applies to reducer, too. The function combine will merge mutiple reducers into one single reducer. If we call this new reducer, the returned state will have the structure correspondng to the way we organize reducers.

---
## Step 2-2: Observable Object Tree

Reducers are pure functions. It means they are stateless. In order to store the new state whenever the action is applied, we need to design a wrapper that stores the state. So we call this wrapper a store. Addtionally, the store exposes its interface for calling reducer. The interface is called dispatch. Instead of passing action and the state to reducer, we can just call dispatch with the action. Dispatch will automatically pass the action and current stored state for you.

Store also has a interface called subscribe which is used for subscribing functions that are going to be called after the state is updated. This makes the object is observable.

---
## Step 3: Flexible Event Handling Mechanism

Finally, we are going to enhance the ability of the Store to make it capable of dealing all kinds of actions. The store now can only handle actions with certain payload. What if we need to get the data from somewhere asynchrounously? This asynchrounous operation cannot be perfromed in reducer since reducer has to be pure. Thus we need to design a mechanism to handle this kind of action. In Redux, it is called middleware. Conceptually, it is similar to rails middleware. Middleware is built on function composition.

---
## Composition

Composition means apply one function to the result of another function to produce a third function. You probably feel more familiar with the mathematical definition. By the use of composition, simple functions can form more complicated functions. On the other hand, complex function can be split into simpler functions. This is extremely useful for program design.

---
## Example 1

Here we have two functions. They can be composed to another function. This is good. But what if we have more than two functions to compose? Of course we don't want to do it for every number of functions.

---
## Example 2

Instead, we can abstract the compose logic and make it reusable. To compose a collection of functions, we can iterate each of them and apply `compose` function until every funciton is applied. But there is a problem. The way we approach this problem is not pure because we continuously mutate the value of `composed`. Can we do it more concisely?

---
## Exercise 3

Yes. We can do it more concisely and now things start to look like functional programming. Here we use one of the Ruby's magic: the `reduce` method. What `reduce` does is to take an initial input as the first result, then it traverses the collection and recursively compute the new result based on the operation defined in the block. There are two parameters in the block: the computed result and the current traversed element from the collection.

In this way, the composition can be done if we wrap the functions to be composed with an extra parameter `f`, where `f` is the result of previous composed function. The `reduce` should be performed reversely to meet the order of the collection.

So, I just showed you the essence of function composition. This is exactly how Redux implements middleware and I think this is really elegant and concise.

---
## Implementation

Middlewares are the functions to be composed. Let's see things under the hood. Here is how we create a middleware. `_next` is essentially the `f` in previous example. In each middleware, we can design what to do depending on the action.

---
## Implementation

The way we compose middlewares are exactly the same thing. The `init` is the original dispatch function.

---
## Implementation

We can use `apply` to actually compose the middlewares. The composed function is the new version of dispatch. It is enhanced and has the ability handle different actions due to the power of middlewares.

---
## Example

Here is a quick example of applying middlewares. It will create a new dispatch with middlewares. If we call this dispatch, it goes through first m1, and then m2, update the state, and then exit m2, finally exit m1. Middlewares are like boxes.

---
## How to use it?

Live demo

---
## Summary

Today I have covered some basic but important concepts like lamnda, recurive data type, and composition. But there are still some advanced but interesting topics such as lazy evaluation and monad. I hope this talk will inspire some of you, perhaps contribute to Rubidux together.

This is the end of my talk. Thanks for your listening.