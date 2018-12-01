`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/27 22:45:07
// Design Name: 
// Module Name: PC
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

module PC(
    input wire                  clk,
    input wire                  rst,
    input wire                  pc_write,        //pc写入<<冲突检测单元
    input wire[`InstAddrBus]    pc_branch,       //要跳转的PC值
    input wire                  pc_select,       //跳转或是正常加4
    input wire                  stop_pc,
    output reg[`InstAddrBus]    pc               //存储PC
);

    always @ (posedge clk) begin
        if (rst == `RSTon) begin
            pc <= `SetZero;
        end else if(rst == `RSToff) begin
            if (stop_pc == `Falsev) begin
                if ((pc_write == `WriteEnable)) begin
                    if (pc_select == `TakeBranch) begin
                        pc <= pc_branch;
                    end else if (pc_select == `NotTake) begin
                        pc <= pc + 4'h4;
                    end
                end
            end
        end else begin
            pc <= `SetZero;
        end
    end
endmodule
