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
    input wire[31:0] ac_addr,               // 32λҪ���ʵĵ�ַ
    input wire[31:0] store_data,            //  32λҪ�洢������
    input wire MEMwrite,                    // дʹ��
    input wire MEMread,                     // ��ʹ��
    /* funct �� [2:0] �����ֱ���ʷ�ʽ
        OB      3'b000      ��ȡ����� 8λ  ��ȡ�Ļ���������չ��32λ  ���벻����չֱ�Ӵ����Ӧλ��
        OH      3'b001      ��ȡ����� 16λ ��ȡ�Ļ���������չ��32λ  ���벻����չֱ�Ӵ����Ӧλ��
        OW      3'b010      ��ȡ����� 32λ ���벻����չֱ�Ӵ����Ӧλ��
        LBU     3'b011      ��ȡ һ���ֽ� ������չ��32λ
        LHU     3'b100      ��ȡ �����ֽ� ������չ��32λ
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
