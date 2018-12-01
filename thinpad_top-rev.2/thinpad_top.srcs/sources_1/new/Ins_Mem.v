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
    input wire[`InstAddrBus]    addr,   //�����ȡ��ַ
    output wire[`InstBus]        inst    //�������
);
    // ����ָ��洢����С
    reg[`InstBus] inst_mem[0:`InstMemNum-1];
    // ʹ���ļ���ʼ��ָ��洢��
    initial $readmemh ("C:/Users/blade/Desktop/Riscv-cpu/thinpad_top-rev.2/thinpad_top.srcs/sources_1/new/inst_rom.data", inst_mem);
    // ���������ַ���ṩ����
    assign inst = inst_mem[addr[`InstMemNumLog2+1:2]]; 
endmodule
