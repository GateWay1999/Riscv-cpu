`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/28 00:02:02
// Design Name: 
// Module Name: IF_ID
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

module IF_ID(
    input wire                  clk,
    input wire                  rst,
    input wire                  if_id_write,
    input wire                  if_flush,
    input wire[`InstAddrBus]    pc_i,
    input wire[`InstBus]        inst_data_i,
    input wire                  stop_IFID,
    output reg[`InstAddrBus]    pc_o,
    output reg[`InstBus]        inst_data_o
);

    always @ (posedge clk) begin
        if (rst == `RSTon) begin
            pc_o <= `SetZero;
            inst_data_o <= `SetZero;
        end else if (rst == `RSToff) begin
            if (if_id_write == `WriteEnable && stop_IFID == `Falsev) begin 
                if (if_flush == `Truev) begin
                    pc_o <= `SetZero;
                    inst_data_o <= `SetZero;
                end else begin
                    pc_o <= pc_i;
                    inst_data_o <= inst_data_i;
                end
            end
        end
    end
endmodule
