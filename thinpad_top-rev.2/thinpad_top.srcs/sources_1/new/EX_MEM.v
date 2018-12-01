`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/28 16:51:00
// Design Name: 
// Module Name: EX_MEM
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

module EX_MEM(
    input wire              clk, 
    input wire              rst,
    input wire[31:0]        result,
    input wire[31:0]        store_data,
    input wire[`RegAddrBus] rd,
    input wire              MEMwrite,
    input wire              MEMread,
    input wire              MEMtoReg,
    input wire              Regwrite,
    input wire[4:0]         funct,
    input wire              stop_EXMEM,
    
    output reg[31:0]       result_o,
    output reg[31:0]       store_data_o,
    output reg[`RegAddrBus] rd_o,
    output reg             MEMwrite_o,
    output reg             MEMread_o,
    output reg             MEMtoReg_o,
    output reg             Regwrite_o,
    output reg[4:0]        funct_o
);

    always @ (posedge clk) begin
        if (rst == `RSToff) begin
            if ( stop_EXMEM == `Falsev) begin
                result_o <= result;
                store_data_o <= store_data;
                rd_o <= rd;
                MEMwrite_o <= MEMwrite;
                MEMread_o <= MEMread;
                MEMtoReg_o <= MEMtoReg;
                Regwrite_o <= Regwrite;
                funct_o <= funct;
            end
        end else begin
            result_o <= `SetZero;
            store_data_o <= `SetZero;
            rd_o <= 5'b00000;
            MEMwrite_o <= `WriteDisable;
            MEMread_o <= `Falsev;
            MEMtoReg_o <= `Falsev;
            Regwrite_o <= `WriteDisable;
            funct_o <= 5'b00000;
        end
    end
endmodule
