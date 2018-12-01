`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/28 01:07:20
// Design Name: 
// Module Name: Fetch
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

module Fetch(
    input wire clk,                             // CPU 时钟
    input wire rst,                             // CPU 复位
    input wire pc_write_i,                      // PC 写控制
    input wire pc_select_i,                     // PC+4 分支选择
    input wire[`InstAddrBus] pc_branch_i,       // 跳转地址
    input wire if_flush,                        // 清除IFID
    input wire ifid_write,                      // IFID 写控制
    input wire stop_pc,                         // PC 写控制
    input wire stop_IFID,                       // IFID 写控制
    
    output wire[`InstAddrBus] pc,
    output wire[`InstBus] inst_data
);
    wire[`InstAddrBus] pc_o;   
    wire[`InstBus] inst_data_o;

    PC pc0(
        .clk(clk), .rst(rst),
        .pc_write(pc_write_i), .pc_branch(pc_branch_i),
        .pc_select(pc_select_i), .pc(pc_o),.stop_pc(stop_pc)
    );
    
    Ins_Mem im0(
        .addr(pc_o), .inst(inst_data_o)
    );
    
    IF_ID ifd0(
        .clk(clk), .rst(rst),
        .if_id_write(ifid_write), .if_flush(if_flush),
        .pc_i(pc_o), .inst_data_i(inst_data_o),
        .pc_o(pc), .inst_data_o(inst_data),.stop_IFID(stop_IFID)
    ); 
endmodule
