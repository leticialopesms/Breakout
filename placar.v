module placar(
  input clock,
  input reset,
  input hit_block,        // booleano que indica se a bolinha bateu em um bloco
  input endgame_ball,     // booleano que indica se o jogador perdeu
  input endgame_block,    // booleano que indica se o bloco chegou ao final da tela
  input start,            // booleano que indica se vai comecar outro jogo
  output [6:0] digito0,   // digito da direita
  output [6:0] digito1,
  output [6:0] digito4,
  output [6:0] digito5    // digito da esquerda
);

// 3 dígitos da direita = pontuacao atual
// 3 dígitos da esquerda = vidas 

parameter TAM = 8; // tamanho do placar

reg [TAM:0] vidas, score;

wire [TAM+(TAM-4)/3:0] decimal_vidas; // qnt de vidas ate o momento
wire [TAM+(TAM-4)/3:0] decimal_score; // pontuacao atual
wire [3:0] d0_vidas, d1_vidas, d0_score, d1_score; // são os dígitos (cada um com 4 bits) do resultado (em binário)
wire [6:0] d0_display, d1_display, d4_display, d5_display; // são os dígitos convertidos para o display de 7 segmentos

// para o resultado do placar máximo
bcd #(9) b1 (.bin(vidas), .bcd(decimal_vidas));

// para o resultado do placar atual
bcd #(9) b2 (.bin(score), .bcd(decimal_score));

// verificar isso aqui (na branch main isso ta invertido por algum motivo desconhecido)
assign d0_vidas = decimal_vidas[3:0];
assign d1_vidas = decimal_vidas[7:4];
assign d0_score = decimal_score[3:0];
assign d1_score = decimal_score[7:4];

cb7s c0_vidas (.numero(d0_vidas),.segmentos(d4_display));
cb7s c1_vidas (.numero(d1_vidas),.segmentos(d5_display));
cb7s c0_score (.numero(d0_score),.segmentos(d0_display));
cb7s c1_score (.numero(d1_score),.segmentos(d1_display));

assign digito0 = d0_display;
assign digito1 = (score<10) ? 7'b1111111:d1_display;
assign digito4 = d4_display;
assign digito5 = (vidas<10) ? 7'b1111111:d5_display;

wire add_score; // flag pra verificar se deve somar 1 na pontuacao atual
reg [5:0] estado; // estado da máquina de estados

button b (
  .clock(clock),
  .reset(reset),
  .entrada(hit_block),
  .saida(add_score)
);

always @(posedge clock) begin
  if(reset) begin
    score = 0;
    vidas = 10;
    estado = 0;
  end
  else begin
    case(estado)
      0: begin
        if (start) begin
          vidas = vidas;
          score = score;
          if(endgame_ball) estado = 1;
          else if (endgame_block) estado = 3;
          else if (add_score) estado = 4;
          else if (score == 10) estado = 5; // considerando 10 blocos no total aqui
          else estado = 0;
        end
        else estado = 0;
      end
      1: begin  // jogador perdeu 1 vida
        vidas = vidas - 1;
        if (vidas > 0) estado = 2; // tratando o caso de não ter mais vidas aqui
        else estado = 3;
      end
      2: begin  // jogador perdeu 1 vida e ainda tem mais
        if (!start) estado = 0;
        else estado = 2;
      end
      3: begin  // jogador perdeu todas as vidas
        // imprimir OVER no display
        estado = 3;
      end
      4: begin  // jogador acertou um bloco
        score = score + 1;
        estado = 0;
      end
      5: begin // jogador ganhou o jogo, eliminando todos os blocos
        // imprimir YOU WIN no display
        estado = 5;
      end
      default: estado = 0;
    endcase
  end
end


endmodule