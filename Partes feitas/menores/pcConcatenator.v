
module pcConcatenator (input wire [3:0] data1, input wire [27:0] data2, output wire [31:0]out);

    assign out = {data1,data2};

endmodule