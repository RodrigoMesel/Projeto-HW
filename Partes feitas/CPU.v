
module CPU (input clk, reset);

    wire [31:0] temp32;

    //Data Wires
    wire [31:0] PCOut;
    wire [7:0] CauseControlOut;
    wire [31:0] IorDOut;
    wire [31:0] MemOut;
    wire [5:0] IRout1;
    wire [4:0] IRout2;
    wire [4:0] IRout3;
    wire [15:0] IRout4;
    wire [31:0] PCSourceResult;
    wire [31:0] Imediato;
    wire [31:0] BRoutA;
    wire [31:0] BRoutB;
    wire [31:0] AOut;
    wire [31:0] BOut;
    wire [31:0] MuxResultA;
    wire [31:0] MuxResultB;
    wire [31:0] AluOutResult;
    wire [31:0] MuxMemToRegOut;
    wire [4:0] IR_15_11 = IRout4[15:11];
    wire [4:0] MuxRegDstOut;
    wire [31:0] MemDataRegisterOut;
    wire [31:0] LoadOut;
    wire [31:0] AluResult;

    //ALU



    //Sinais de controle
    wire [2:0] IorD;
    wire MemWR;
    wire IRWrite;
    wire [1:0] RegDst;
    wire RegWR;
    wire WriteA;
    wire WriteB;
    wire [1:0] AluSrcA;
    wire [2:0] AluSrcB;
    wire [2:0] AluOperation;
    wire AluOutWrite;
    wire [2:0] MemToReg;
    wire [2:0] PCSource;
    wire PCWrite;
    wire MemDataWrite;
    wire LoudControl;
    wire zero;
    wire LT;
    wire ET;
    wire GT;
    wire O;
    wire neg; 

    //Extras
    
    wire [31:0] StoreOut; // IMPLEMENTAR

    parameter sp = 5'b11101;
    parameter ra = 5'b11111;


    muxpcsource muxpcsource(
    temp32, temp32, AluResult, temp32, temp32, temp32, PCSource, PCSourceResult
    );
    
    Registrador PC(
        clk, reset, PCWrite, PCSourceResult, PCOut
    );

    muxiord iord(
        PCOut, CauseControlOut, AOut, BOut, AluOutResult, IorD, IorDOut
    );

    Memoria mem(
        IorDOut, clk, MemWR, StoreOut, MemOut
    );

    Instr_Reg IR(
        clk, reset, IRWrite, MemOut, IRout1, IRout2, IRout3, IRout4
    );

    signext16_32 imediato(
        IRout4, Imediato
    );

    muxregdst regdst(
        IRout3, IR_15_11, ra, sp, RegDst, MuxRegDstOut
    );

    Banco_reg BR(
        clk, reset, RegWR, IRout2, IRout3, MuxRegDstOut, MuxMemToRegOut, BRoutA, BRoutB
    );

    Registrador A(
        clk, reset, WriteA, BRoutA, AOut
    );

    Registrador B(
        clk, reset, WriteB, BRoutB, BOut
    );

    muxalusrcA muxalusrca(
        PCOut, temp32, AOut, sp, AluSrcA, MuxResultA
    );

    muxalusrcB muxalusrcb(
        BOut, 32'b00000000000000000000000000000100, Imediato, temp32, temp32, AluSrcB, MuxResultB
    );

    ula32 ALU(
        MuxResultA, MuxResultB, AluOperation, AluResult, O, neg, zero, ET, GT, LT 
    );

    Registrador AluOut(
        clk, reset, AluOutWrite, AluResult, AluOutResult
    );

    muxmemtoreg muxmemtoreg(
        temp32, temp32, LoadOut, AluOutResult, temp32, temp32, temp32, 32'b00000000000000000000000011100011, MemToReg, MuxMemToRegOut
    );

    Registrador MemDataRegister(
        clk, reset, MemDataWrite, MemOut, MemDataRegisterOut
    );

    muxload Load(
        temp32, temp32, MemDataRegisterOut, LoudControl, LoadOut
    );

    ControlUnit UnitOfControl(
        clk, reset, O, IRout1, IRout4[5:0],
        IorD, MemWR, IRWrite, RegDst, RegWR, WriteA, WriteB,
        AluSrcA, AluSrcB, AluOperation, AluOutWrite, MemToReg, 
        PCSource, PCWrite, zero, LT, ET, GT, neg
    );


endmodule