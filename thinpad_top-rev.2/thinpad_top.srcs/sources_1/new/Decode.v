`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/28 08:49:58
// Design Name: 
// Module Name: Decode
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

module Decode(
    input wire                  clk,
    input wire                  rst,
    input wire                  Regwrite_i,
    input wire[`InstAddrBus]    pc,
    input wire[`InstBus]        inst,
    input wire[`RegBus]         write_data,
    input wire[`RegAddrBus]     write_reg,
    input wire                  MEMread_EXMEM,
    input wire                  Regwrite_MEM,
    input wire[4:0]             rd_MEM,
    input wire[31:0]            ALU_result,
    input wire                  clear_IDEX,

    output wire                 pc_write,
    output wire                 if_id_write,
    output wire                 if_flush,
    output wire[`InstAddrBus]   branch_pc,
    output wire                 Regwrite_o,
    output wire                 MEMread,
    output wire                 MEMwrite,
    output wire                 MEMtoReg,
    output wire[1:0]            ALUop,
    output wire                 ALUsrc,
    output wire[`RegBus]        read_data_1,
    output wire[`RegBus]        read_data_2,
    output wire[31:0]           imm_num,
    output wire[`RegAddrBus]    rs1,
    output wire[`RegAddrBus]    rs2,
    output wire[`RegAddrBus]    rd,
    output wire[4:0]            funct_o,
    output wire                 jump_o
);
    wire[`RegBus] read1, read2, imm_num_o;
    wire HDU_C;
    reg[19:0] imm;
    reg[4:0] funct;
    wire[1:0] ALUop_o;
    wire MEMread_o, MEMwrite_o, MEMtoReg_o, ALUsrc_o, Regwrite;
    
    always @ (*) begin
        if (inst[2:0] == 3'b111) begin
            funct = inst[6:2];
        end else begin
            funct = { inst[5],{inst[30], inst[14:12]}};
        end
    end

    always @ (*) begin
        if (inst[6:0] == 7'b0100011) begin                              // store 立即数扩展   11-7+1 = 5  31-25+1 = 7  12 + 8 = 20
            imm = {{8{inst[31]}},{inst[31:25], inst[11:7]}};
        end else if (inst[6:0] == 7'b1100011) begin                     // 跳转立即数扩展    11-8+1 = 4  30-25+1 = 6 1+1+10+8 = 20
            imm = {{8{inst[31]}},{inst[31],{inst[7],{inst[30:25], inst[11:8]}}}};
        end else if (inst[6:0] == 7'b0110111 || inst[6:0] == 7'b0010111) begin   // LUI AUIPC 立即数扩展 20
            imm = inst[31:12];
        end else if (inst[6:0] == 7'b1101111) begin                             //JAL立即数扩展  30-21+1 = 10 19-12+1 = 8  1+1+10+8 =20
            imm = {inst[31],{inst[19:12],{inst[20], inst[30:21]}}};
        end else begin                                                     // 12+8 = 20
            imm = {{8{inst[31]}},inst[31:20]};
        end
    end

    RegFile rf0(
        .rst(rst),
        .Regwrite(Regwrite_i), .rs1(inst[19:15]),
        .rs2(inst[24:20]), .rd(write_reg),
        .write_data(write_data), .read_1(read1),
        .read_2(read2) 
    );
    
    Imm_Gen ig0(
        .rst(rst), .imm_i(imm),.inst(inst[6:0]),
        .pc_now(pc), .imm_o(imm_num_o),
        .branch_pc(branch_pc)
    );
    wire rs1_c,rs2_c;
    wire[31:0] change1,change2;
    CHFU chf0(
       .rst(rst),
       .rs1(inst[19:15]),.rs2(inst[24:20]),
       .inst(inst[6:5]),
       .Regwrite_MEM(Regwrite_MEM),.rd_MEM(rd_MEM),.ALU_result(ALU_result),
       .Regwrite_WB(Regwrite_i),.rd_WB(write_reg),.write_data(write_data),
   
       .rs1_change(rs1_c),.rs2_change(rs2_c),
       .change1_data(change1),.change2_data(change2)
   );
    reg[31:0] read_f1,read_f2;
    always @ (*) begin
        read_f1 <= (rs1_c) ? change1 : read1;
        read_f2 <= (rs2_c) ? change2 : read2;
    end
    
    Compare comp0(
        .rst(rst),
        .option({inst[14:12],inst[6:2]}), .rs1(read_f1),
        .rs2(read_f2), .jump(jump_o)
    );
    
    Control cp0(
        .rst(rst),
        .inst(inst[6:0]),
        .jump(jump_o), .ALUop(ALUop_o),
        .ALUsrc(ALUsrc_o), .MEMwrite(MEMwrite_o),
        .MEMread(MEMread_o), .MEMtoReg(MEMtoReg_o),
        .Regwrite(Regwrite), .if_flush(if_flush)
    );
    
    HDU hdu0(
        .rst(rst),
        .rd(rd), .inst({inst[6:2],{inst[19:15],inst[24:20]}}),
        .MEMread_IDEX(MEMread),.MEMread_EXMEM(MEMread_EXMEM),.Regwrite_IDEX(Regwrite_o), .HDU_ct(HDU_C),
        .pc_write(pc_write), .if_id_write(if_id_write)
    );
    
    reg MEMwrite_f,MEMread_f,MEMtoReg_f,Regwrite_f,ALUsrc_f;
    reg[1:0] ALUop_f;
    always @ (*) begin
        if (HDU_C == `Truev) begin
            MEMwrite_f <= `Falsev;
            MEMread_f <= `Falsev;
            MEMtoReg_f <= `Falsev;
            ALUop_f <= 2'b00;
            ALUsrc_f <= `Falsev;
            Regwrite_f <= `Falsev;
        end else begin
            MEMwrite_f <=  MEMwrite_o;
            MEMread_f <=  MEMread_o;
            MEMtoReg_f <=  MEMtoReg_o;
            ALUop_f <= ALUop_o ;
            ALUsrc_f <= ALUsrc_o;
            Regwrite_f <= Regwrite;
        end
    end
   
    ID_EX ide0(
        .clk(clk), .rst(rst),
        .ALUop_i(ALUop_f),.pc(pc),
        .ALUsrc_i(ALUsrc_f), .MEMwrite_i(MEMwrite_f),
        .MEMread_i(MEMread_f), .MEMtoReg_i(MEMtoReg_f),
        .Regwrite_i(Regwrite_f), .rs1_i(inst[19:15]),
        .rs2_i(inst[24:20]), .rs1_data_i(read1),
        .rs2_data_i(read2), .rd_i(inst[11:7]),
        .imm_i(imm_num_o), .funct_i(funct),
        .ALUop_o(ALUop),
        .ALUsrc_o(ALUsrc), .MEMwrite_o(MEMwrite),
        .MEMread_o(MEMread), .MEMtoReg_o(MEMtoReg),
        .Regwrite_o(Regwrite_o),.rs1_o(rs1),
        .rs2_o(rs2), .rs1_data_o(read_data_1),
        .rs2_data_o(read_data_2), .rd_o(rd),
        .imm_o(imm_num), .funct_o(funct_o),.clear_IDEX(clear_IDEX)
    );
endmodule
