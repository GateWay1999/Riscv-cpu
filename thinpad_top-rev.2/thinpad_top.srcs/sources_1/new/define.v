`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/27 23:10:56
// Design Name: 
// Module Name: define
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
// 0向量
`define SetZero         32'h00000000
// 复位信号
`define RSTon           1'b1
`define RSToff          1'b0
// 跳转控制
`define TakeBranch      1'b1
`define NotTake         1'b0
//  真假
`define Truev           1'b1
`define Falsev          1'b0
//  ALUsrc
`define RegSrc          1'b0
`define ImmSrc          1'b1
// 读写控制
`define WriteEnable     1'b1
`define WriteDisable    1'b0
// 基础位宽定义
`define InstAddrBus     31:0
`define InstBus         31:0
// Instruction Memory Size
`define InstMemNum      131071
`define InstMemNumLog2  17
// 寄存器基础
`define RegAddrBus      4:0
`define RegBus          31:0
// ALU操作码
`define ALU_NOP         4'b0000
`define ALU_ADD         4'b0001
`define ALU_SUB         4'b0010
`define ALU_AND         4'b0011
`define ALU_OR          4'b0100
`define ALU_XOR         4'b0101
`define ALU_SHIFT_L     4'b0110
`define ALU_SHIFT_RL    4'b0111
`define ALU_SHIFT_RA    4'b1000
`define ALU_SLT         4'b1001
`define ALU_SLTU        4'b1010
`define ALU_PC4         4'b1011
`define ALU_LUI         4'b1100
`define ALU_AUIPC       4'b1101
// ALU控制码--ALUop
`define ALU_N           2'b00
`define ALU_A           2'b01
`define ALU_M           2'b10
`define ALU_J           2'b11
// Forwarding Unit
`define IDEX            2'b00
`define EXMEM           2'b10
`define MEMWB           2'b01
// 跳转指令
`define BEQ             3'b000
`define BNE             3'b001
`define BLT             3'b100
`define BGE             3'b101
`define BLTU            3'b110
`define BGEU            3'b111
`define JAL             3'b011
`define JALR            3'b001
// 访存控制 DMop
`define OB              3'b000
`define OH              3'b001
`define OW              3'b010
`define LBU             3'b011
`define LHU             3'b100
// 串行端口定义
`define PORTsend        1'h0
`define PORTrecv        1'h1
`define PORTaddr        20'hfffff