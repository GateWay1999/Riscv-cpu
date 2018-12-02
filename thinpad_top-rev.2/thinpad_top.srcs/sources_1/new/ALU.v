`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/28 16:51:00
// Design Name: 
// Module Name: ALU
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

module ALU(
    input wire rst,
    input wire[3:0] ALUcode,
    input wire[31:0] data_1,
    input wire[31:0] data_2,
    output reg[31:0] result
);
    integer addr;
    reg temp = 32'h11111111;
    always @ (*) begin
        if (rst == `RSToff) begin
            case (ALUcode)
                `ALU_PC4: begin
                    result <= data_1 + 4'h4;
                 end
                `ALU_LUI: begin
                    result <= {data_2[19:0],12'h000};
                end
                `ALU_AUIPC: begin
                    result <= data_1 + {data_2[19:0],12'h000};
                end
                `ALU_ADD: begin
                    result <= data_1 + data_2;
                end
                `ALU_SUB: begin
                    result <= data_1 + (~data_2 + 1);
                end
                `ALU_XOR: begin
                    result <= data_1 ^ data_2;
                end
                `ALU_OR: begin
                    result <= data_1 | data_2;
                end
                `ALU_AND: begin
                    result <= data_1 & data_2;
                end
                `ALU_SHIFT_L: begin
                    result <= data_1 << data_2[4:0];
                end
                `ALU_SHIFT_RL: begin
                    result <= data_1 >> data_2[4:0];
                end
                `ALU_SHIFT_RA: begin
                    if  (data_1[31] == 1'b1)  begin
                        result <= (data_1 >> data_2[4:0]);
                        for (addr = 0; addr<data_2[4:0]; addr = addr + 1)
                            result[31 - addr] <= 1;
                    end else begin
                        result <= (data_1 >> data_2[4:0]);
                    end
                end
                `ALU_SLT: begin
                    if (data_1[31] != data_2[31]) begin
                        result <= data_1[31] ? 32'h1 : 32'h0;
                    end else begin
                        result <= (data_1 < data_2) ? 32'h1 : 32'h0;
                    end
                end
                `ALU_SLTU: begin
                    result <= (data_1 < data_2) ? 32'h1 : 32'h0;
                end
                default: begin
                    result <= `SetZero;
                end
            endcase
        end else begin
            result <= `SetZero;
        end
    end
endmodule
