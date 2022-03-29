`timescale 1us/1ps
`include "multordiv.v"

module multordiv_TB ();

    reg [31:0] entry0_TB, entry1_TB;
    reg controlSingal_TB;
    wire [31:0] out_TB;

    multordiv DUT(.entry0(entry0_TB), .entry1(entry1_TB), .controlSingal(controlSingal_TB), .out(out_TB));

    initial begin
        $dumpfile("multordiv.vcd");
        $dumpvars(0,multordiv_TB);

            entry0_TB = 32'b00000000000000001111111111111111;
            entry1_TB = 32'b11111111111111111111111111111111;
            controlSingal_TB = 0;
            #10 controlSingal_TB = 1;
            #10 controlSingal_TB = 0;
        
    end 
endmodule