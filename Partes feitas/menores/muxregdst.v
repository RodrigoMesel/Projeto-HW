
module muxregdst (input wire [4:0] entry0, entry1, entry2, entry3, input wire [1:0] controlSingal, output wire [4:0] out);

    assign out = (controlSingal == 3'b00) ? entry0:
                 (controlSingal == 3'b01) ? entry1:
                 (controlSingal == 3'b10) ? entry2:
                 entry3;

endmodule