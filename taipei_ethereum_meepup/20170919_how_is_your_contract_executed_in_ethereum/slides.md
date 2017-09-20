# How is Your Contract Executed in Ethereum?

[@juinc](https://github.com/juinc)

[Video Link](https://www.youtube.com/watch?v=MUoj_tQWK1c&feature=youtu.be)

---
# Outline

- Overview
- **Section 6: Transaction Execution**
- **Section 7: Contract Creation**
- **Section 8: Message Call**
- **Section 9: Execution Model**
- Conclusion

---
# Overview

- What is Blockchain?
**=> Destributed State Machine**
[(See More in My Previous Talk)](https://github.com/juinc/talks/blob/master/coscup/slides.md)

- What is the Difference between **Bitcoin** and **Ethereum**?
**=> 1. State Modeling (UTXO v.s. World State)**
**=> 2. Rewarding Mechanism(Uncle Blocks are Introduced)**
**=> 3. Programmability (Smart Contract)**

- What is **Ethereum Virtual Machine (EVM)**?
**=> A Machine that Performs Instructions from Compiled Bytecode (Smart Contract) which is Stored in World State**

---
# EVM Overview

- **Stack-based Machine**
- **Memory Model: Word-addressed Byte Array, Volatile**
- **Storage Model: Word-addressed Word Array, Non-volatile**
- **Quasi-Turing-Complete Machine, Will Raise Out-Of-Gas(OOS) Exception if the Paid Gas is Insufficient**

---
# Section 6: Transaction Execution
## Overview
![](6_1.png)
There are totally 5 phases of state during transaction execution:
**Initial State =(1)=>**
**Checkpoint State =(2)=>**
**Post-execution Provisional State =(3)=>**
**Pre-final State =(4)=>**
**Final State**
where
(1) substrate gas limit x gas price and increment nonce
(2) process message call or contract creation (will be explained later)
(3) apply refunds and rewards
(4) delete destructed accounts

---
# Section 6: Transaction Execution
## Validation
![](6_0.png)

---
# Section 6: Transaction Execution
## Validation (Cont.)
### Where
![](6_0_1.png)
![](6_0_2.png)

---
# Section 6: Transaction Execution
## (1) Substrate Gas Limit x Gas Price and Increment Nonce
### Initial State => Checkpoint State
![](6_2.png)

---
# Section 6: Transaction Execution
## (2) Process Message Call or Contract Creation
### Checkpoint State => Post-execution Provisional State
![](6_3.png)
### Where
![](6_3_1.png)

***These Functions Will be Explained More in Section 7 & 8**

---
# Section 6: Transaction Execution
## (3) Apply Refunds and Rewards
### Post-execution Provisional State => Pre-final State
![](6_4.png)
### Where
![](6_4_1.png)

---
# Section 6: Transaction Execution
## (4) Delete Destructed Accounts
### Pre-final State => Final State
![](6_5.png)

---
# Section 7: Contract Creation
## Overview
![](7_0.png)
### Where
![](7_0_1.png)

---
# Section 7: Contract Creation
## (1) Create a New Account
![](7_1.png)
![](7_1_1.png)

---
# Section 7: Contract Creation
## (1) Create a New Account (Cont.)
### Where
![](7_1_2.png)
![](7_1_3.png)

---
# Section 7: Contract Creation
## (2) Initialize
![](7_2.png)

***The Function Will be Expalined More in Section 9**

---
# Section 7: Contract Creation
## (3) Determine Final State
![](7_3.png)
### Where
![](7_3_1.png)

---
# Section 8: Message Call
## Overview
![](8_0.png)

---
# Section 8: Message Call
## (1) Transfer Value
![](8_1.png)

---
# Section 8: Message Call
## (2) Execute
![](8_2.png)
### Where r=1, r=2, r=3, r=4 are Precompiled Contracts

---
# Section 8: Message Call
## (3) Determine Final State
![](8_3.png)

---
# Section 9: Execution Model
## Overview
![](9_0.png)

---
# Section 9: Execution Model
## (1) The Execution Function
![](9_1.png)
### Where
![](9_1_1.png)
![](9_1_2.png)

---
# Section 9: Execution Model
## (2) Conditions
![](9_2.png)
![](9_2_1.png)

---
# Section 9: Execution Model
## (3) The Execution Cycle
![](9_3.png)

---
# Section 9: Execution Model
## (3) The Execution Cycle (Cont.)
### Where
![](9_3_1.png)
![](9_3_2.png)

---
# Section 9: Execution Model
## (3) The Execution Cycle (Cont.)
### Where
![](9_3_3.png)

---
# Conclusion

- **Formulas are Concise and Elegant**
- **Focused on the Whole Picture thus Many Details are Skipped**
- **Focused the EVM thus the Consensus Strategy are Skipped**
