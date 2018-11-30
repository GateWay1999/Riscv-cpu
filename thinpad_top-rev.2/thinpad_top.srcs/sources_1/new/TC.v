`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/30 20:56:47
// Design Name: 
// Module Name: TC
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


module TC(
    input wire clk,
    input wire port_status,
    input wire SPC,
    input wire tbre,
    input wire tsre,
    input wire data_ready,
    input wire MEMwrite,
    input wire MEMread,
    input wire[31:0] base_ram_i,            // ¶Á´®¿Ú
    output reg[31:0] base_ram_o,           // Ð´´®¿Ú
    output reg base_ram_ce_n,
    output reg uart_wrn,
    output reg uart_rdn,
    output reg SPC_o
);
    always @ (posedge clk) begin
        if(SPC == `Truev) begin
            if (MEMwrite) begin
                base_ram_ce_n <= 1'b1;
                uart_wrn <= 1'b0;
            end else if (MEMread) begin
                uart_rdn <= 1'b1;
            end
        end
    end
    
    always @ (posedge clk) begin
        if (uart_wrn == 1'b0) begin
            uart_wrn <= 1'b1;
        end else if (uart_rdn <= 1'b0) begin
            uart_rdn <= 1'b1;
        end
    end
    
    always @ (posedge clk) begin
        if (data_ready == 1'b1) begin
            uart_rdn <= 1'b0;
            SPC_o <= `Falsev;
        end
    end

    always @ (tsre) begin
        if (tbre == 1'b1) begin
            SPC_o <= `Falsev;
        end
    end
endmodule
