`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/28 08:47:44
// Design Name: 
// Module Name: Control
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

module Control(
    input wire              rst,
    input wire[6:0]         inst,
    input wire              jump,
    
    output reg[1:0]         ALUop,
    output reg              ALUsrc,
    output reg              MEMread,
    output reg              MEMwrite,
    output reg              MEMtoReg,
    output reg              Regwrite,
    output reg              if_flush
);
    always @ (*) begin
        if (rst == `RSToff) begin
            if (jump == `Truev) begin
                ALUsrc <= `Falsev;
                MEMread <= `Falsev;
                MEMwrite <= `Falsev;
                MEMtoReg <= `Falsev;
                case (inst[4:2])
                    `JAL: begin
                        ALUop <= `ALU_J;
                        Regwrite <= `Truev;
                    end
                    `JALR: begin
                        ALUop <= `ALU_J;
                        Regwrite <= `Truev;
                    end
                    default: begin
                        ALUop <= `ALU_N;
                        Regwrite <= `Falsev;
                    end
                endcase
                if_flush <= `Truev;
            end else begin
                if (inst[6:0] == 7'b0000011) begin            // Load
                    MEMread <= `Truev;
                    MEMwrite <= `Falsev;
                    MEMtoReg <= `Truev;
                    ALUop <= `ALU_M;
                    ALUsrc <= `ImmSrc;
                    Regwrite <= `Truev;
                end else if (inst[6:0] == 7'b0100011) begin   // Store
                    MEMread <= `Falsev;
                    MEMwrite <= `Truev;
                    MEMtoReg <= `Falsev;
                    ALUop <= `ALU_M;
                    ALUsrc <= `ImmSrc;
                    Regwrite <= `Falsev;
                end else if (inst[6:5] == 2'b11) begin      // Ìø×ª
                    MEMread <= `Falsev;
                    MEMwrite <= `Falsev;
                    MEMtoReg <= `Falsev;
                    ALUop <= `ALU_N;
                    ALUsrc <= `ImmSrc;
                    Regwrite <= `Falsev;
                end else if (inst[6:0] == 7'b0010011) begin    // ËãÊõÂß¼­Imm
                    MEMread <= `Falsev;
                    MEMwrite <= `Falsev;
                    MEMtoReg <= `Falsev;
                    ALUop <= `ALU_A;
                    ALUsrc <= `ImmSrc;
                    Regwrite <= `Truev;
                end else if (inst[6:0] == 7'b0110011) begin   // ËãÊõÂß¼­Reg
                    MEMread <= `Falsev;
                    MEMwrite <= `Falsev;
                    MEMtoReg <= `Falsev;
                    ALUop <= `ALU_A;
                    ALUsrc <= `RegSrc;
                    Regwrite <= `Truev;
                end else if (inst[6:0] == 7'b0110111 || inst[6:0] == 7'b0010111) begin // LUI AUIPC
                    MEMread <= `Falsev;
                    MEMwrite <= `Falsev;
                    MEMtoReg <= `Falsev;
                    ALUop <= `ALU_J;
                    ALUsrc <= `ImmSrc;
                    Regwrite <= `Truev;
                end else begin
                    MEMread <= `Falsev;
                    MEMwrite <= `Falsev;
                    MEMtoReg <= `Falsev;
                    ALUop <= `ALU_N;
                    ALUsrc <= `RegSrc;
                    Regwrite <= `Falsev;
                end
                if_flush <= `Falsev;
            end
        end else begin
            ALUop <= `ALU_N;
            ALUsrc <= `Falsev;
            MEMread <= `Falsev;
            MEMwrite <= `Falsev;
            MEMtoReg <= `Falsev;
            Regwrite <= `Falsev;
            if_flush <= `Falsev;
        end
    end
    
endmodule
