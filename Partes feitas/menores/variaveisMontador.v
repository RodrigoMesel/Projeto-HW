
module variaveisMontador(

    input wire [31:0] PCOut,
    input wire [15:0] Imediato,
    input wire [31:0] MemDataRegisterOut,
    input wire [4:0] RS, RT,
    input wire [31:0] BOut,

    output wire [3:0] PCAux,
    output wire [4:0] RD,
    output wire [4:0] SHAMT, 
    output wire [25:0] JumpFromInstruction,
    output wire [4:0] BOut5bits, MemDataRegisterOut5bits,
    output wire [31:0] SHOut, SBOut, SOut

);

    wire [15:0] SHFromBin;
    wire [15:0] SHFromMemin;

    wire [7:0] SBFromBin;
    wire [23:0] SBFromMemin;

    assign SHFromBin = BOut[15:0];
    assign SHFromMemin = MemDataRegisterOut [31:16];

    assign SBFromBin = BOut[7:0];
    assign SBFromMemin = MemDataRegisterOut [31:8];


    assign PCAux = PCOut[31:28];
    assign RD = Imediato[15:11];
    assign SHAMT = Imediato [10:6];
    assign JumpFromInstruction = {RS, RT, Imediato};
    assign BOut5bits = BOut[4:0];
    assign MemDataRegisterOut5bits = MemDataRegisterOut[4:0];
    assign SHOut = {SHFromMemin, SHFromBin};
    assign SBOut = {SBFromMemin, SBFromBin};
    assign SOut = BOut;

endmodule