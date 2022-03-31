
module ControlUnit (
    
    input clk, reset,
    
    input wire O,

    input wire [5:0] OpCode, Funct,

    output reg [2:0] IorD,
    output reg MemWR,
    output reg IRWrite,
    output reg [1:0] RegDst,
    output reg RegWR,
    output reg WriteA,
    output reg WriteB,
    output reg [1:0] AluSrcA,
    output reg [2:0] AluSrcB,
    output reg [2:0] AluOperation,
    output reg AluOutWrite,
    output reg [2:0] MemToReg,
    output reg [2:0] PCSource,
    output reg PCWrite,
    output reg zero,
    output reg LT,
    output reg ET,
    output reg GT,
    output reg neg 

    );


    parameter rst = 6'b000000;
    parameter fetch = 6'b000001;
    parameter decode = 6'b000010;
    parameter op404 = 6'b000011;
    parameter overflow = 6'b000100;
    parameter zerodiv = 6'b000101;

    parameter ADD = 6'b000110;
    parameter AND = 6'b000111;
    parameter DIV = 6'b001000;
    parameter MULT = 6'b001001;
    parameter JR = 6'b001010;
    parameter MFHI = 6'b001011;
    parameter MFLO = 6'b001100;
    parameter SLL = 6'b001101;
    parameter SLLV = 6'b001111;
    parameter SLT = 6'b010000;
    parameter SRA = 6'b010001;
    parameter SRAV = 6'b010010;
    parameter SRL = 6'b010011;
    parameter SUB = 6'b010100;
    parameter BREAK = 6'b010101;
    parameter RTE = 6'b010110;
    parameter ADDM = 6'b010111;
    parameter ADDI = 6'b011000;
    parameter ADDIU = 6'b011001;
    parameter BEQ = 6'b011010;
    parameter BNE = 6'b011011;
    parameter BLE = 6'b011100;
    parameter BGT = 6'b011101;
    parameter SLLM = 6'b011110;
    parameter LB = 6'b011111;
    parameter LH = 6'b100000;
    parameter LUI = 6'b100001;
    parameter LW = 6'b100010;
    parameter SB = 6'b100011;
    parameter SH = 6'b100100;
    parameter SLTI = 6'b100101;
    parameter SW = 6'b100111;
    parameter J = 6'b101000;
    parameter JAL = 6'b101001;

    //R Instructions
    parameter opcodeR = 6'b000000;
    
    parameter ADDFunct = 6'b100000;
    parameter ANDFunct = 6'b100100;
    parameter DIVFunct = 6'b011010;
    parameter MULTFunct = 6'b011000;
    parameter JRFunct = 6'b001000;
    parameter MFHIFunct = 6'b010000;
    parameter MFLOFunct = 6'b010010;
    parameter SLLFunct = 6'b000000;
    parameter SLLVFunct = 6'b000100;
    parameter SLTFunct = 6'b101010;
    parameter SRAFunct = 6'b000011;
    parameter SRAVFunct = 6'b000111;
    parameter SRLFunct = 6'b000010;
    parameter SUBFunct = 6'b100010;
    parameter BREAKFunct = 6'b001101;
    parameter RTEFunct = 6'b010011;
    parameter ADDMFunct = 6'b000101;

    //I Instructions

    parameter ADDIop = 6'b001000;
    parameter ADDIUop = 6'b001001;
    parameter BEQop = 6'b000100;
    parameter BNEop = 6'b000101;
    parameter BLEop = 6'b000110;
    parameter BGTop = 6'b000111;
    parameter SLLMop = 6'b000001;
    parameter LBop = 6'b100000;
    parameter LHop = 6'b100001;
    parameter LWop = 6'b100011;
    parameter SBop = 6'b101000;
    parameter SHop = 6'b101001;
    parameter SWop = 6'b101011;
    parameter SLTIop = 6'b001010;
    parameter LUIop = 6'b001111;

    //J Instructions

    parameter Jop = 6'b000010;
    parameter JALop = 6'b000011;

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

            decode: begin
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
                                ANDFunct: state =  AND;
                                DIVFunct: state =  DIV;
                                MULTFunct: state =  MULT;
                                JRFunct: state =  JR;
                                MFHIFunct: state =  MFHI;
                                MFLOFunct: state =  MFLO;
                                SLLFunct: state =  SLL;
                                SLLVFunct: state =  SLLV;
                                SLTFunct: state =  SLT;
                                SRAFunct: state =  SRA;
                                SRAVFunct: state =  SRAV;
                                SRLFunct: state =  SRL;
                                SUBFunct: state =  SUB;
                                BREAKFunct: state =  BREAK;
                                RTEFunct: state =  RTE;
                                ADDMFunct: state =  ADDM;

                            endcase
                        ADDIop: state = ADDI;
                        ADDIUop: state = ADDIU;
                        BEQop: state = BEQ;
                        BNEop: state = BNE;
                        BLEop: state = BLE;
                        BGTop: state = BGT;
                        SLLMop: state = SLLM;
                        LBop: state = LB;
                        LHop: state = LH;
                        LWop: state = LW;
                        SBop: state = SB;
                        SHop: state = SH;
                        SWop: state = SW;
                        SLTIop: state = SLTI;
                        LUIop: state = LUI;

                        Jop: state = J;
                        JALop: state = JAL;
                    endcase

                end
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


        endcase
        
    end

endmodule