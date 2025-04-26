# Lab 4 - MIPS Pipeline Processor

## Objective

The goal of this lab was to build a five-stage pipelined MIPS processor, implementing the standard stages of instruction execution:
- Instruction Fetch (IF)
- Instruction Decode (ID)
- Execution (EX)
- Memory Access (MEM)
- Write Back (WB)

Each stage functions independently with data passed between them via pipeline registers. This lab focused on integrating modules such as the control unit, ALU, register file, and memory to build a working pipelined processor capable of executing MIPS instructions.

## Procedure

### Key Files Modified
- **IF_pipe_stage.v**  
  Handles PC updates, instruction fetch, and jump/branch logic using muxes.

- **EX_pipe_stage.v**  
  Executes ALU operations and handles data hazard resolution through forwarding.

- **EX_Forwarding_unit.v**  
  Controls forwarding logic by analyzing dependencies between EX, MEM, and WB stages.

- **mips_32.v**  
  Top-level module that connects all pipeline stages and manages overall instruction flow.

## Simulation Results

### Basic Functionality
Initial instructions perform as expected based on waveform analysis, confirming the system functions correctly.

### Data Hazards
Pipeline stalls were observed when a `lw` is followed by a dependent instruction. Waveforms show the stall behavior and register update delay.

### Control Hazards - Branch
Branch decisions flush invalid instructions from the pipeline. Waveform confirms flush signal activation during branch resolution.

### Forwarding
Demonstrated correct data forwarding between instructions to avoid unnecessary stalls.

### Control Hazards - Jump
A jump causes a pipeline flush to remove invalid sequentially fetched instructions before the jump is resolved.

## File List

- `ALU.v`
- `ALUControl.v`
- `control.v`
- `data_memory.v`
- `EX_Forwarding_unit.v`
- `EX_pipe_stage.v`
- `Hazard_detection.v`
- `ID_pipe_stage.v`
- `IF_pipe_stage.v`
- `mips_32.v`
- `mux.v`
- `mux4.v`
- `pipe_reg.v`
- `pipe_reg_en.v`
- `register_file.v`
- `sign_extend.v`

## Notes

- All modules were tested with a provided testbench and waveform analysis.
- The lab demonstrates effective pipeline construction, hazard management, and control signal integration.

## Status

- Functionality Verified
- Forwarding Implemented
- Control Hazards Handled
- Stalls and Flushes Verified in Simulation
