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
    input wire SPC,
    input wire tbre,
    input wire tsre,
    input wire data_ready,
    input wire MEMwrite,
    input wire MEMread,
    inout wire[31:0] base_ram_data,            // 读串口
    input wire[7:0] send_data,
    output reg[7:0] read_data,
    output wire base_ram_ce_n,               // 不能与内存同时控制
    output reg uart_wrn,
    output reg uart_rdn,
    output wire base_ram_oe_n,
    output wire base_ram_we_n,
    output reg SPC_o
);
    reg[31:0] base_ram_o;
    assign base_ram_data = (MEMwrite) ? base_ram_o : 32'hZZZZZZZZ;
    reg[2:0] reading = `statu0;
    reg[2:0] writing = `statu0;
    assign base_ram_ce_n = 1'b1;
    assign base_ram_oe_n = 1'b1;
    assign base_ram_we_n = 1'b1;
    always @ (posedge clk) begin
        if(SPC == `Truev) begin
            if(MEMread) begin                       // 接受
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
            end else if (MEMwrite) begin            // 发送
                uart_rdn <= 1'b1;
                case (writing)
                    `statu0: begin
                        uart_wrn <= 1'b0;
                        base_ram_o[7:0] <= send_data;
                        writing <= `statu1;
                    end
                    `statu1: begin
                        uart_wrn <= 1'b1;
                        writing <= `statu2;
                    end
                    `statu2: begin
                        if (tbre == 1'b1) begin
                            writing <= `statu3;
                        end
                    end
                    `statu3: begin
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
    end
endmodule
