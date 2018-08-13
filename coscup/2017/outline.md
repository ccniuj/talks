# Let's make a blockchain

## Purpose
- Decentralization
- The next generation web (value network)
- Secure

## Concepts
- Distributed Infinite State machine
- Consensus
- Crytography

## Motivation
- State machine is useful for value transferring
- This is how banking system works
- Decentralization means no central governance
- Why is POW necessary? To solve Byzantine Generals Problem
- Why is concensus necessary? For consistency of a decentralized system
- Concensus algorithm is part of the blockchain protocol
- Why is crytography necessary? To digitalize physical assets

## My work
- A blockchain protocol
- Develop a module: `simblock` (short for `simple block`)
- Explore the essence
- pyethereum

## Roadmap
- Transaction
- Block
- Mining
- Networking

Block is the basic unit
Transaction defines transition

From a user's perspective
From client api

Value transterring is the simplist case
Alice can send 1 sim to Bob
tx => distribute => block => mining => chain
cryptography => networking => ... => consensus => state transition


## Resources
[Decentralized Objective Consensus without Proof-of-Work](https://hackernoon.com/decentralized-objective-consensus-without-proof-of-work-a983a0489f0a)
[Blockchain: the Infinite State Machine](https://medium.com/@samuel.brooks/blockchain-the-infinite-state-machine-ffc39f32e182)
[How the Byzantine General Sacked the Castle: A Look Into Blockchain](https://medium.com/@DebrajG/how-the-byzantine-general-sacked-the-castle-a-look-into-blockchain-370fe637502c)

## Reference
[pycoin](https://github.com/richardkiss/pycoin)
[pybitcointool](https://github.com/vbuterin/pybitcointools)
[pyethereum](https://github.com/ethereum/pyethereum)
