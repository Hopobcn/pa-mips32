# README #

This project is a custom MIPS32 processor implemented for the subject Processor Architecture of the master MIRI.
We recommend using Altera Suite (Quartus+Modelsim) as a development tools.

### What is the archive structure: ###
 
This project has been developed with an iterative way, so each step is made of two folders:
* #index_step.NAME_STEP
* #index_step.NAME_STEP-test
for example:
* 0.BasicMIPS
* 0.BasicMIPS-test

### What are the steps called? ###
We are going to try to implement this features:

* 0.BasicMIPS : A MIPS32 processor without pipelining. It's not needed for the project but it's important as we want to start from a correct implementation.
* 1.PipelinedMIPS: A pipelined version of the last implementation. It will include forwarding-paths, hazard detectors, (basic)exceptions and interrupts.
      Order of importance: Interrupts > Exception (overflow, parity) 
* 2.CatchedMIPS: Extend our 5 stage pipeline to support cache hierachy plus a realistic store pipeline and support for virtual memory.
      Order of importance: Data Cach > Instruction Cach

--------------------------------In this point, ask the professor for advice:
* 3.PredictorMIPS: Implement Branch prediction
* 4.MulticycleMIPS: Implement a long-cycle instruction (floating point?). A new register file and LD/ST for FP.. With Reorder Buffer or History File or Renaming...

-------------------------------- The scope of the project is until here.
* 5.OutoforderMIPS: 

Others: 
* A program/script that computes the CPI of a small code in each iteration of our implementations.

### How do I get set up? ###

* Pending..

### Who do I talk to? ###

* Pau Farré 
* Alex Barcelo