`timescale 1us/1ps
`include "memtoregmux.v"

module memtoregmux_TB ();

    reg [31:0] entry0_TB, entry1_TB, entry2_TB, entry3_TB, entry4_TB, entry5_TB, entry6_TB, entry7_TB;
    reg [2:0] controlSingal_TB;
    wire [31:0] out_TB;

    memtoregmux DUT(.entry0(entry0_TB),
                    .entry1(entry1_TB),
                    .entry2(entry2_TB),
                    .entry3(entry3_TB),
                    .entry4(entry4_TB),
                    .entry5(entry5_TB),
                    .entry6(entry6_TB),
                    .entry7(entry7_TB),
                    .controlSingal(controlSingal_TB),
                    .out(out_TB));

    initial begin
        $dumpfile("memtoregmux.vcd");
        $dumpvars(0,memtoregmux_TB);

            entry0_TB = 32'b00000000000000001111111111111111; 
            entry1_TB = 32'b00000000000000000000000111111111; 
            entry2_TB = 32'b00000000000000000000000000011111; 
            entry3_TB = 32'b00000000000000000000000000000001; 
            entry4_TB = 32'b00000000000000000000000000000000;
            entry5_TB = 32'b11111111111111111111111111111111;
            entry6_TB = 32'b11110000000000001111111111111111;
            entry7_TB = 32'b10101010101010101111111111111111; 
            controlSingal_TB = 3'b000;
            #10 controlSingal_TB = 3'b001;
            #10 controlSingal_TB = 3'b010;
            #10 controlSingal_TB = 3'b011;
            #10 controlSingal_TB = 3'b100;
            #10 controlSingal_TB = 3'b101;
            #10 controlSingal_TB = 3'b110;
            #10 controlSingal_TB = 3'b111;
            #10 controlSingal_TB = 3'b000;

        
    end 
endmodule