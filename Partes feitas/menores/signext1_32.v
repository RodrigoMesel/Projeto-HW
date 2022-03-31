module signext1_32 (input wire in, output wire [31:0] out);

  assign out = (in == 0) ? {{31{1'b0}}, in} : {{31{1'b1}}, in};

endmodule