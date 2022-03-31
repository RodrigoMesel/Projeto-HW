
module signext8_32(input wire [7:0] in, output wire[31:0] out);

    assign out = (in[7] == 0) ? {{24{1'b0}}, in} : {{24{1'b1}}, in};

endmodule