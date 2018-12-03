`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/28 08:45:23
// Design Name: 
// Module Name: HDU
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


module HDU(
    input wire              rst,
    input wire[`RegAddrBus] rd,
    input wire[14:0]        inst,
    input wire              MEMread_IDEX,
    input wire              MEMread_EXMEM,
    input wire              Regwrite_IDEX,
    
    output reg             HDU_ct,
    output reg             pc_write,
    output reg             if_id_write
);
    always @ (*) begin
        if (rst == `RSToff) begin
            if ((MEMread_IDEX == `Truev) && ((rd == inst[4:0]) || (rd == inst[9:5]))) begin
                HDU_ct <= `Truev;
                pc_write<= `WriteDisable;
                if_id_write<= `WriteDisable;
            end else if((MEMread_EXMEM == `Truev)&& ( inst[14:10] == 5'b11000 ||  inst[14:10] == 5'b11001) && ((rd == inst[4:0]) || (rd == inst[9:5]))) begin
                HDU_ct <= `Truev;
                pc_write<= `WriteDisable;
                if_id_write<= `WriteDisable;
            end else if((Regwrite_IDEX == `Truev)&& ( inst[14:10] == 5'b11000 ||  inst[14:10] == 5'b11001) && ((rd == inst[4:0]) || (rd == inst[9:5]))) begin
                HDU_ct <= `Truev;
                pc_write<= `WriteDisable;
                if_id_write<= `WriteDisable;
            end else begin
                HDU_ct <= `Falsev;
                pc_write<= `WriteEnable;
                if_id_write<= `WriteEnable;
            end
        end else begin
            HDU_ct <= `Falsev;
            pc_write<= `WriteDisable;
            if_id_write<= `WriteDisable;
        end
    end
endmodule
