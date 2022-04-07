
module CPU (input clk, reset);

    //Data Wires
    wire [31:0] PCOut;
    wire [31:0] EPCOut;
    wire [3:0] PCAux;
    wire [31:0] CauseControlOut;
    wire [31:0] IorDOut;
    wire [31:0] MemOut;

    wire [5:0] OpCode;
    wire Op404;
    wire [4:0] RS;
    wire [4:0] RT;
    wire [4:0] RD;
    wire [4:0] SHAMT;
    wire [15:0] Imediato;
    wire [31:0] ImediatoExtendido32bits;
    wire [31:0] ImediatoToBrench;
    wire [4:0] MuxRegDstOut;
    wire [31:0] MuxMemToRegOut;

    wire [31:0] BRoutA;
    wire [31:0] BRoutB;
    wire [31:0] AOut;
    wire [4:0] BOut5bits;
    wire [31:0] BOut;
    wire [31:0] MuxResultA;
    wire [31:0] MuxResultB;
    wire [31:0] AluResult;
    wire [31:0] AluOutResult;

    wire [31:0] MemDataRegisterOut;
    wire [4:0] MemDataRegisterOut5bits;
    wire [15:0] MemDataRegisterOutToLH;
    wire [31:0] MemDataRegisterOutToLHExtendido;
    wire [7:0] MemDataRegisterOutToLB; 
    wire [31:0] MemDataRegisterOutToLBExtendido; 
    wire [31:0] LoadOut;
    wire [31:0] StoreOut;
    wire [31:0] SOut;
    wire [31:0] SHOut;
    wire [31:0] SBOut;

    wire [31:0] ShiftInputControlOut;
    wire [4:0] ShiftNControlOut;
    wire [31:0] RegDeslocOut;

    wire [31:0] PCSourceResult;

    //Jump
    wire [25:0] JumpFromInstruction;
    wire [27:0] JumpShifted;
    wire [31:0] JumpAddress;

    //Multiplication and division
    wire [31:0] MultHiOut;
    wire [31:0] MultLoOut;
    wire [31:0] DivHiOut;
    wire [31:0] DivLoOut;
    wire [31:0] MultOrDivHighOut;
    wire [31:0] MultOrDivLowOut;
    wire [31:0] HighOut;
    wire [31:0] LowOut;

    //ALU
    wire zero;
    wire LT;
    wire [31:0] LTExtended;
    wire ET;
    wire GT;
    wire O;
    wire neg;

    //Sinais de controle
    wire [2:0] IorD;
    wire [1:0] CauseControl;
    wire MemWR;
    wire IRWrite;
    wire [1:0] RegDst;
    wire [2:0] MemToReg;
    wire RegWR;
    wire WriteA;
    wire WriteB;
    wire [1:0] AluSrcA;
    wire [2:0] AluSrcB;
    wire [2:0] AluOperation;
    wire AluOutWrite;
    wire [2:0] PCSource;
    wire EPCWrite;  
    wire PCWrite;
    wire MemDataWrite;
    wire [1:0] LoadControl;
    wire [1:0] StoreControl;
    wire MultOrDivLow;
    wire MultOrDivHigh;
    wire multStart;
    wire divStart;
    wire DivZero;
    wire LOWrite;
    wire HIWrite;
    wire [1:0] ShiftInputControl;
    wire [1:0] ShiftNControl;
    wire [2:0] ShiftControl;
 

    parameter sp = 5'b11101;
    parameter ra = 5'b11111;

    variaveisMontador vM(
        PCOut, Imediato, MemDataRegisterOut, RS, RT, BOut,
        PCAux, RD, SHAMT, MemDataRegisterOutToLH, MemDataRegisterOutToLB,
        JumpFromInstruction, BOut5bits, MemDataRegisterOut5bits, SHOut, SBOut, SOut
    );

    Memoria mem(
        IorDOut, clk, MemWR, StoreOut, MemOut
    );

    Instr_Reg IR(
        clk, reset, IRWrite, MemOut, OpCode, RS, RT, Imediato
    );

    Banco_reg BR(
        clk, reset, RegWR, RS, RT, MuxRegDstOut, MuxMemToRegOut, BRoutA, BRoutB
    );

    ula32 ALU(
        MuxResultA, MuxResultB, AluOperation, AluResult, O, neg, zero, ET, GT, LT 
    );

    RegDesloc regDeslc(
        clk, reset, ShiftControl, ShiftNControlOut, ShiftInputControlOut, RegDeslocOut
    );

    //Registradores

    Registrador PC(
        clk, reset, PCWrite, PCSourceResult, PCOut
    );

    Registrador A(
        clk, reset, WriteA, BRoutA, AOut
    );

    Registrador B(
        clk, reset, WriteB, BRoutB, BOut
    );

    Registrador AluOut(
        clk, reset, AluOutWrite, AluResult, AluOutResult
    );

    Registrador MemDataRegister(
        clk, reset, MemDataWrite, MemOut, MemDataRegisterOut
    );

    Registrador EPC(
        clk, reset, EPCWrite, AluResult, EPCOut
    );

    Registrador HI(
        clk, reset, HIWrite, MultOrDivHighOut, HighOut 
    );

    Registrador LO(
        clk, reset, LOWrite, MultOrDivLowOut, LowOut
    );

    //MUXS

    muxpcsource muxpcsource(
        {{24{1'b0}}, MemOut[7:0]}, AOut, AluResult, {PCOut[31:28], JumpShifted}, AluOutResult, EPCOut, PCSource, PCSourceResult
    );

    muxcausecontrol cc(
        32'b00000000000000000000000011111101, 32'b00000000000000000000000011111110, 32'b00000000000000000000000011111111, CauseControl, CauseControlOut
    );
    
    muxiord iord(
        PCOut, CauseControlOut, AOut, BOut, AluOutResult, IorD, IorDOut
    );

    muxregdst regdst(
        RT, RD, ra, sp, RegDst, MuxRegDstOut
    );

    muxalusrcA muxalusrca(
        PCOut, MemOut, AOut, 32'b00000000000000000000000000011101, AluSrcA, MuxResultA
    );

    muxalusrcB muxalusrcb(
        BOut, 32'b00000000000000000000000000000100, ImediatoExtendido32bits,
        MemDataRegisterOut, ImediatoToBrench, AluSrcB, MuxResultB
    );

    muxmemtoreg muxmemtoreg(
        HighOut, LowOut, LoadOut, AluOutResult, LTExtended, RegDeslocOut, ImediatoExtendido32bits, 32'b00000000000000000000000011100011, MemToReg, MuxMemToRegOut
    );

    muxload load(
        MemDataRegisterOutToLHExtendido, MemDataRegisterOutToLBExtendido, MemDataRegisterOut, LoadControl, LoadOut
    );

    muxStore store(
        SHOut, SBOut, SOut, StoreControl, StoreOut
    );

    muxShiftInput si(
        AOut, ImediatoExtendido32bits, BOut, ShiftInputControl, ShiftInputControlOut
    );

    muxshiftN sn(
        BOut5bits, 5'b10000, SHAMT, MemDataRegisterOut5bits, ShiftNControl, ShiftNControlOut 
    );

    muxmultordiv multOrDivHI(
        MultHiOut, DivHiOut, MultOrDivHigh, MultOrDivHighOut
    );

    muxmultordiv MultOrDivLO(
        MultLoOut, DivLoOut, MultOrDivLow, MultOrDivLowOut
    );


    //Signal Extend

    signext16_32 imediatoExtender(
        Imediato, ImediatoExtendido32bits
    );

    signext16_32 loadHfExtender(
        MemDataRegisterOutToLH, MemDataRegisterOutToLHExtendido
    );

    signext8_32 loadBtExtender(
        MemDataRegisterOutToLB, MemDataRegisterOutToLBExtendido
    );

    signext1_32 LTExtender(
        LT, LTExtended
    );


    //Shift Left 2

    shiftleft2_32_32 imediatoShifter(
        ImediatoExtendido32bits, ImediatoToBrench
    );

    shiftleft2_26_28 jumpShifter(
        JumpFromInstruction, JumpShifted
    );


    //Mult e Div

    Mult multiplication(
        clk, reset, multStart, AOut, BOut, MultHiOut, MultLoOut  
    );

    Div division(
        clk, reset, divStart, AOut, BOut, DivZero, DivHiOut, DivLoOut
    );

    //Unidade de controle

    ControlUnit UnitOfControl(
        clk, reset, O, Op404, DivZero, OpCode, Imediato[5:0],
        zero, LT, ET, GT, neg, IorD, CauseControl, MemWR, IRWrite, 
        RegDst, MemToReg, RegWR, WriteA, WriteB, AluSrcA, AluSrcB,
        AluOperation, AluOutWrite, PCSource, PCWrite, EPCWrite,
        MemDataWrite, LoadControl, StoreControl, 
        MultOrDivLow, MultOrDivHigh, LOWrite, HIWrite,
        ShiftInputControl, ShiftNControl, ShiftControl, multStart, reset 
    );


endmodule