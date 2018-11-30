`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/28 08:50:45
// Design Name: 
// Module Name: Compare
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

module Compare(
    input wire rst,
    input wire[7:0] option,
    input wire[`InstBus] rs1,
    input wire[`InstBus] rs2,
    output reg jump
);
    always @ (*) begin
        if (rst == `RSToff) begin
            if (option[4:3] == 2'b11 && option[2:0] == 3'b000) begin
                case (option[7:5])
                    `BEQ: begin
                        jump <= (rs1 == rs2) ? `Truev : `Falsev;
                    end
                    `BNE: begin
                        jump <= (rs1 != rs2) ? `Truev : `Falsev;
                    end
                    `BLT: begin
                        if (rs1[31] != rs2[31]) begin
                            jump <= rs1[31] ? 1'b1 : 1'b0;
                        end else begin
                            jump <= (rs1 - rs2) ? 1'b1 : 1'b0;
                        end
                    end
                    `BGE: begin
                        if (rs1[31] != rs2[31]) begin
                            jump <= rs1[31] ? 1'b0 : 1'b1;
                        end else begin
                            jump <= (rs1 - rs2) ? 1'b0 : 1'b1;
                        end
                    end
                    `BLTU: begin
                        jump <= (rs1 < rs2) ? `Truev : `Falsev;
                    end
                    `BGEU: begin
                        jump <= (rs1 >= rs2) ? `Truev : `Falsev;
                    end
                    default: begin
                        jump <= `Falsev;
                    end
                endcase
            end else if (option[4:3] == 2'b11 && (option[2:0] == 3'b011 || option[2:0] == 3'b001)) begin
                jump <= `Truev;
            end else begin
                jump <= `Falsev;
            end
        end else begin
            jump <= `Falsev;
        end
    end
endmodule
