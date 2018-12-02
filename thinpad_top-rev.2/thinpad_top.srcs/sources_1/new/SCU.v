`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/01 00:08:48
// Design Name: 
// Module Name: SCU
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

module SCU(
    input wire rst,
    input wire[31:0] ALU_result,
    input wire[4:0] funct,
    input wire MEMread,
    input wire MEMwrite,
    input wire SPC_i,
    
    output reg stop_pc,
    output reg stop_IFID,
    output reg clear_IDEX,
    output reg stop_EXMEM,
    output reg stop_MEMWB,
    output reg SPC_o
);

    always @ (*) begin
        if (rst == `RSToff) begin
            if (ALU_result == `PORTaddr && funct[2:0] == 3'b000 && SPC_i == `Falsev && (MEMread || MEMwrite)) begin
                SPC_o <= `Truev;
                stop_pc <=  `Truev;
                stop_IFID <= `Truev;
                clear_IDEX <= `Truev;
                stop_EXMEM <= `Truev;
                stop_MEMWB <= `Truev;
            end else if (SPC_i == `Truev) begin
                SPC_o <= `Truev;
                stop_pc <=  `Truev;
                stop_IFID <= `Truev;
                clear_IDEX <= `Truev;
                stop_EXMEM <= `Truev;
                stop_MEMWB <= `Truev;
            end else begin
                stop_pc <=  `Falsev;
                stop_IFID <= `Falsev;
                clear_IDEX <= `Falsev;
                stop_EXMEM <= `Falsev;
                stop_MEMWB <= `Falsev;
                SPC_o <= `Falsev;
            end
        end else begin
            stop_pc <=  `Falsev;
            stop_IFID <= `Falsev;
            clear_IDEX <= `Falsev;
            stop_EXMEM <= `Falsev;
            stop_MEMWB <= `Falsev;
            SPC_o <= `Falsev;
        end
    end
endmodule
