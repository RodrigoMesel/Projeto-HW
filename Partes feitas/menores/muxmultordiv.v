module muxmultordiv(input wire[31:0]entry0, entry1, input wire controlSingal, output wire [31:0] out);

    assign out = (controlSingal == 1'b0) ? entry0 : entry1;

endmodule