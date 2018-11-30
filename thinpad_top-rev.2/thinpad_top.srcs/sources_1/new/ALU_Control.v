`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/28 16:51:00
// Design Name: 
// Module Name: ALU_Control
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

module ALU_Control(
    input wire rst,
    input wire[1:0] ALUop,
    input wire[4:0] funct,
    output reg[3:0] ALUcode
);

    always @ (*) begin
        if (rst == `RSTon) begin
            ALUcode <= `ALU_NOP;
        end else begin
            if (ALUop == `ALU_N) begin
                ALUcode <= `ALU_NOP;
            end else if(ALUop == `ALU_M)begin
                ALUcode <= `ALU_ADD;
            end else if(ALUop == `ALU_J)begin
                case (funct) 
                    5'b01101: begin
                        ALUcode <= `ALU_LUI;
                    end
                    5'b00101: begin
                        ALUcode <= `ALU_AUIPC;
                    end
                    default: begin
                        ALUcode <= `ALU_PC4;
                    end
                endcase
            end else if(ALUop == `ALU_A)begin
                if (funct[2:0] == 3'b000) begin     // ADD or SUB
                    if (funct[4] == 1'b1) begin             // ADD or SUB
                        if ( funct[3] == 1'b0 ) begin
                            ALUcode <= `ALU_ADD;
                        end else begin
                            ALUcode <= `ALU_SUB;
                        end
                    end else begin                          // ADDI
                        ALUcode <= `ALU_ADD;
                    end
                end else if (funct[2:0] == 3'b001) begin // Shift Left
                    ALUcode <= `ALU_SHIFT_L;
                end else if (funct[2:0] == 3'b010) begin // Set Less Than
                    ALUcode <= `ALU_SLT;
                end else if (funct[2:0] == 3'b011) begin // Set Less Than U
                    ALUcode <= `ALU_SLTU;
                end else if (funct[2:0] == 3'b100) begin // XOR
                    ALUcode <= `ALU_XOR;
                end else if (funct[2:0] == 3'b101) begin // Shift Right
                    if (funct[3] == 1'b0) begin
                        ALUcode <= `ALU_SHIFT_RL;
                    end else begin
                        ALUcode <= `ALU_SHIFT_RA;
                    end
                end else if (funct[2:0] == 3'b110) begin // OR
                    ALUcode <= `ALU_OR;
                end else if (funct[2:0] == 3'b111) begin // AND
                    ALUcode <= `ALU_ADD;
                end else begin
                    ALUcode <= `ALU_NOP;
                end
            end else begin
                ALUcode <= `ALU_NOP;
            end
        end
    end
    
endmodule
