`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/28 21:56:50
// Design Name: 
// Module Name: Data_Mem
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

module Data_Mem(
    input wire clk,
    input wire rst,
    input wire[31:0] ac_addr,               // 32位要访问的地址
    input wire[31:0] store_data,            //  32位要存储的数据
    input wire MEMwrite,                    // 写使能
    input wire MEMread,                     // 读使能
    /* funct 的 [2:0] 用来分辨访问方式
        OB      3'b000      读取或存入 8位  读取的话做符号扩展到32位  存入不用扩展直接存入对应位数
        OH      3'b001      读取或存入 16位 读取的话做符号扩展到32位  存入不用扩展直接存入对应位数
        OW      3'b010      读取或存入 32位 存入不用扩展直接存入对应位数
        LBU     3'b011      读取 一个字节 做零扩展到32位
        LHU     3'b100      读取 两个字节 做零扩展到32位
    */
    input wire[4:0] funct,
    inout wire[31:0] base_ram_data,
        
    output wire[19:0] base_ram_addr,
    output wire[3:0] base_ram_be_n,
    output wire base_ram_ce_n,
    output wire base_ram_oe_n,
    output wire base_ram_we_n,
    output wire[31:0] load_data
);
endmodule
