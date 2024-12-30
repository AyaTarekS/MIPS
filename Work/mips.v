





module mips(
        input clk
        ,input reset
        ,input inputInstruction
        ,input writeInst
        ,input instAddress
        ,output write_data
        ,output wordIn
        ,output ProgramCounter
        ,output write_reg
    );
    //data from Instruction 
    reg [31 : 0] ProgramCounter;
    wire [31 : 0]instruction;
    reg [5 : 0] OPcode;
    reg [4 : 0] Rs , Rt , Rd , func ;
    wire [4 : 0] write_reg ;
    reg [31 : 0] signedoffeset;
    reg [15 : 0] offeset ;
    wire [31 : 0]inputInstruction;
    wire writeInst;
    wire [31 : 0]instAddress;
    //register file data
    wire [31 : 0]data_out1 , data_out2 ;
    reg [31 : 0] write_data ;
    //flags
    wire Zero;
    wire RegDst;
    wire Jumb;
    wire Branch;
    wire MemRead;
    wire MemtoReg;
    wire [1 : 0] ALUOp;
    wire MemWrite;
    wire ALUSrc;
    wire RegWrite;
    //memory variables
    reg [31 : 0] Address ;
    //wire [7 : 0] memOut , memIn ; // for lb , sb
    wire [31 : 0]wordOut ;
    reg [31 : 0] wordIn ;
    //branch variables
    reg [31 : 0] branchOffeset ;
    wire [31 : 0] AluResult ;
reg_file regFile(.clk(clk),
                .write(RegWrite),
                .read_reg1(Rs),
                .read_reg2(Rt),
                .write_reg(write_reg),
                .data_out1(data_out1),
                .data_out2(data_out2),
                .write_data(write_data),
                .reset(reset)
                );
mem myMem(.clk(clk),
         .address(Address),
         .write(MemWrite),
         .wordIn(wordIn),
         .wordOut(wordOut)
        );
                
//fetching the instruction
program_mem programMem(.pc(ProgramCounter),
                        .inst(instruction),
                        .clk(clk),
                        .write(writeInst),
                        .inputinst(inputInstruction),
                        .address(instAddress));

always@(posedge clk or posedge reset) begin
    if(reset)
    begin 
        ProgramCounter <= 0;
        Rs <= 0 ; 
        Rt <= 0 ;
        Rd <= 0 ;
        func <= 0;
        signedoffeset <= 0;
        write_data <= 0 ;
        wordIn <=0;
        offeset <= 0;
        branchOffeset <=0;
        Address<=0;
        signedoffeset<=0;

    end
    else
    begin
//increamenting the PC
ProgramCounter <= ProgramCounter + 4 ; 
//assign all the data from the instruction to its place
    OPcode <= instruction[31 : 26];
    Rs <= instruction[25 : 21];
    Rt <= instruction[20 : 16];
    Rd <= instruction[15 : 11];
    func <= instruction[4 : 0];
    offeset <= instruction[15 : 0];
    end
end
assign Zero = (data_out1 == data_out2)? 1 : 0;
controller mycontroller(.OPcode(OPcode),
                     .Zero(Zero),
                     .RegDst(RegDst),
                     .Jumb(Jumb),
                     .Branch(Branch),
                     .MemRead(MemRead),
                     .MemtoReg(MemtoReg),
                     .ALUOp(ALUOp),
                     .MemWrite(MemWrite),
                     .ALUSrc(ALUSrc),
                     .RegWrite(RegWrite)               
                    );
//destination register
assign write_reg = (RegDst == 1)? Rd : Rt ;
//Alu control
always @(*)
begin
    case (ALUOp)
    //R format
    2'b10: begin
        if( ALUSrc == 0)
        begin
        if(func == 0)
        write_data <= data_out1 + data_out2 ;
        else if(func == 1)
        write_data <= data_out1 - data_out2 ;
        else
        write_data <= 0;
        end
    end
    // LW , SW and addi
    2'b00:begin
        if(ALUSrc == 1)
        begin
        signedoffeset = {{16{offeset[15]}} , offeset };
        //the output of the Alu
        Address = data_out1 + signedoffeset ; 
        if(MemWrite) //SW
        begin
            wordIn = data_out2 ; //rt data 
        end
        else if(MemtoReg)//LW
        begin
            write_data = wordOut ;
        end
        else
        write_data = Address;
        end
    end
    //BEQ and BNQ
    default:
    begin
        branchOffeset = (Branch) ? signedoffeset<<2 : 0 ; 
        if ((OPcode == 4 && Zero == 1) || (OPcode == 5 && Zero == 0))
        begin
        ProgramCounter <= ProgramCounter + branchOffeset;
        end 
    end
endcase
end
endmodule