
module muxcausecontrol(input wire [7:0] entry0, entry1, entry2, input wire [1:0] controlSingal, output wire [7:0] out);

    assign out = (controlSingal == 2'b00) ? entry0:
                 (controlSingal == 2'b01) ? entry1:
                 entry2;

endmodule