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
    integer addr;
    always @ (*) begin
        if (rst == `RSTon) begin
            for (addr = 0; addr <= 5'b11111; addr = addr + 1)
                 register[addr] <= `SetZero;
        end else begin
            if (Regwrite == `WriteEnable && rd != 5'b00000) begin
                register[rd] <= write_data;
            end
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
