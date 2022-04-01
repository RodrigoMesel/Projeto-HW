
module muxShiftInput(input wire [31:0]data0, data1, data2, input wire [1:0] control, output wire [31:0] out);

    assign out = (control == 2'b00) ? data0:
                 (control == 2'b01) ? data1:
                 data2;

endmodule