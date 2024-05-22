module cb7s(
    input [3:0] numero,
    output reg [6:0] segmentos
);

always @(*) begin
    case(numero)
        4'h0: segmentos = ~7'b0111111; // 0
        4'h1: segmentos = ~7'b0000110; // 1
        4'h2: segmentos = ~7'b1011011; // 2
        4'h3: segmentos = ~7'b1001111; // 3
        4'h4: segmentos = ~7'b1100110; // 4
        4'h5: segmentos = ~7'b1101101; // 5
        4'h6: segmentos = ~7'b1111101; // 6
        4'h7: segmentos = ~7'b0000111; // 7
        4'h8: segmentos = ~7'b1111111; // 8
        4'h9: segmentos = ~7'b1101111; // 9
        4'ha: segmentos = ~7'b1110111; // A
        4'hb: segmentos = ~7'b1111100; // b
        4'hc: segmentos = ~7'b0111001; // C
        4'hd: segmentos = ~7'b1011110; // d
        4'he: segmentos = ~7'b1111001; // E
        4'hf: segmentos = ~7'b1110001; // F
    
        default: segmentos = ~7'b0000000; // entrada inválida
    endcase
end

endmodule