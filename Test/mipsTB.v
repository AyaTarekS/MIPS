`timescale 1ns / 1ps

module mipsTB();
reg clk ;
reg reset;
wire[31 : 0] wordIn;
//register file 
wire [4 : 0] write_reg_out;
wire [31 : 0] reg_result ;
//program memory 
wire [31 : 0] ProgramCounter ;
reg [31 : 0] address;
reg [31 : 0] inputinst;
//wire[31 : 0] instruction;
reg writeInst;

//instance of Mips design 
mips DUT(.clk(clk),
        .reset(reset),
        .write_data(reg_result),
        .wordIn(wordIn),
        .ProgramCounter(ProgramCounter),
        .write_reg(write_reg_out),
        .inputInstruction(inputinst),
        .writeInst(writeInst),
        .instAddress(address));
//clock generation
initial
clk = 0;
always
begin
#5 clk = ~clk;
end
//reset 
initial begin
reset <=1 ;
#100;
reset = 0;
#20;
end
initial 
#250 $stop ;
initial begin
//filling the program memory
//addi $t1 , $t0 , 10  
   writeInst <= 1;
   address <= 32'd 0;
   inputinst <= 32'h2128000A;
   #10;
// $t0(8) should have 10

//addi $t1 , $t1 , 2
   address <= 32'd 4;
   inputinst <= 32'h21290002;
   #10;
//$t1(9) should have 2

// add $t2 , $t1 , $t0
   address <= 32'd8;
   inputinst <= 32'b00000001000010010101000000000000;
   #10;
// $t1 = 2 , $t0 = 10 
//$t2(10) should have 12
   
// add $t0 , $t0 , $t0 
   address <= 32'd12;
   inputinst <= 32'h01084000;
   #10;
//$t0(8) should have 20

// sub $t3 , $t0 , $t2
   address <= 32'd16;
   inputinst <= 32'b00000001000010100101100000000001;
   #10;
// $t3 (11) should have 8

// SW $t3 , $t0(4)
   address <= 32'd20;
   inputinst <= 32'hAD0B0004;
   #10;
// in location 24 storing 8

// LW $t4 , $t0(4)
   address <= 32'd24;
   inputinst <= 32'b01001101000011000000000000000100;
   #10;
// $t4 (12) should have 8

// Beq $t3 , $t4 , 1
   address <= 32'd28;
   inputinst <=32'h116C0001;
   #10;
//they are equal so that will make the pc go to 36 
//Else: sub $t3 , $t3 , $t4
   address <= 32'd32;
   inputinst <=32'h016C5801;
   #10;
//add $t3 , $t3 ,$t4
   address <= 32'd36;
   inputinst <=32'h016C5800;
   #10;
   writeInst<= 0;
end
initial begin
   $monitor("Time =%0t , write_reg_out =%0d , reg_result=%0d ,wordIn =%0d , ProgramCounter =%0d", $time, write_reg_out, reg_result, wordIn, ProgramCounter);
end

































endmodule