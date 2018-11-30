`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/28 08:51:06
// Design Name: 
// Module Name: ID_EX
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

module ID_EX(
    // input
    input wire clk,
    input wire rst,
    input wire[1:0]         ALUop_i,          //  EXControl
    input wire              ALUsrc_i,         //  EXControl
    input wire              MEMread_i,        //  MEMControl
    input wire              MEMwrite_i,       //  MEMControl
    input wire              MEMtoReg_i,       //  WBControl
    input wire              Regwrite_i,       //  WBControl
    input wire[`RegAddrBus] rs1_i,
    input wire[`RegAddrBus] rs2_i,
    input wire[`RegAddrBus] rd_i,
    input wire[`RegBus]     rs1_data_i,
    input wire[`RegBus]     rs2_data_i,
    input wire[`InstAddrBus]pc,
    input wire[31:0]        imm_i,
    input wire[4:0]         funct_i,
    input wire              clear_IDEX,
    // output
    output reg[1:0]         ALUop_o,          //  EXControl
    output reg              ALUsrc_o,         //  EXControl
    output reg              MEMread_o,        //  MEMControl
    output reg              MEMwrite_o,       //  MEMControl
    output reg              MEMtoReg_o,       //  WBControl
    output reg              Regwrite_o,       //  WBControl
    output reg[`RegAddrBus] rs1_o,
    output reg[`RegAddrBus] rs2_o,
    output reg[`RegAddrBus] rd_o,
    output reg[`RegBus]     rs1_data_o,
    output reg[`RegBus]     rs2_data_o,
    output reg[31:0]        imm_o,
    output reg[4:0]         funct_o
);
    always @ (posedge clk) begin
        if (rst ==`RSToff && clear_IDEX == `Falsev) begin
            ALUop_o <= ALUop_i;
            ALUsrc_o <= ALUsrc_i;
            MEMread_o <= MEMread_i;
            MEMtoReg_o <= MEMtoReg_i;
            MEMwrite_o <= MEMwrite_i;
            Regwrite_o <= Regwrite_i;
            rs1_o <= rs1_i;
            rs2_o <= rs2_i;
            rd_o <= rd_i;
            if (ALUop_i == `ALU_J) begin
                rs1_data_o <= pc;
            end else begin
                rs1_data_o <= rs1_data_i;
            end
            rs2_data_o <= rs2_data_i;
            imm_o <= imm_i;
            funct_o <= funct_i;
        end else begin
            ALUop_o <= 2'b00;
            ALUsrc_o <= 1'b0;
            MEMread_o <= 1'b0;
            MEMtoReg_o <= 1'b0;
            MEMwrite_o <= 1'b0;
            Regwrite_o <= 1'b0;
            rs1_o <= 5'b00000;
            rs2_o <= 5'b00000;
            rd_o <= 5'b00000;
            rs1_data_o <= `SetZero;
            rs2_data_o <= `SetZero;
            imm_o <= `SetZero;
            funct_o <= 5'b00000;
        end
    end
endmodule
