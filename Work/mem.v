`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//Data memory of Mips module
//Big endian memory 
// 16 k bytes memory
//synchronous write , asynchronous read
module mem(
input clk , write,
input [31 : 0]address,
input [31 : 0] wordIn,
output [31 : 0] wordOut
 );
 
 reg [7 : 0] mem[0 : 16383]; 
 always@(posedge clk)
 begin
    if(write)
    begin
        //big endian
        mem[address] <= wordIn[31 : 24];
        mem[address + 1] <= wordIn[23 : 16];
        mem[address + 2] <= wordIn[15 : 8];
        mem[address + 3] <= wordIn[7 : 0];
    end
 end 
 assign wordOut = {mem[address],mem[address + 1],mem[address + 2],mem[address + 3]};
endmodule
