//register file contains 32 register
//each register has a length of 32 bit
// 2 read ports (asychronous)
//active high asynchronous reset
//1 write port with write flag (synchronous)
module reg_file(
    input clk , write , reset,
    input [4 : 0] read_reg1, read_reg2, write_reg,
    input [31 : 0] write_data,
    output reg[31 : 0]data_out1 , data_out2
);

    reg [31 : 0] registers [0 : 31]; 
    integer i ;
    
    always@(posedge clk or posedge reset) begin
        if(reset)
        begin
            for(i = 0 ; i < 32 ; i = i + 1)
                registers[i] <= 0;
        end
        else if(write)
        begin
            registers[write_reg] <= write_data ;
        end
    end
    always@(*)
    begin
     data_out1 = registers[read_reg1];
     data_out2 = registers[read_reg2];
    end
endmodule