`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//program memory 
//4k bytes memory
//big endian memory
//synchronous write with enable to fill the insturction memory
//synchronous read using PC
//write with write flag
module program_mem(
input [31 : 0] pc
,input clk
,input write
,input [31 : 0]address
,input [31 : 0]inputinst
,output reg [31 : 0] inst
);
reg [7 : 0]mem [0 : 4095]; //1D array for program memory 
always@(posedge clk)
begin//fetching the instruction
inst <= {mem[pc] , mem[pc + 1] , mem[pc + 2] ,mem[pc + 3]};
if(write)begin
mem[address] = inputinst[31 : 24];
mem[address + 1]= inputinst[23 : 16];
mem[address + 2]= inputinst[15 : 8];
mem[address + 3]= inputinst[7 : 0];
end
end
endmodule
