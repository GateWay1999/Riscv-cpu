`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/28 16:51:00
// Design Name: 
// Module Name: FU
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

module FU(
    input wire          rst,
    input wire[4:0]     rs1,
    input wire[4:0]     rs2,
    input wire          Regwrite_MEM,
    input wire[4:0]     rd_MEM,
    input wire          Regwrite_WB,
    input wire[4:0]     rd_WB,
    input wire[1:0]     ALUop,
    input wire[4:0]     funct,
    
    output reg[1:0]     FU_A,
    output reg[1:0]     FU_B
);

    always @ (*) begin
        if (rst == `RSToff && !(ALUop == `ALU_J && funct == 5'b01101) && !(ALUop == `ALU_J && funct == 5'b11011) && !(ALUop == `ALU_J && funct == 5'b00101)) begin
            if  (Regwrite_MEM && (rd_MEM != 5'b00000) && (rd_MEM == rs1)) begin
                FU_A <= `EXMEM;
            end else if (Regwrite_WB && (rd_WB != 5'b00000) && !(Regwrite_MEM && (rd_MEM != 5'b00000) && (rd_MEM == rs1)) && (rd_WB == rs1)) begin
                FU_A <= `MEMWB;
            end else begin
                FU_A <= `IDEX;
            end
            if (Regwrite_MEM && (rd_MEM != 5'b00000) && (rd_MEM == rs2)) begin
                FU_B <= `EXMEM;
            end else if (Regwrite_WB && (rd_WB != 5'b00000) && !(Regwrite_MEM && (rd_MEM != 5'b00000) && (rd_MEM == rs2)) && (rd_WB == rs2)) begin
                FU_B <= `MEMWB;
            end else begin
                FU_B <= `IDEX;
            end
        end else begin
            FU_A <= `IDEX;
            FU_B <= `IDEX;
        end
    end
endmodule
