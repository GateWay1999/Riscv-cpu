`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/28 21:57:22
// Design Name: 
// Module Name: MEM_WB
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

module MEM_WB(
    input wire clk, 
    input wire rst,
    input wire MEMtoReg_i,
    input wire Regwrite_i,
    input wire[31:0] load_data_i,
    input wire[31:0] ALU_result_i,
    input wire[4:0] rd_i,
    input wire SPC_i,

    output reg SPC_o,
    output reg MEMtoReg_o,
    output reg Regwrite_o,
    output reg[31:0] load_data_o,
    output reg[31:0] ALU_result_o,
    output reg[4:0] rd_o
);

    always @ (posedge clk) begin
        if (rst == `RSToff) begin
            MEMtoReg_o <= MEMtoReg_i;
            Regwrite_o <= Regwrite_i;
            load_data_o<= load_data_i;
            ALU_result_o<= ALU_result_i;
            rd_o <= rd_i;
            SPC_o <= SPC_i;
        end else begin
            MEMtoReg_o <= `Falsev;
            Regwrite_o <= `Falsev;
            load_data_o<= `SetZero;
            ALU_result_o<= `SetZero;
            rd_o<= 5'b00000;
            SPC_o <= 1'b0;
        end
    end
endmodule
