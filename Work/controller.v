//controller for Mips processor 
//inputs OPcode , zero flag
//can be extended to have the basic instructions of ISA MIPS2000
module controller(
    input wire [5 : 0] OPcode,
    input wire Zero,
    output wire RegDst,
    output wire Jumb,
    output wire Branch,
    output wire MemRead,
    output wire MemtoReg,
    output wire [1 : 0] ALUOp,
    output wire MemWrite, 
    output wire ALUSrc,
    output wire RegWrite
);
assign Branch = (OPcode == 6'b000101 || OPcode == 6'b000100)? 1 : 0 ;
assign MemWrite = (OPcode == 6'b101011)? 1 : 0; 
assign Jumb = 0;
assign RegDst = (OPcode == 6'b000000)? 1 : 0;
assign RegWrite =(OPcode == 6'b000000 || OPcode == 6'b010011 || OPcode == 6'b001000)? 1 : 0;
assign MemRead = (OPcode == 6'b010011)? 1 : 0;
assign ALUSrc = (OPcode == 6'b010011 || OPcode == 6'b101011 || OPcode == 6'b001000);
assign ALUOp = (OPcode == 6'b000000)? 2'b10 :
 (OPcode == 6'b010011 || OPcode == 6'b101011 || OPcode == 6'b001000)? 2'b00 : 2'b01 ;
assign MemtoReg = (OPcode == 6'b010011)? 1 : 0;
endmodule
//OPcode for R format 000000
//OPcode for addi     001000
//OPcode for LW       010011
//OPcode for SW       101011
//OPcode for Beq      000100
//OPcode for Bnq      000101
