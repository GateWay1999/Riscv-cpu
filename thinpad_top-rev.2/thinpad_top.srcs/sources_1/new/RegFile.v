`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/28 01:58:36
// Design Name: 
// Module Name: RegFile
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

module RegFile(
    input wire                  rst,
    input wire                  Regwrite,
    input wire[`RegAddrBus]     rs1,
    input wire[`RegAddrBus]     rs2,
    input wire[`RegAddrBus]     rd,                 // write_reg
    input wire[`RegBus]         write_data,
    
    output reg[`RegBus]         read_1,
    output reg[`RegBus]         read_2
);
    // 定义32个寄存器
    reg[31:0] register[31:0];
    always @ (*) begin
        if (rst == `RSToff) begin
            if (Regwrite == `WriteEnable && rd != 5'b00000) begin
                register[rd] <= write_data;
            end
        end else begin
            register[0] <= `SetZero;
            register[1] <= `SetZero;
            register[2] <= `SetZero;
            register[3] <= `SetZero;
            register[4] <= `SetZero;
            register[5] <= `SetZero;
            register[6] <= `SetZero;
            register[7] <= `SetZero;
            register[8] <= `SetZero;
            register[9] <= `SetZero;
            register[10] <= `SetZero;
            register[11] <= `SetZero;
            register[12] <= `SetZero;
            register[13] <= `SetZero;
            register[14] <= `SetZero;
            register[15] <= `SetZero;
            register[16] <= `SetZero;
            register[17] <= `SetZero;
            register[18] <= `SetZero;
            register[19] <= `SetZero;
            register[20] <= `SetZero;
            register[21] <= `SetZero;
            register[22] <= `SetZero;
            register[23] <= `SetZero;
            register[24] <= `SetZero;
            register[25] <= `SetZero;
            register[26] <= `SetZero; 
            register[27] <= `SetZero; 
            register[28] <= `SetZero;
            register[29] <= `SetZero;
            register[30] <= `SetZero;
            register[31] <= `SetZero;
        end
    end
    // 读取rs1
    always @ (*) begin
        if (rst == `RSTon) begin
            read_1 <= `SetZero;
        end else if(rst == `RSToff) begin 
            if (rs1 == 5'b00000) begin
                read_1 <= `SetZero;
            end else if ((rs1 == rd) && (Regwrite == `WriteEnable)) begin 
                read_1 <= write_data;
            end else begin
                read_1 <= register[rs1];
            end
        end
    end
    // 读取rs2
        always @ (*) begin
            if (rst == `RSTon) begin
                read_2 <= `SetZero;
            end else if(rst == `RSToff) begin 
                if (rs2 == 5'b00000) begin
                    read_2 <= `SetZero;
                end else if ((rs2 == rd) && (Regwrite == `WriteEnable)) begin 
                    read_2 <= write_data;
                end else begin
                    read_2 <= register[rs2];
                end
            end
        end
endmodule
