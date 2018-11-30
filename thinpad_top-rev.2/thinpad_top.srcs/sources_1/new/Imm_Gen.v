`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/28 01:59:34
// Design Name: 
// Module Name: Imm_Gen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "define.v"

module Imm_Gen(
    input wire          rst,
    input wire[19:0]    imm_i,
    input wire[31:0]    pc_now,
    output reg[31:0]    imm_o,
    output reg[31:0]    branch_pc
);
    always @ (*) begin
        if (rst == `RSTon) begin
            imm_o <= `SetZero;
            branch_pc <= `SetZero;
        end else begin
            imm_o <= {{12{imm_i[19]}}, imm_i};
            branch_pc <= ({{12{imm_i[19]}}, imm_i} << 1) + pc_now;
        end
    end
endmodule
