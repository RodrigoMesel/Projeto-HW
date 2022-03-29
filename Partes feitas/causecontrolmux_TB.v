`timescale 1us/1ps
`include "causecontrolmux.v"

module causecontrolmux_TB ();

    reg [7:0] entry0_TB, entry1_TB, entry2_TB;
    reg [1:0] controlSingal_TB;
    wire [7:0] out_TB;

    causecontrolmux DUT(.entry0(entry0_TB), .entry1(entry1_TB), .entry2(entry2_TB), .controlSingal(controlSingal_TB), .out(out_TB));

    initial begin
        $dumpfile("causecontrolmux_TB.vcd");
        $dumpvars(0,causecontrolmux_TB);

            entry0_TB = 8'b11111111; entry1_TB = 8'b00001111; entry2_TB = 8'b00000001; controlSingal_TB = 2'b00;
            #10 controlSingal_TB = 2'b01;
            #10 controlSingal_TB = 2'b10;

        
    end 
endmodule