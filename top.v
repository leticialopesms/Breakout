// o top 3 meramente imprime na tela o fundo, a barra e a bola
// e implementa o placar

// TO DO: 
// 1. fazer o jogo funcionar com varios starts (pra manter o placar max)    [OK]
// 2. fazer a aceleracao
// 3. arrumar a velocidade pra aumentar em x e diminuir em y (SERA?)
// 4. implementar / debugar o placar                                        [OK]
// 5. fazer a barra andar de forma continua                                 [OK]
// 6. fazer todo mundo comecar no centro                                    [OK]
// 7. resetar o placar atual toda vez que o start for apertado              [OK]

module top(
    input CLOCK_50,
    input [9:0] SW,
    input left,
    input right,
    output reg VGA_CLK,
    output wire [7:0] VGA_R,    // RED (to resistor DAC VGA connector)
    output wire [7:0] VGA_G,    // GREEN (to resistor DAC to VGA connector)
    output wire [7:0] VGA_B,    // BLUE (to resistor DAC to VGA connector)
    output wire VGA_HS,         // HSYNC (to VGA connector)
    output wire VGA_VS,         // VSYNC (to VGA connector)
    output wire VGA_SYNC_N,     // SYNC to VGA connector
    output wire VGA_BLANK_N,     // BLANK to VGA connector
    output wire [6:0] HEX0,        //  digito 0  - digito da direita
    output wire [6:0] HEX1,        //  digito 1
    output wire [6:0] HEX4,        //  digito 4
    output wire [6:0] HEX5         //  digito 5 - digito da esquerda
);

// implementar o placar do jogo. o placar deve ser incrementado a cada vez que a bola tocar na barra. 
// o placar máximo deve ser atualizado se o placar atual for maior que o placar máximo.

// 3 dígitos da direita = placar atual
// 3 dígitos da esquerda = placar máximo

// regs cores
reg [7:0] red_reg;
reg [7:0] green_reg;
reg [7:0] blue_reg;

// coordenadas do centro do quadrado
wire [9:0] x_bar;
wire [9:0] y_bar;
wire [9:0] x_ball;
wire [9:0] y_ball;

// Wires x e y
wire [9:0] next_x;
wire [9:0] next_y;
wire active;

// flags de controle para pintar a barrinha e a bolinha
wire barrinha;
wire bolinha;

assign barrinha = ((next_x <= x_bar + W_BAR) && (next_x >= x_bar - W_BAR) && (next_y <= y_bar + H_BAR) && (next_y >= y_bar - H_BAR));
assign bolinha = (((x_ball - next_x) * (x_ball - next_x) + (y_ball - next_y) * (y_ball - next_y)) <= R_BALL*R_BALL);

wire hit_bar, endgame; // booleanos que vamos precisar nos outros arquivos

// parametros para os limites do monitor (até onde o quadrado pode ir)
parameter LIM_LEFT = R_BALL;
parameter LIM_RIGHT = 640 - R_BALL;
parameter LIM_UP = R_BALL;
parameter LIM_DOWN = 480 - R_BALL;

// parametros para os tamanhos da bola e da barra
parameter R_BALL = 8;   // raio da bolinha
parameter H_BAR = 8;    // metade da altura da barra
parameter W_BAR = 64;   // metade da largura da barra

placar p(
  .clock(VGA_CLK),
  .reset(SW[0]),
  .hit_bar(hit_bar),
  .start(SW[2]),
  .digito0(HEX0),
  .digito1(HEX1),
  .digito4(HEX4),
  .digito5(HEX5)
);

vga v (
  .clock(VGA_CLK),
  .reset(SW[0]),
  .next_x(next_x),
  .next_y(next_y),
  .vga_hs(VGA_HS),
  .vga_vs(VGA_VS),
  .vga_sync_n(VGA_SYNC_N),
  .vga_blank_n(VGA_BLANK_N),
  .active(active)
);

move_bar m (
  .clock(VGA_CLK),
  .reset(SW[0]),
  .left(left),
  .right(right),
  .x(x_bar),
  .y(y_bar),
);

move_ball b (
  .clock(VGA_CLK),
  .reset(SW[0]),
  .start(SW[2]),
  .x_bar(x_bar),
  .y_bar(y_bar),
  .x_p(x_ball),
  .y_p(y_ball),
  .hit_bar(hit_bar),
  .endgame(endgame)
);

// divisor de frequência
always@(posedge CLOCK_50) begin
    VGA_CLK = ~VGA_CLK;
end

// lógica de colorir
always @(posedge VGA_CLK) begin
  if (!SW[0]) begin
    red_reg = 0; // vermelho
    green_reg = 0; // verde
    blue_reg = 0; // azul
  end
  else begin
      if (barrinha) begin
        red_reg = 255; // vermelho
        green_reg = 255; // verde
        blue_reg = 255; // azul
      end
      else if (bolinha) begin
        red_reg = 255; // vermelho
        green_reg = 255; // verde
        blue_reg = 255; // azul
      end
      else begin
        red_reg = 0; // vermelho
        green_reg = 0; // verde
        blue_reg = 0; // azul
      end
    end
end

assign VGA_R = (active)?red_reg:0;
assign VGA_G = (active)?green_reg:0;
assign VGA_B = (active)?blue_reg:0;

endmodule