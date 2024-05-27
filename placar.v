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
wire [TAM+(TAM-4)/3:0] decimal_placar; // pontuacao atual
wire [3:0] d0_vidas, d1_vidas, d0_placar, d1_placar; // são os dígitos (cada um com 4 bits) do resultado (em binário)
wire [6:0] d0_display, d1_display, d4_display, d5_display; // são os dígitos convertidos para o display de 7 segmentos

// para o resultado do placar máximo
bcd #(9) b1 (.bin(vidas), .bcd(decimal_vidas));

// para o resultado do placar atual
bcd #(9) b2 (.bin(score), .bcd(decimal_placar));

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
assign digito1 = (score<10) ? 7'b1111111:d1_display;
assign digito4 = d4_display;
assign digito5 = (vidas<10) ? 7'b1111111:d5_display;

wire add_score; // flag pra verificar se deve somar 1 na pontuacao atual
reg [3:0] estado; // estado da máquina de estados

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
    // if(start) begin
    //   score = 0;
    //   vidas = vidas;
    // end
    // else if(endgame_ball && (vidas > 0))begin
    //   vidas = vidas - 1;
    // end
    // else if(endgame_ball && (vidas == 0)) begin
    //   vidas = 0;  // fica assim ate dar reset
    //   // pensar em escrever "OVER" no display
    // end
    // else if(hit_block && !somou) begin // se bateu no bloco mas ainda nao somou na pontuacao
    //   // somar 1 no placar aqui
    //   score = score + 1;
    //   somou = 1;
    // end
    // else if(!hit_block && somou) begin
    //   somou = 0;
    // end
    // else begin
    //   score = score;
    //   vidas = vidas;
    // end
    case(estado)
      0: begin
        if (start) begin
          if(endgame_ball) estado = 1;
          else if (endgame_block) estado = 3;
          else if (add_score) estado = 4;
          else estado = 0;
        end
        else estado = 0;
      end
      1: begin  // jogador perdeu 1 vida
        vidas = vidas - 1;
        if (vidas > 0) estado = 2;
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
      default: estado = 0;
    endcase
  end
end


endmodule