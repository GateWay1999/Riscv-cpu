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
`include "define.v"

module TC(
    input wire clk,
    input wire rst,
    input wire SPC,
    input wire tbre,
    input wire tsre,
    input wire data_ready,
    input wire MEMwrite,
    input wire MEMread,
    inout wire[31:0] base_ram_data,            // ������
    input wire[7:0] send_data,
    output reg[7:0] read_data,
    output reg uart_wrn,
    output reg uart_rdn,
    output reg SPC_o,
    output reg[15:0] leds
);
    reg[31:0] base_ram_o;
    assign base_ram_data = (MEMwrite) ? base_ram_o : 32'hZZZZZZZZ;
    reg[2:0] reading = `statu0;
    reg[2:0] writing = `statu0;
    always @ (posedge clk) begin
        if (rst == `RSToff) begin
            if(SPC == `Truev) begin
                SPC_o <= `Truev;
                if(MEMread) begin                       // ����
                    uart_wrn <= 1'b1;
                    case (reading)
                        `statu0: begin
                             uart_rdn <= 1'b1;
                             reading <= `statu1;
                        end
                        `statu1: begin
                            if (data_ready) begin
                                uart_rdn <= 0;
                                reading <= `statu2;
                            end else begin
                                reading <= `statu1;
                            end
                        end
                        `statu2: begin
                            read_data <= base_ram_data[7:0];
                            uart_rdn <= 1;
                            reading <= `statu0;
                            SPC_o <= `Falsev;
                        end
                        default: begin
                            uart_rdn <= 1'b1;
                            read_data <= 8'h00;
                            reading <= `statu0;
                        end
                    endcase
                end else if (MEMwrite) begin            // ����
                    leds <= 16'h0111;
                    uart_rdn <= 1'b1;
                    case (writing)
                        `statu0: begin
                            base_ram_o[7:0] <= send_data;
                            writing <= `statu1;
                        end
                        `statu1: begin
                            uart_wrn <= 1'b0;
                            writing <= `statu2;
                        end
                        `statu2: begin
                            uart_wrn <= 1'b1;
                            writing <= `statu3;
                        end
                        `statu3: begin
                            if (tbre == 1'b1) begin
                                writing <= `statu4;
                            end
                        end
                        `statu4: begin
                            if (tsre == 1'b1) begin
                                uart_wrn <= 1'b1;
                                SPC_o <= `Falsev;
                                writing <= `statu0;
                            end
                        end
                        default: begin
                            uart_wrn <= 1'b1;
                            writing <= `statu0;
                        end
                    endcase
                end
            end else begin
                uart_wrn <= 1'b1;
                uart_rdn <= 1'b1;
                SPC_o <= `Falsev;
            end
        end else begin
            uart_wrn <= 1'b1;
            uart_rdn <= 1'b1;
            SPC_o <= `Falsev;
            read_data <= 8'h00;
        end
    end 
endmodule
