`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/29 21:03:41
// Design Name: 
// Module Name: CHFU
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

module CHFU(
    input wire          rst,
    input wire[4:0]     rs1,
    input wire[4:0]     rs2,
    input wire[1:0]     inst,
    input wire          Regwrite_MEM,
    input wire[4:0]     rd_MEM,
    input wire          Regwrite_WB,
    input wire[4:0]     rd_WB,
    input wire[31:0]    write_data,
    input wire[31:0]    ALU_result,

    output reg          rs1_change,
    output reg          rs2_change,
    output reg[31:0]    change_data
);

    always @ (*) begin
        if (rst == `RSToff) begin
            if (inst[1:0] == 2'b11) begin
                if  (Regwrite_MEM && (rd_MEM != 5'b00000) && (rd_MEM == rs1)) begin
                    rs1_change <= `Truev;
                    change_data <= ALU_result;
                end else if (Regwrite_WB && (rd_WB != 5'b00000) && !(Regwrite_MEM && (rd_MEM != 5'b00000) && (rd_MEM == rs1)) && (rd_WB == rs1)) begin
                    rs1_change <= `Truev;
                    change_data <= write_data;
                end else begin
                    rs1_change <= `Falsev;
                end
                if (Regwrite_MEM && (rd_MEM != 5'b00000) && (rd_MEM == rs2)) begin
                    rs2_change <= `Truev;
                    change_data <= ALU_result;
                end else if (Regwrite_WB && (rd_WB != 5'b00000) && !(Regwrite_MEM && (rd_MEM != 5'b00000) && (rd_MEM == rs2)) && (rd_WB == rs2)) begin
                    rs2_change <= `Truev;
                    change_data <= write_data;
                end else begin
                    rs2_change <= `Falsev;
                end
            end else begin
                rs1_change <= `Falsev;
                rs2_change <= `Falsev;
                change_data <= `SetZero;
            end
        end else begin
            rs1_change <= `Falsev;
            rs2_change <= `Falsev;
            change_data <= `SetZero;
        end
    end
endmodule
