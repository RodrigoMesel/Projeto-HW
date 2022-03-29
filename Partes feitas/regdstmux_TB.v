`timescale 1us/1ps
`include "regdstmux.v"

module regdstmux_TB ();

    reg [31:0] entry0_TB, entry1_TB, entry2_TB, entry3_TB, entry4_TB;
    reg [2:0] controlSingal_TB;
    wire [31:0] out_TB;

    regdstmux DUT(.entry0(entry0_TB), .entry1(entry1_TB), .entry2(entry2_TB), .entry3(entry3_TB), .entry4(entry4_TB), .controlSingal(controlSingal_TB), .out(out_TB));

    initial begin
        $dumpfile("regdstmux_TB.vcd");
        $dumpvars(0,regdstmux_TB);

            entry0_TB = 32'b00000000000000001111111111111111; entry1_TB = 32'b00000000000000000000000111111111; entry2_TB = 32'b00000000000000000000000000011111; entry3_TB = 32'b00000000000000000000000000000001; entry4_TB = 32'b00000000000000000000000000000000; controlSingal_TB = 3'b000;
            #10 controlSingal_TB = 001;
            #10 controlSingal_TB = 010;
            #10 controlSingal_TB = 011;
            #10 controlSingal_TB = 100;
            #10 controlSingal_TB = 000;
        
    end 
endmodule
