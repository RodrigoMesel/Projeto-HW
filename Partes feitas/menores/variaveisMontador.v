
module variaveisMontador(

    input wire [31:0] PCOut,
    input wire [15:0] Imediato,
    input wire [31:0] MemDataRegisterOut,
    input wire [4:0] RS, RT,

    output wire [3:0] PCAux,
    output wire [4:0] RD,
    output wire [4:0] SHAMT, 
    output wire [15:0] MemDataRegisterOutToLH,
    output wire [7:0] MemDataRegisterOutToLB,
    output wire [25:0] JumpFromInstruction

);

    wire [9:0] JumpAux;

    assign PCAux = PCOut[31:28];
    assign RD = Imediato[15:11];
    assign SHAMT = Imediato [10:6];
    assign MemDataRegisterOutToLH = MemDataRegisterOut[15:0];
    assign MemDataRegisterOutToLB = MemDataRegisterOut[7:0];
    assign JumpAux = {RS,RT};
    assign JumpFromInstruction = {JumpAux, Imediato};

endmodule