# Cycle 1: AC circuits

This is the project for the first cycle, which aims
to study the behaviour of alternated current circuits
using numerical methods implemented in Julia.

The project consists of simulating a RLC circuit with
a square-wave source and analyze the behaviour of the system.

## Modules
The documentation for each module is inside the respective module:
- IVPUtils: responsible for implementing the solver and numerical methods to solve the initial value problem (IVP). This module is used by main.
- main: responsible for implementing the main logic of the program and declaring the actual values with abstractions. Uses IVPUtils and RLCUtils.
- RLCUtils: responsible for implementing utilities to model the RLC circuit mathematically. This module is used by main.

## How to run

On your terminal, run:
```bash
julia main.jl
```