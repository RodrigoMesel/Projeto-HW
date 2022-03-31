
module signext16_32 (input wire[15:0] in, output wire [31:0] out);

    assign out = (in[15] == 0) ? {{16{1'b0}}, in} : {{16{1'b1}}, in};

endmodule