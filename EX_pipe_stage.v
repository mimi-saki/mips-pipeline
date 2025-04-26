`timescale 1ns / 1ps

module EX_pipe_stage(
    input [31:0] id_ex_instr,
    input [31:0] reg1, reg2,
    input [31:0] id_ex_imm_value,
    input [31:0] ex_mem_alu_result,
    input [31:0] mem_wb_write_back_result,
    input id_ex_alu_src,
    input [1:0] id_ex_alu_op,
    input [1:0] Forward_A, Forward_B,
    output [31:0] alu_in2_out,
    output [31:0] alu_result
    );
    
    // Write your code here
    wire [3:0] ALU_Control;
    wire [31:0] reg1_Muxout;
    wire [31:0] ALU_Muxout;
    wire zero;
    
    // mux for reg1
    mux4 #(32) reg1Mux(
        .a(reg1),
        .b(mem_wb_write_back_result),
        .c(ex_mem_alu_result),
        .d(32'b0),
        .sel(Forward_A),
        .y(reg1_Muxout)
    );

    // mux for reg2
    mux4 #(32) reg2Mux(
        .a(reg2),
        .b(mem_wb_write_back_result),
        .c(ex_mem_alu_result),
        .d(32'b0),
        .sel(Forward_B),
        .y(alu_in2_out)
    );

    // ALUControl module
    ALUControl ALUctrl(
        .ALUOp(id_ex_alu_op), 
        .Function(id_ex_instr[5:0]),
        .ALU_Control(ALU_Control)
    );
    
    // mux for ALU
    mux2 #(32) ALUmux (
        .a(alu_in2_out),
        .b(id_ex_imm_value),
        .sel(id_ex_alu_src),
        .y(ALU_Muxout)
    );


    // ALU module
    ALU ALU(
        .a(reg1_Muxout),
        .b(ALU_Muxout), 
        .alu_control(ALU_Control),
        .zero(zero),
        .alu_result(alu_result)
    );
endmodule
