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
    input wire[31:0] ac_addr,               // 32位要访问的地�?
    input wire[31:0] store_data,            //  32位要存储的数�?
    input wire MEMwrite,                    // 写使�?
    input wire MEMread,                     // 读使�?
    /* funct �? [2:0] 用来分辨访问方式
        OB      3'b000      读取或存�? 8�?  读取的话做符号扩展到32�?  存入不用扩展直接存入对应位数
        OH      3'b001      读取或存�? 16�? 读取的话做符号扩展到32�?  存入不用扩展直接存入对应位数
        OW      3'b010      读取或存�? 32�? 存入不用扩展直接存入对应位数
        LBU     3'b011      读取 �?个字�? 做零扩展�?32�?
        LHU     3'b100      读取 两个字节 做零扩展�?32�?
    */
    input wire[4:0] funct,
    inout wire[31:0] base_ram_data,
        
    output reg [19:0] base_ram_addr,
    output reg [3:0] base_ram_be_n,
    output reg base_ram_oe_n,
    output reg base_ram_we_n,
    output reg [31:0] load_data
);

    reg[31:0] temp_ram_data = 32'b00000000000000000000000000000000;
    reg is_write = `Falsev;
    
    
    
    //assign base_ram_data = (is_write == `Truev) ? temp_ram_data : 32'bz;
    assign base_ram_data[31:0] = (is_write == `Truev) ? store_data[31:0] : 32'bz;
    
    always @ (*) begin
        if(MEMwrite == `Truev) begin
            is_write <= `Truev;
            
        end
        else begin
            is_write <= `Falsev;
        end
    end
    
    
    
    always @ (*) begin
        if (MEMread == `Truev) begin //�?
            //base_ram_ce_n <= `Lowv;//片�?�低
            base_ram_oe_n <= `Lowv;//读使能低
            //base_ram_we_n <= `Highv;//写使能高
            base_ram_addr <= ac_addr[21:2];//赋地�?
            base_ram_be_n <= 4'b0000;//REM字节使能四位都低
        end
        else if (MEMwrite == `Truev) begin //�?
            //base_ram_ce_n <= `Lowv;//片�?�低
            base_ram_oe_n <= `Highv;//读使能高
            //base_ram_we_n <= `Lowv;//写使能低
            base_ram_addr <= ac_addr[21:2];//赋地�?
            //下面确定 base_ram_be_n四位的�??
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
        else begin //不读也不写，访存不工�? 
             //base_ram_ce_n <= `Highv;//片�?�高
             base_ram_oe_n <= `Highv;//读使能高
             //base_ram_we_n <= `Highv;//写使能高
        end
    end
     
    always @ (*) begin 
        if(MEMwrite == `Truev) begin //如果是写
            //temp_ram_data <= store_data;
            base_ram_we_n <= clk;//写使能看clk
        end
        else begin
            base_ram_we_n <= `Highv;
        end
        
    end
 
    always @ (*) begin //�?
        if(MEMread == `Truev) begin
            //is_write <= `Falsev;
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
                    //base_ram_addr <= ac_addr[21:2];
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
    
    //assign load_data = `SetZero + 1;
endmodule
