`timescale 1ns / 1ps

module ID_pipe_stage(
    input  clk, reset,
    input  [9:0] pc_plus4,
    input  [31:0] instr,
    input  mem_wb_reg_write,
    input  [4:0] mem_wb_write_reg_addr,
    input  [31:0] mem_wb_write_back_data,
    input  Data_Hazard,
    input  Control_Hazard,
    output [31:0] reg1, reg2,
    output [31:0] imm_value,
    output [9:0] branch_address,
    output [9:0] jump_address,
    output branch_taken,
    output [4:0] destination_reg, 
    output mem_to_reg,
    output [1:0] alu_op,
    output mem_read,  
    output mem_write,
    output alu_src,
    output reg_write,
    output jump
    );
    
    // write your code here 
    // Remember that we test if the branch is taken or not in the decode stage. 	
    wire [6:0] contrl_Out;
    wire [6:0] mux_Out;
    wire reg_Dest;
       
    mux2#(7) ctrlMux(   
        .a(contrl_Out),
        .b(7'b000000),
        .sel((!Data_Hazard) || Control_Hazard),
        .y(mux_Out)
    );

    assign mem_to_reg = mux_Out[6];
    assign alu_op = mux_Out[5:4];
    assign mem_read = mux_Out[3];
    assign mem_write = mux_Out[2];
    assign alu_src = mux_Out[1];
    assign reg_write = mux_Out[0];

   control ctrl(
       .reset(reset),
       .opcode(instr[31:26]), 
       .reg_dst(reg_Dest),
       .mem_to_reg(contrl_Out[6]), 
       .alu_op(contrl_Out[5:4]),  
       .mem_read(contrl_Out[3]), 
       .mem_write(contrl_Out[2]),
       .alu_src(contrl_Out[1]), 
       .reg_write(contrl_Out[0]),
       .branch(),
       .jump(jump) 
    );

    mux2#(5) muxDest(
        .a(instr[20:16]),
        .b(instr[15:11]),
        .sel(reg_Dest),
        .y(destination_reg)
    );

    // register 
    register_file regFile(
        .clk(clk),
        .reset(reset),  
        .reg_write_en(mem_wb_reg_write),
        .reg_write_dest(mem_wb_write_reg_addr),  
        .reg_write_data(mem_wb_write_back_data),
        .reg_read_addr_1(instr[25:21]),
        .reg_read_addr_2(instr[20:16]),  
        .reg_read_data_1(reg1),  
        .reg_read_data_2(reg2) 
    );
        
    assign branch_taken = ctrl.branch && (reg1 == reg2) ? 1'b1 : 1'b0;
    assign branch_address = pc_plus4 + (imm_value << 2); 
    
    sign_extend signExtend(
        .sign_ex_in(instr[15:0]),
        .sign_ex_out(imm_value)
    );
    
    assign jump_address = instr[25:0] << 2;
    
endmodule
