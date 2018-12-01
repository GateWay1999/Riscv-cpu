`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/27 23:40:44
// Design Name: 
// Module Name: Ins_Mem
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

module Ins_Mem(
    input wire[`InstAddrBus]    addr,   //传入读取地址
    output wire[`InstBus]        inst    //数据输出
);
    // 定义指令存储器大小
    reg[`InstBus] inst_mem[0:`InstMemNum-1];
    // 使用文件初始化指令存储器
    initial $readmemh ("C:/Users/blade/Desktop/Riscv-cpu/thinpad_top-rev.2/thinpad_top.srcs/sources_1/new/inst_rom.data", inst_mem);
    // 依据输入地址，提供数据
    assign inst = inst_mem[addr[`InstMemNumLog2+1:2]]; 
endmodule
