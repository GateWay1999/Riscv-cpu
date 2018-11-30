`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/28 16:51:00
// Design Name: 
// Module Name: Execute
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

module Execute(
    input wire clk,
    input wire rst,
    input wire[1:0] ALUop,
    input wire ALUsrc,
    input wire MEMread_i,
    input wire MEMwrite_i,
    input wire MEMtoReg_i,
    input wire Regwrite_i,
    input wire Regwrite_WB,
    input wire[`RegBus] read_data_1,
    input wire[`RegBus] read_data_2,
    input wire[`RegBus] read_data_1wb,
    input wire[`RegBus] read_data_2wb,
    input wire[31:0] imm_num,
    input wire[4:0] funct,
    input wire[`RegAddrBus] rs1,
    input wire[`RegAddrBus] rs2,
    input wire[`RegAddrBus] rd_i,
    input wire[`RegAddrBus] rd_WB,
    input wire SPC_i,
        
    output wire stop_pc,
    output wire stop_IFID,
    output wire clear_IDEX,
    output wire SPC,
    output wire MEMread_o,
    output wire MEMwrite_o,
    output wire MEMtoReg_o,
    output wire Regwrite_o,
    output wire[`RegBus] result,
    output wire[`RegBus] store_data,
    output wire[`RegAddrBus] rd_o,
    output wire[4:0] funct_o
);
    wire[1:0] fu_a,fu_b;
    wire[3:0] ALUcode;
    wire[31:0] result_o;
    wire SPC_o;
    reg[31:0] input_1,input_2, final_2;
    FU fu0(
        .rst(rst), .rs1(rs1), .rs2(rs2),.ALUop(ALUop), .funct(funct),
        .Regwrite_MEM(Regwrite_o), .rd_MEM(rd_o),
        .Regwrite_WB(Regwrite_WB), .rd_WB(rd_WB),
        .FU_A(fu_a), .FU_B(fu_b)
    );
    
    always @ (*) begin
        case (fu_a)
            `EXMEM: begin
                input_1 <= result;
            end
            `MEMWB: begin
                input_1 <= read_data_1wb;
            end
            default: begin
                input_1 <= read_data_1;
            end
        endcase
    end
    
    always @ (*) begin
        case (fu_b)
            `EXMEM: begin
                input_2 <= result;
            end
            `MEMWB: begin
                input_2 <= read_data_2wb;
            end
            default: begin
                input_2 <= read_data_2;
            end
        endcase
    end
    
    always @ (*) begin
        case (ALUsrc)
            `RegSrc: begin
                final_2 <= input_2;
            end
            `ImmSrc: begin
                final_2 <= imm_num;
            end
            default: begin
                final_2 <= input_2;
            end
        endcase
    end
    
    ALU alu0(
        .rst(rst), .ALUcode(ALUcode),
        .data_1(input_1), .data_2(final_2),
        .result(result_o)
    );
    
    SCU scu0(
        .rst(rst),
        .ALU_result(result_o),
        .funct(funct),
        .MEMread(MEMread_i),
        .MEMwrite(MEMwrite_i),
        .SPC_i(SPC_i),
        
        .stop_pc(stop_pc),
        .stop_IFID(stop_IFID),
        .clear_IDEX(clear_IDEX),
        .SPC_o(SPC_o)
    );
    
    ALU_Control ac0(
        .rst(rst), .funct(funct), .ALUop(ALUop), .ALUcode(ALUcode)
    );
    
    EX_MEM em0(
        .clk(clk), .rst(rst),
        .result(result_o), .store_data(input_2),.funct(funct),.SPC_i(SPC_o),
        .rd(rd_i), .MEMwrite(MEMwrite_i),.MEMread(MEMread_i),.MEMtoReg(MEMtoReg_i),.Regwrite(Regwrite_i),
        .result_o(result), .store_data_o(store_data),.funct_o(funct_o),.SPC_o(SPC),
        .rd_o(rd_o), .MEMwrite_o(MEMwrite_o),.MEMread_o(MEMread_o),.MEMtoReg_o(MEMtoReg_o),.Regwrite_o(Regwrite_o)
    );
endmodule
