`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/28 21:56:50
// Design Name: 
// Module Name: Data_Mem
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

module Data_Mem(
    input wire clk,
    input wire rst,
    input wire[31:0] ac_addr,               // 32位要访问的地址
    input wire[31:0] store_data,            //  32位要存储的数据
    input wire MEMwrite,                    // 写使能
    input wire MEMread,                     // 读使能
    /* funct 的 [2:0] 用来分辨访问方式
        OB      3'b000      读取或存入 8位  读取的话做符号扩展到32位  存入不用扩展直接存入对应位数
        OH      3'b001      读取或存入 16位 读取的话做符号扩展到32位  存入不用扩展直接存入对应位数
        OW      3'b010      读取或存入 32位 存入不用扩展直接存入对应位数
        LBU     3'b011      读取 一个字节 做零扩展到32位
        LHU     3'b100      读取 两个字节 做零扩展到32位
    */
    input wire[4:0] funct,
    inout wire[31:0] base_ram_data,
        
    output wire[19:0] base_ram_addr,
    output wire[3:0] base_ram_be_n,
    output wire base_ram_ce_n,
    output wire base_ram_oe_n,
    output wire base_ram_we_n,
    output wire[31:0] load_data
);

    reg[31:0] temp_ram_data;
    reg is_write = `Falsev;
    
    assign base_ram_data = (is_write == `Truev) ? temp_ram_data : 32'bz;
    
    always @ (*) begin
        if(MEMwrite == `Truev)
            is_write <= `Truev;
        else
            is_write <= `Falsev;
    end
    
    always @ (*) begin
        if (MEMread == `Truev) begin //读
            base_ram_ce_n <= `Lowv;//片选低
            base_ram_oe_n <= `Lowv;//读使能低
            base_ram_we_n <= `Highv;//写使能高
            base_ram_addr <= ac_addr[21:2];//赋地址
            base_ram_be_n <= 4'b0000;//REM字节使能四位都低
        end
        else if (MEMwrite == `Truev) begin //写
            base_ram_ce_n <= `Lowv;//片选低
            base_ram_oe_n <= `Highv;//读使能高
            base_ram_we_n <= `Lowv;//写使能低
            base_ram_addr <= ac_addr[21:2];//赋地址
            //下面确定 base_ram_be_n四位的值
            case(funct)
                `OB : begin
                    base_ram_be_n <= {(~ac_addr[1])|(~ac_addr[0]), (~ac_addr[1])|(ac_addr[0]), (ac_addr[1])|(~ac_addr[0]), (ac_addr[1])|(ac_addr[0])};
                end
                `OH : begin
                    base_ram_be_n <= {(~ac_addr[1]), (~ac_addr[1]),(ac_addr[1]),(ac_addr[1])};
                end
                `OW : begin
                    base_ram_be_n <= 4'b0000;
                end
                default : begin 
                    base_ram_be_n <= 4'b1111;
                end
            endcase
        end
        else begin //不读也不写，访存不工作 
             base_ram_ce_n <= `Highv;//片选高
             base_ram_oe_n <= `Highv;//读使能高
             base_ram_we_n <= `Highv;//写使能高
        end
    end
     
    always @ (negedge clk) begin //下降沿开始写
        if(MEMwrite == `Truev) begin //如果是写
            is_write <= `Truev;
            temp_ram_data <= store_data;
        end
    end
 
    always @ (*) begin //读
        if(MEMread == `Truev) begin
            is_write <= `Falsev;
            case(funct)
                `OB : begin
                    case(ac_addr[1:0])
                        2'b00 : begin
                            load_data <= {{24{base_ram_data[7]}}, base_ram_data[7:0]};
                        end
                        2'b01: begin
                            load_data <= {{24{base_ram_data[15]}}, base_ram_data[15:8]};
                        end
                        2'b10: begin
                            load_data <= {{24{base_ram_data[23]}}, base_ram_data[23:16]};
                        end
                        2'b11: begin
                            load_data <= {{24{base_ram_data[31]}}, base_ram_data[31:24]};
                        end
                    endcase
                end
                `OH : begin
                    if(ac_addr[1] == 1'b0) begin
                        load_data <= {{16{base_ram_data[15]}}, base_ram_data[15:0]};
                    end
                    else begin
                        load_data <= {{16{base_ram_data[31]}}, base_ram_data[31:16]};
                    end
                end
                `OW : begin
                    base_ram_addr = ac_addr[21:2];
                    load_data <= base_ram_data;
                end
                `LBU : begin
                    case (ac_addr[1:0])
                        2'b00 : begin
                            load_data <= {24'b0, base_ram_data[7:0]};
                        end
                        2'b01 : begin
                            load_data <= {24'b0, base_ram_data[15:8]};
                        end
                        2'b10 : begin
                            load_data <= {24'b0, base_ram_data[23:16]};
                        end
                        2'b11 : begin
                            load_data <= {24'b0, base_ram_data[31:24]};
                        end
                    endcase
                end
                `LHU : begin
                    if(ac_addr[1] == 1'b0) begin
                        load_data <= {16'b0, base_ram_data[15:0]};
                    end
                    else begin
                        load_data <= {16'b0, base_ram_data[31:16]};
                    end
                end
            endcase
        end
    end
    
endmodule
