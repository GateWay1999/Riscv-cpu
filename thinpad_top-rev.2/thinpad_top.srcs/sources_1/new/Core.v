`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/29 08:49:38
// Design Name: 
// Module Name: Core
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

module Core(
    input wire CLOCK_50,
    input wire rst,
    inout wire[31:0] base_ram_data,
    input wire uart_dataready,    //串口数据准备好
    input wire uart_tbre,         //发送数据标志
    input wire uart_tsre,         //数据发送完毕标志
    
    output wire uart_rdn,         //读串口信号，低有效
    output wire uart_wrn,         //写串口信号，低有效
    output wire[19:0] base_ram_addr,
    output wire[3:0] base_ram_be_n,
    output wire base_ram_ce_n,
    output wire base_ram_oe_n,
    output wire base_ram_we_n
);
    // IF-ID
    wire if_flush, ifid_write,pc_write,pc_select;
    wire[31:0] pc_branch,pc, instruction;
    // ID-EX MEM-ID WB-ID
    wire Regwrite,MEMread,MEMwrite,MEMtoReg,ALUsrc,Regwrite_MEM_WBtoID;
    wire[1:0] ALUop;
    wire[31:0] read_reg_1,read_reg_2,imm_num,write_data;
    wire[`RegAddrBus] rs1,rs2,rd,write_reg;
    wire[4:0] funct;
    // EX-MEM
    wire Regwrite_EX,MEMread_EX,MEMwrite_EX,MEMtoReg_EX;
    wire[4:0] funct_EX;
    wire[31:0] result, store_data;
    wire[`RegAddrBus] rd_EX;
    wire SPC_i;
    wire stop_pc;
    wire stop_IFID;
    wire clear_IDEX;
    wire SPC_o;
    wire stop_MEMWB;
    // MEM-WB
    wire MEMtoReg_MEM;
    wire[31:0] load_data,ALU_result;
    Fetch fh0(
        .clk(CLOCK_50), .rst(rst),.if_flush(if_flush),.ifid_write(ifid_write),
        .pc_write_i(pc_write),.pc_select_i(pc_select),.pc_branch_i(pc_branch), .stop_pc(stop_pc),.stop_IFID(stop_IFID),
        // 输出
        .pc(pc), .inst_data(instruction)
    );
    
    Decode dc0(
        .clk(CLOCK_50),.rst(rst),
        .pc(pc),.inst(instruction),
        .Regwrite_i(Regwrite_MEM_WBtoID),.write_data(write_data),.write_reg(write_reg),.MEMread_EXMEM(MEMread_EX),
        .Regwrite_MEM(Regwrite_EX),.rd_MEM(rd_EX),.ALU_result(result),.clear_IDEX(clear_IDEX),
        // 输出
        .pc_write(pc_write),.if_id_write(ifid_write),.if_flush(if_flush),.branch_pc(pc_branch),
        .Regwrite_o(Regwrite),.MEMread(MEMread),
        .MEMwrite(MEMwrite),.MEMtoReg(MEMtoReg),.ALUop(ALUop),
        .ALUsrc(ALUsrc),.read_data_1(read_reg_1),
        .read_data_2(read_reg_2),.imm_num(imm_num),
        .rs1(rs1),.rs2(rs2),
        .rd(rd),.funct_o(funct),.jump_o(pc_select)
    );
    
    Execute ex0(
        .clk(CLOCK_50),.rst(rst),
        .ALUop(ALUop),.ALUsrc(ALUsrc),
        .MEMread_i(MEMread),.MEMwrite_i(MEMwrite),
        .MEMtoReg_i(MEMtoReg),.Regwrite_i(Regwrite),
        .Regwrite_WB(Regwrite_MEM_WBtoID),
        .read_data_1(read_reg_1), .read_data_2(read_reg_1),
        .imm_num(imm_num),.funct(funct),
        .rs1(rs1),.rs2(rs2),
        .rd_i(rd),.rd_WB(write_reg),
        .read_data_1wb(write_data),.read_data_2wb(write_data),
        .SPC_i(SPC_i),
                
        .stop_pc(stop_pc),
        .stop_IFID(stop_IFID),
        .clear_IDEX(clear_IDEX),
        .stop_MEMWB(stop_MEMWB),
        .SPC(SPC_o),
        .MEMread_o(MEMread_EX),.MEMwrite_o(MEMwrite_EX),
        .MEMtoReg_o(MEMtoReg_EX),.Regwrite_o(Regwrite_EX),
        .result(result),.store_data(store_data),
        .rd_o(rd_EX),.funct_o(funct_EX)
    );
    
    MEM mem0(
        .clk(CLOCK_50), .rst(rst),.funct(funct_EX),.stop_MEMWB(stop_MEMWB),
        .MEMtoReg(MEMtoReg_EX),.Regwrite(Regwrite_EX),
        .MEMwrite(MEMwrite_EX),.MEMread(MEMread_EX),
        .store_data(store_data),.ALU_result(result),
        .rd_i(rd_EX),.base_ram_data(base_ram_data),
        .base_ram_addr(base_ram_addr),.SPC_i(SPC_o),
        .base_ram_be_n(base_ram_be_n),  
        .base_ram_ce_n(base_ram_ce_n),       
        .base_ram_oe_n(base_ram_oe_n),      
        .base_ram_we_n(base_ram_we_n),
        .uart_dataready(uart_dataready),
        .uart_tbre(uart_tbre),
        .uart_tsre(uart_tsre),
            
        .uart_rdn(uart_rdn),
        .uart_wrn(uart_wrn),
        .MEMtoReg_o(MEMtoReg_MEM),.Regwrite_o(Regwrite_MEM_WBtoID),
        .load_data_o(load_data),.ALU_result_o(ALU_result),
        .rd_o(write_reg),.SPC_o(SPC_i)
    );
    
    WB wb0(
        .MEMtoReg(MEMtoReg_MEM),.load_data(load_data),.ALU_result(ALU_result),
        // 输出
        .write_data(write_data)
    );
endmodule
