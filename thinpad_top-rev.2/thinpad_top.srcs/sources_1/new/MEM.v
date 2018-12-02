`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/28 21:57:05
// Design Name: 
// Module Name: MEM
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

module MEM(
    input wire clk,
    input wire clk2,
    input wire rst,
    input wire MEMtoReg,
    input wire Regwrite,
    input wire MEMwrite,
    input wire MEMread,
    input wire[31:0] store_data,
    input wire[31:0] ALU_result,
    input wire[4:0] rd_i,
    input wire[4:0] funct,
    input wire SPC_i,
    inout wire[31:0] base_ram_data,
    input wire uart_dataready,    //串口数据准备好
    input wire uart_tbre,         //发送数据标志
    input wire uart_tsre,         //数据发送完毕标志

    output wire uart_rdn,         //读串口信号，低有效
    output wire uart_wrn,         //写串口信号，低有效  
    output wire SPC_o,    
    output wire[19:0] base_ram_addr,
    output wire[3:0] base_ram_be_n,
    output reg base_ram_ce_n,
    output wire base_ram_oe_n,
    output wire base_ram_we_n,
    output wire MEMtoReg_o,
    output wire Regwrite_o,
    output wire[31:0] load_data_o,
    output wire[31:0] ALU_result_o,
    output wire[4:0] rd_o,
    output wire[15:0] leds
);
    reg[31:0] load_data;
    wire[31:0] memload;
    reg memread;
    reg memwrite;
    reg tcread;
    reg tcwrite;
    always @ (*) begin
        if (SPC_i == `Truev) begin
            base_ram_ce_n <= `Highv;
            memread <= `Falsev;
            memwrite <= `Falsev;
            tcread <= MEMread;
            tcwrite <= MEMwrite;
        end else begin
            if (ALU_result == `PORTstatus) begin
                base_ram_ce_n <= `Highv;
                memread <= `Falsev;
                memwrite <= `Falsev; 
                tcread <= `Falsev;
                tcwrite <= `Falsev;
            end else begin
                base_ram_ce_n <= `Lowv;
                memread <= MEMread;
                memwrite <= MEMwrite; 
                tcread <= `Falsev;
                tcwrite <= `Falsev;
            end
        end
    end
 
    Data_Mem dm0(
        .clk(clk),
        .rst(rst),
        .funct(funct),
        .ac_addr(ALU_result),
        .store_data(store_data),
        .MEMwrite(memwrite),
        .MEMread(memread),
        .load_data(memload),
        .base_ram_data(base_ram_data),
        .base_ram_addr(base_ram_addr),
        .base_ram_be_n(base_ram_be_n),      
        .base_ram_oe_n(base_ram_oe_n),      
        .base_ram_we_n(base_ram_we_n)
    );
    
    wire[7:0] read_data;
    
    TC tc0(
        .clk(clk2),
        .rst(rst),
        .SPC(SPC_i),
        .MEMwrite(tcwrite),
        .MEMread(tcread),
        .tbre(uart_tbre),
        .tsre(uart_tsre),
        .send_data(store_data[7:0]),
        .data_ready(uart_dataready),
        .base_ram_data(base_ram_data),                 
        .uart_wrn(uart_wrn),
        .uart_rdn(uart_rdn),
        .read_data(read_data[7:0]),
        .SPC_o(SPC_o),
        .leds(leds)
    );
    
    always @ (*) begin
        if (ALU_result == `PORTstatus) begin
            load_data <= {30'h0 , {uart_dataready,uart_tsre}};
        end else begin
            load_data <= (SPC_i) ? { 24'h000000 ,read_data[7:0]} : memload;
        end
    end
    
    MEM_WB mw0(
        .clk(clk), .rst(rst),
        .MEMtoReg_i(MEMtoReg), .Regwrite_i(Regwrite),
        .load_data_i(load_data),.ALU_result_i(ALU_result),.stop_MEMWB(SPC_o),
        .rd_i(rd_i),.MEMtoReg_o(MEMtoReg_o),
        .Regwrite_o(Regwrite_o),.load_data_o(load_data_o),
        .ALU_result_o(ALU_result_o),.rd_o(rd_o)
    );
endmodule
