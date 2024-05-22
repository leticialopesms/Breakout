module placar(
  input clock,
  input reset,
  input hit_bar,        // booleano que indica se a bolinha bateu na barra
  input start,        // booleano que indica se acabou o jogo
  output [6:0] digito0, // digito da direita
  output [6:0] digito1,
  output [6:0] digito4,
  output [6:0] digito5 // digito da esquerda
);

// implementar o placar do jogo. o placar deve ser incrementado a cada vez que a bola tocar na barra. 
// o placar máximo deve ser atualizado se o placar atual for maior que o placar máximo.

// 3 dígitos da direita = placar atual
// 3 dígitos da esquerda = placar máximo

parameter TAM = 8; // tamanho do placar

reg [TAM:0] display_max, display_curr;

wire [TAM+(TAM-4)/3:0] decimal_max; // placar máximo até o momento
wire [TAM+(TAM-4)/3:0] decimal_placar; // placar atual
wire [3:0] d0_max, d1_max, d0_placar, d1_placar; // são os dígitos (cada um com 4 bits) do resultado (em binário)
wire [6:0] d0_display, d1_display, d4_display, d5_display; // são os dígitos convertidos para o display de 7 segmentos

// para o resultado do placar máximo
bcd #(9) b1 (.bin(display_max), .bcd(decimal_max));

// para o resultado do placar atual
bcd #(9) b2 (.bin(display_curr), .bcd(decimal_placar));

// ver se isso aqui está certo
assign d0_max = decimal_placar[3:0];
assign d1_max = decimal_placar[7:4];
assign d0_placar = decimal_max[3:0];
assign d1_placar = decimal_max[7:4];

cb7s c0_max(.numero(d0_max),.segmentos(d0_display));
cb7s c1_max(.numero(d1_max),.segmentos(d1_display));
cb7s c0_placar(.numero(d0_placar),.segmentos(d4_display));
cb7s c1_placar(.numero(d1_placar),.segmentos(d5_display));

assign digito0 = d0_display;
assign digito1 = (display_curr<10) ? 7'b1111111:d1_display;
assign digito4 = d4_display;
assign digito5 = (display_max<10) ? 7'b1111111:d5_display;

reg somou; // flag pra verificar se já somou 1 no placar atual

always @(posedge clock) begin
  // implementar lógica de somar 1 no placar atual e ver se precisa
  // atualizar o placar máximo
  if(!reset) begin 
    somou = 0;
    display_curr = 0;
    display_max = 0;
  end
  else begin
    if(display_curr > display_max) begin
      display_max = display_curr;
    end
    if(start) begin
      display_curr = 0;   // não muda display_max aqui 
    end
    else if(hit_bar && !somou) begin // se bateu na barra mas ainda n somou no placar
      // somar 1 no placar aqui
      display_curr = display_curr + 1;
      somou = 1;
    end
    else if(!hit_bar && somou) begin
      somou = 0;
    end
    else begin
      display_curr = display_curr;
    end
    // tomar cuidado pra não mostrar zeros à esquerda
    // ideia pra resolver isso: mandar sinal x pra placa quando for zero à esquerda
  end
end


endmodule