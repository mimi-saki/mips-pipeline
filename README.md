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
  Implements instruction fetching, PC incrementation, and handling of jump/branch logic with appropriate muxing.

- **EX_pipe_stage.v**  
  Executes arithmetic/logical operations using the ALU and handles data forwarding to resolve hazards via mux4 multiplexers and Forward_A/B control signals.

- **EX_Forwarding_unit.v**  
  Generates forwarding control signals to mitigate read-after-write (RAW) hazards. Conditions are checked against pipeline stages to redirect correct operand values.

- **mips_32.v**  
  Top-level module integrating all five pipeline stages. Handles control logic, hazard detection, instruction/data memory operations, and result writeback.

## Simulation Results

### Basic Functionality
Testbench output and waveforms confirm correct pipeline operation. Expected results from early instructions match waveform data.

### Data Hazards
A `lw` followed by an `add` using the loaded register `$r11` causes a stall. The decode stage holds until the register is written, verified by the waveform (`q[31:0]` delay).

### Control Hazards - Branch
Waveforms show pipeline flush when a branch is taken. Instruction fetch is corrected to target ROM location (`rom[56]`) after comparison of `$r2` and `$r3`.

### Forwarding
Forwarding from both EX/MEM and MEM/WB stages is verified. For example, forwarding `$r11`’s value to `$r12` occurs correctly without pipeline stalls.

### Control Hazards - Jump
A pipeline flush is triggered to discard speculatively fetched instructions after a jump. Execution resumes from the correct jump address with a brief delay.

## Notes

- All hazards (data, control, forwarding) were tested via waveform inspection and confirmed.
- The processor demonstrates full instruction flow through a pipelined architecture, including stall and flush mechanisms.

## File List

- `mips_32.v`
- `IF_pipe_stage.v`
- `EX_pipe_stage.v`
- `EX_Forwarding_unit.v`
- Other provided pipeline stage modules and support files.

## Status

- Functionality Verified
- Forwarding Implemented
- Control Hazards Handled
- Stalls and Flushes Verified in Simulation
