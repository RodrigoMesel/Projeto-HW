
module ControlUnit (
    
    input clk, reset;
    
    input wire O;

    input wire [5:0] OpCode, Funct;

    output reg [2:0] IorD;
    output reg MemWR;
    output reg IRWrite;
    output reg [1:0] RegDst;
    output reg RegWR;
    output reg WriteA;
    output reg WriteB;
    output reg [1:0] AluSrcA;
    output reg [2:0] AluSrcB;
    output reg [2:0] AluOperation;
    output reg AluOutWrite;
    output reg [2:0] MemToReg;
    output reg [2:0] PCSource;
    output reg PCWrite;
    output reg zero;
    output reg LT;
    output reg ET;
    output reg GT;
    output reg O;
    output reg neg; 

    );


    parameter rst = 6'b000000;
    parameter fetch = 6'b000001;
    parameter decode = 6'b000010;
    parameter op404 = 6'b000_011;
    parameter overflow = 6'b000_100;
    parameter zerodiv = 6'b000_101;

    parameter ADD = 6'b000_110;

    parameter opcodeR = 6'b000000;
    
    parameter ADDFunct = 6'b100000;

    reg [5:0] state;
    reg [4:0] counter;

    always @(posedge clk) begin

        counter = 5'b00000;
        state = fetch;
        
        case (state)
            fetch: begin
                if(counter < 5'b00011)begin

                        MemWR = 0;
                        IRWrite = 0;
                        RegDst = 00;
                        RegWR = 0;
                        WriteA = 0;
                        WriteB = 0;
                        AluSrcA = 00;
                        AluSrcB = 000;
                        AluOperation = 000;
                        AluOutWrite = 0;
                        MemToReg = 000;
                        PCSource = 000;
                        PCWrite = 0;
                        zero = 0;
                        LT = 0;
                        ET = 0;
                        GT = 0;
                        O = 0;
                        neg = 0; 

                        IorD = 000;
                        MemWR = 0;
                        AluSrcA = 00;
                        AluSrcB = 001;
                        AluOperation = 001;
                        PCSource = 010;

                        counter = counter + 5'b00001;

                end else begin

                    IRWrite = 1;
                    PCWrite = 1;
                    counter = 5'b00000;
                    state = decode;
                end
            end

            decode:
                if(counter < 5'b00010)begin
                    AluSrcA = 100;
                    AluSrcB = 00;
                    AluOperation = 001;
                    RegWR = 0;
                    AluOutWrite = 1;
                    WriteA = 1;
                    WriteB = 1;
                    
                    counter = counter + 5'b00001;
                end else begin

                    counter = 5'b00000;

                    case(OpCode)
                        opcodeR:
                            case(Funct)
                                ADDFunct: state = ADD;
                                //...

                            endcase
                        //...
                    endcase

                end

            ADD: begin

                counter = 5'b00000;
                
                if(counter == 5'b00000)begin
                    AluSrcA = 10;
                    AluSrcB = 000;
                    AluOperation = 001;
                    AluOutWrite = 1;
                    
                    counter = counter + 5'b00001;
                
                end else if(counter == 5'b00001)begin

                    if(O == 1)begin
                        counter = 5'b00000;
                        state = overflow;
                    end

                    else begin
                        MemToReg = 011;
                        RegDst = 01;
                        RegWR = 1;
                    end
                

                end


            end



            default: 
        endcase
        
    end




endmodule