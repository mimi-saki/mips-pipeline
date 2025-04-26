`timescale 1ns / 1ps

module IF_pipe_stage(
    input clk, reset,
    input en,
    input [9:0] branch_address,
    input [9:0] jump_address,
    input branch_taken,
    input jump,
    output [9:0] pc_plus4,
    output [31:0] instr
    );
    
// write your code here
    instruction_mem inst_memory (
        .read_addr(PC), 
        .data(instr)
    );
    
    reg [9:0] PC;
    wire [9:0] next_Ins;
    wire [9:0] mux_Branch;
    wire [9:0] pc_Incremented;
    
    assign pc_Incremented = PC + 10'd4;
    assign next_Ins = (jump) ? jump_address : mux_Branch;
    assign mux_Branch = (branch_taken) ? branch_address : pc_Incremented;
    

    always @(posedge clk or posedge reset) begin
        if (reset) 
            PC <= 10'b0; // reset
        else if (en)
            PC <= next_Ins; // next ins
    end

    assign pc_plus4 = pc_Incremented; // assign pc + 4

endmodule
