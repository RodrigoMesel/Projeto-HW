
module Div(input wire clk, reset, divStart, input wire [31:0] A, B, output reg DivZero, output reg [31:0] Hi, Lo);
   
    reg aux = 1'b0;
    reg [5:0] nOfBits;

    reg [31:0] divisor;
    reg [31:0] dividendo;
    reg [31:0] resto;
    reg [31:0] resultado;

    reg sinalDividendo;
    reg sinalDivisor;

    always @(posedge clk) begin 

        if(reset == 1'b1)begin

            nOfBits = 6'd32;
            dividendo = A;
            divisor = B;
            resto = 32'b0;
            resultado = 32'b0;
            sinalDividendo = dividendo[31];
            sinalDivisor = divisor[31];
            Hi = 32'b0;
            Lo = 32'b0;

        end

        if(divStart == 1'b1)begin

            aux = 1'b1;
            nOfBits = 6'd32;
            dividendo = A;
            divisor = B;
            resto = 32'b0;
            resultado = 32'b0;
            sinalDividendo = dividendo[31];
            sinalDivisor = divisor[31];
            Hi = 32'b0;
            Lo = 32'b0;
            
            if(divisor[31] == 1'b1)begin

                divisor = ~(divisor) + 1'b1;

            end 
 
            if(dividendo[31] == 1'b1)begin

                dividendo = ~(dividendo) + 1'b1;

            end

        end

        if(aux == 1'b1 && nOfBits != 0)begin

            if(B == 32'b0) begin

                DivZero = 1'b1;
                nOfBits = 6'b0;
                
            end else begin

                resto = resto << 1;
                resto[0] = dividendo[nOfBits - 1];

                if(resto >= divisor)begin

                    resto = resto - divisor;
                    resultado[nOfBits - 1] = 1'b1;

                end

                nOfBits = nOfBits - 1;

                if(nOfBits == 6'b000000)begin

                    if(sinalDividendo != sinalDivisor)begin

                        if(sinalDivisor == 1'b1)begin

                            Hi = ~resto + 1'b1;

                        end else begin

                            Hi = resto;

                        end

                        Lo = ~resultado + 1'b1;

                    end else begin

                        if(sinalDivisor == 1'b1)begin

                            Hi = ~resto + 1'b1;

                        end else begin

                            Hi = resto;

                        end                    

                        Lo = resultado;

                    end

                end
            end
        end

    end

endmodule