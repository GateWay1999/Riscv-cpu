`timescale 1ns / 1ps

`include "define.v"

module Data_Mem(
    input wire clk,
    input wire rst,
    input wire[31:0] ac_addr,              
    input wire[31:0] store_data,            
    input wire MEMwrite,                    
    input wire MEMread,                     
    /* 
        OB      3'b000      
        OH      3'b001      
        OW      3'b010      
        LBU     3'b011      
        LHU     3'b100 
    */
    input wire[4:0] funct,
    inout wire[31:0] base_ram_data,
        
    output reg [19:0] base_ram_addr,
    output reg [3:0] base_ram_be_n,
    output reg base_ram_oe_n,
    output reg base_ram_we_n,
    output reg [31:0] load_data
);

    reg[31:0] temp_ram_data = 32'hzzzzzzzz;
      
    assign base_ram_data[31:0] = (MEMwrite == `Truev) ? temp_ram_data : 32'hzzzzzzzz;
    
    always @ (*) begin
        if (MEMread == `Truev) begin //读
            base_ram_oe_n <= `Lowv;//读使能置低
            base_ram_we_n <= `Highv;//写使能置高
            base_ram_addr <= ac_addr[21:2];//赋地址
            base_ram_be_n <= 4'b0000;//字节使能全部置低
            temp_ram_data <= 32'hzzzzzzzz;//写寄存器置高阻态
            //读取总线上的数据
            case(funct[2:0])
                `OB : begin
                    case(ac_addr[1:0])
                        2'b00 : begin
                            load_data <= {{24{base_ram_data[7]}}, base_ram_data[7:0]};
                        end
                        2'b01: begin
                            load_data <= {{24{base_ram_data[15]}},base_ram_data[15:8]};
                        end
                        2'b10: begin
                            load_data <= {{24{base_ram_data[23]}},base_ram_data[23:16]};
                        end
                        2'b11: begin
                            load_data <= {{24{base_ram_data[31]}},base_ram_data[31:24]};
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
                default : begin
                    load_data <= 32'hzzzzzzzz;
                end
            endcase
        end
              
        else if (MEMwrite == `Truev) begin //写
            base_ram_oe_n <= `Highv;//读使能置高
            base_ram_we_n <= clk;//写使能置为时钟信号
            base_ram_addr <= ac_addr[21:2];//赋地址
            load_data <= 32'hzzzzzzzz;//读寄存器置高阻态
            //下面确定字节使能并传入写入数据
            case(funct[2:0])
                `OB : begin
                    base_ram_be_n <= {(~ac_addr[1])|(~ac_addr[0]), (~ac_addr[1])|(ac_addr[0]), (ac_addr[1])|(~ac_addr[0]), (ac_addr[1])|(ac_addr[0])};
                    temp_ram_data <= { base_ram_data[7:0],  base_ram_data[7:0],  base_ram_data[7:0], base_ram_data[7:0]};
                end
                `OH : begin
                    base_ram_be_n <= {(~ac_addr[1]), (~ac_addr[1]),(ac_addr[1]),(ac_addr[1])};
                    temp_ram_data <= { base_ram_data[15:0],  base_ram_data[15:0]};
                end
                `OW : begin
                    base_ram_be_n <= 4'b0000;
                    temp_ram_data <= store_data;
                end
                default : begin 
                    base_ram_be_n <= 4'b1111;
                    temp_ram_data <= 32'hzzzzzzzz;
                end
            endcase
        end
        
        else begin //不读也不写
             base_ram_oe_n <= `Highv;//读使能置高
             base_ram_we_n <= `Highv;//写使能置高
             base_ram_be_n <= 4'b1111;//字节使能置高
             load_data <= 32'hzzzzzzzz;//读寄存器置高阻
             temp_ram_data <= 32'hzzzzzzzz;//写寄存器置高阻
        end
    end
    
endmodule
