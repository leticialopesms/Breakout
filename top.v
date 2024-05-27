module top(
    input CLOCK_50,
    input [9:0] SW,
    input [3:0] KEY,
    output reg VGA_CLK,
    output wire [7:0] VGA_R,        // RED (to resistor DAC VGA connector)
    output wire [7:0] VGA_G,        // GREEN (to resistor DAC to VGA connector)
    output wire [7:0] VGA_B,        // BLUE (to resistor DAC to VGA connector)
    output wire VGA_HS,             // HSYNC (to VGA connector)
    output wire VGA_VS,             // VSYNC (to VGA connector)
    output wire VGA_SYNC_N,         // SYNC to VGA connector
    output wire VGA_BLANK_N,        // BLANK to VGA connector
    output wire [6:0] HEX0,         //  digito 0  - digito da direita
    output wire [6:0] HEX1,         //  digito 1
    output wire [6:0] HEX4,         //  digito 4
    output wire [6:0] HEX5          //  digito 5 - digito da esquerda
);

// regs cores
reg [7:0] red_reg;
reg [7:0] green_reg;
reg [7:0] blue_reg;

// coordenadas do centro do quadrado
wire [9:0] x_bar;
wire [9:0] y_bar;
wire [9:0] x_ball;
wire [9:0] y_ball;

// wires x e y
wire [9:0] next_x;
wire [9:0] next_y;
wire active;

// flags de controle para pintar a barrinha e a bolinha
wire barrinha;
wire bolinha;

// booleanos que vamos precisar nos outros arquivos
wire hit_bar;
wire endgame_ball; 
wire hit_block1, hit_block2, hit_block3, hit_block4, hit_block5, hit_block6, hit_block7, hit_block8, hit_block9, hit_block10, 
hit_block11, hit_block12, hit_block13, hit_block14, hit_block15;

wire endgame_block1, endgame_block2, endgame_block3, endgame_block4, endgame_block5, endgame_block6, endgame_block7, endgame_block8, endgame_block9, endgame_block10,
endgame_block11, endgame_block12, endgame_block13, endgame_block14, endgame_block15;

assign barrinha = ((next_x <= x_bar + W_BAR) && (next_x >= x_bar - W_BAR) && (next_y <= y_bar + H_BAR) && (next_y >= y_bar - H_BAR));
assign bolinha = (((x_ball - next_x) * (x_ball - next_x) + (y_ball - next_y) * (y_ball - next_y)) <= R_BALL*R_BALL);

// pensar em talvez um existe_bloco, por causa da questao da implementacao do hit_bloco estar sempre 1
// assign youwin = (hit_bloco1 && hit_bloco2 && hit_bloco3 && hit_bloco4 && hit_bloco5 && hit_bloco6 && hit_bloco7 && hit_bloco8 && hit_bloco9 && hit_bloco10 && hit_bloco11 && hit_bloco12 && hit_bloco13 && hit_bloco14 && hit_bloco15);
assign endgame = (endgame_block1 || endgame_block2 || endgame_block3 || endgame_block4 || endgame_block5 || endgame_block6 || endgame_block7 || endgame_block8 || endgame_block9 || endgame_block10 || endgame_block11 || endgame_block12 || endgame_block13 || endgame_block14 || endgame_block15 || endgame_ball);

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
  .reset(~SW[0]),
  .hit_bar(hit_bar),
  .start(~SW[2]),
  .endgame(endgame),
  .digito0(HEX0),
  .digito1(HEX1),
  .digito4(HEX4),
  .digito5(HEX5)
);

vga v (
  .clock(VGA_CLK),
  .reset(~SW[0]),
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
  .reset(~SW[0]),
  .left(KEY[1]),
  .right(KEY[0]),
  .x(x_bar),
  .y(y_bar),
);

move_ball b (
  .clock(VGA_CLK),
  .reset(~SW[0]),
  .start(~SW[2]),
  .x_bar(x_bar),
  .y_bar(y_bar),
  .x_p(x_ball),
  .y_p(y_ball),
  .hit_bar(hit_bar),
  .endgame(endgame_ball)
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