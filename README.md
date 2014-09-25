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
* 1.PipelinedMIPS: A pipelined version of the last implementation. It will include forward-paths, hazard detectors, (basic)exceptions and interrupts. (branch predictor if we are going ok of time)
* 2.AdvancedMIPS: Extend our 5 stage pipeline to support cache hierachy plus a realistic store pipeline and support for virtual memory.

--------------------------------Until here is the target for the project if we are going ahead of schedule we will implement this other features:

* 3.MulticycleMIPS: Implement new instructions for adding floating point capabilities to our processor. A new register file and LD/ST for FP + fix broken things.
* 4.PredictorMIPS: Implement a complete Branch predictor...
* 5.OutoforderMIPS: 

### How do I get set up? ###

* Pending..

### Who do I talk to? ###

* Pau Farré 
* Alex Barcelo