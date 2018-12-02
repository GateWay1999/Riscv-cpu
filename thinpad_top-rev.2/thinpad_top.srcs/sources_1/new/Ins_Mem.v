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
    output wire[`InstBus]        inst,    //数据输出
    inout wire[31:0] ext_ram_data,
    output reg[19:0] ext_ram_addr,
    output reg[3:0] ext_ram_be_n,
    output reg ext_ram_ce_n,
    output reg ext_ram_oe_n,
    output reg ext_ram_we_n
);
    // 定义指令存储器大小
    //reg[`InstBus] inst_mem[0:`InstMemNum-1];
    // 使用文件初始化指令存储器
    //initial $readmemh ("\\Mac\Home\Desktop\risc-v-biglao\test\data\alu.data", inst_mem);
    // 依据输入地址，提供数据
    //assign inst = inst_mem[addr[`InstMemNumLog2+1:2]]; 


    assign inst = ext_ram_data;
    always @ (*) begin
         ext_ram_ce_n <= `Lowv;//片选低
         ext_ram_oe_n <= `Lowv;//读使能低
         ext_ram_we_n <= `Highv;//写使能高
         ext_ram_be_n <= 4'b0000;
         ext_ram_addr <= addr[21:2];//赋地址
     end

endmodule
