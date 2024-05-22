module button (
    // lógica low
    input clock,
    input reset,
    input entrada,
    output reg saida
);

reg [1:0] estado;

always @(posedge clock) begin
    if (reset) begin
        estado = 0; 
        saida = 0; // não realiza operação
    end
    else begin
        case (estado)
            0: begin // botão não pressionado
                saida = 0; // não realiza operação
                if (!entrada) begin
                    estado = 1;
                end
                else begin
                    estado = 0;
                end
            end
            1: begin // botão pressionado
                estado = 2;
                saida = 1; // realiza operacao
            end
            2: begin // botão solto
                saida = 0;
                if(entrada) begin
                    estado = 0;
                end
                else begin
                    estado = 2;
                end
            end
            default: estado = 0;
        endcase
    end
end

endmodule