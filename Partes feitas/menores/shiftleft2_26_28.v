
module shiftleft2_26_28 (input wire [25:0] in, output wire [27:0] out);

    wire [27:0] aux;

    assign aux = {{2{1'b0}}, in};
    assign out = aux << 2; 

endmodule
