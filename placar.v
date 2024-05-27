module placar(
  input clock,
  input reset,
  input hit_block,        // booleano que indica se a bolinha bateu em um bloco
  input endgame,          // booleano que indica se o jogador perdeu
  input start,            // booleano que indica se vai comecar outro jogo
  output [6:0] digito0,   // digito da direita
  output [6:0] digito1,
  output [6:0] digito4,
  output [6:0] digito5    // digito da esquerda
);

// 3 dígitos da direita = pontuacao atual
// 3 dígitos da esquerda = vidas 

parameter TAM = 8; // tamanho do placar

reg [TAM:0] display_vidas, display_curr;

wire [TAM+(TAM-4)/3:0] decimal_vidas; // qnt de vidas ate o momento
wire [TAM+(TAM-4)/3:0] decimal_placar; // pontuacao atual
wire [3:0] d0_vidas, d1_vidas, d0_placar, d1_placar; // são os dígitos (cada um com 4 bits) do resultado (em binário)
wire [6:0] d0_display, d1_display, d4_display, d5_display; // são os dígitos convertidos para o display de 7 segmentos

// para o resultado do placar máximo
bcd #(9) b1 (.bin(display_vidas), .bcd(decimal_vidas));

// para o resultado do placar atual
bcd #(9) b2 (.bin(display_curr), .bcd(decimal_placar));

// verificar isso aqui (na branch main isso ta invertido por algum motivo desconhecido)
assign d0_vidas = decimal_vidas[3:0];
assign d1_vidas = decimal_vidas[7:4];
assign d0_placar = decimal_placar[3:0];
assign d1_placar = decimal_placar[7:4];

cb7s c0_vidas (.numero(d0_vidas),.segmentos(d0_display));
cb7s c1_vidas (.numero(d1_vidas),.segmentos(d1_display));
cb7s c0_placar(.numero(d0_placar),.segmentos(d4_display));
cb7s c1_placar(.numero(d1_placar),.segmentos(d5_display));

assign digito0 = d0_display;
assign digito1 = (display_curr<10) ? 7'b1111111:d1_display;
assign digito4 = d4_display;
assign digito5 = (display_vidas<10) ? 7'b1111111:d5_display;

reg somou; // flag pra verificar se já somou 1 na pontuacao atual

always @(posedge clock) begin
  if(reset) begin 
    somou = 0;
    display_curr = 0;
    display_vidas = 10;
  end
  else begin
    if(start) begin
      display_curr = 0;
      display_vidas = display_vidas;
    end
    if(endgame && display_vidas)begin
      display_vidas = display_vidas - 1;
      display_curr = 0;
    end
    else if(endgame && !display_vidas) begin
      display_vidas = 0;  // fica assim ate dar reset
      display_curr = 0;   // fica assim ate dar reset
    end
    else if(hit_block && !somou) begin // se bateu no bloco mas ainda nao somou na pontuacao
      // somar 1 no placar aqui
      display_curr = display_curr + 1;
      somou = 1;
    end
    else if(!hit_block && somou) begin
      somou = 0;
    end
    else begin
      display_curr = display_curr;
      display_vidas = display_vidas;
    end
  end
end


endmodule