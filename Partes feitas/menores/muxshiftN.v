
module muxshiftN (input wire [4:0] data0, data1, data2, data3, input wire [1:0] control, output wire [4:0] out);

    assign out = (control == 2'b00) ? data0:
                 (control == 2'b01) ? data1:
                 (control == 2'b10) ? data2:
                 data3;

endmodule