`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/28 21:57:36
// Design Name: 
// Module Name: WB
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


module WB(
    input wire MEMtoReg,
    input wire[31:0] load_data,
    input wire[31:0] ALU_result,
    output wire[31:0] write_data
);
    assign write_data = MEMtoReg ? load_data : ALU_result;
endmodule
