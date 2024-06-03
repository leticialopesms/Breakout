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

// --- wires e regs --- //

// regs cores
reg [7:0] red_reg;
reg [7:0] green_reg;
reg [7:0] blue_reg;

// coordenadas do centro dos elementos
wire [9:0] x_bar;
wire [9:0] y_bar;
wire [9:0] x_ball;
wire [9:0] y_ball;
wire [9:0] x_block;
wire [9:0] y_block;

// wires x e y
wire [9:0] next_x;
wire [9:0] next_y;
wire active;

// flags de controle para pintar a barrinha e a bolinha
wire barrinha;
wire bolinha;
wire bloquinho1, bloquinho2, bloquinho3, bloquinho4, bloquinho5, bloquinho6, bloquinho7, bloquinho8, bloquinho9, bloquinho10;
wire lavinha;

// booleanos que vamos precisar nos outros arquivos
wire hit_bar;
wire hit_block;
wire endgame_ball;
wire endgame_block;
wire endgame;

// wires para hit_block
wire hit_block1, hit_block2, hit_block3, hit_block4, hit_block5, hit_block6, hit_block7, hit_block8, hit_block9, hit_block10;
wire hit_block_down1, hit_block_up1, hit_block_right1, hit_block_left1;
wire hit_block_down2, hit_block_up2, hit_block_right2, hit_block_left2;
wire hit_block_down3, hit_block_up3, hit_block_right3, hit_block_left3;
wire hit_block_down4, hit_block_up4, hit_block_right4, hit_block_left4;
wire hit_block_down5, hit_block_up5, hit_block_right5, hit_block_left5;
wire hit_block_down6, hit_block_up6, hit_block_right6, hit_block_left6;
wire hit_block_down7, hit_block_up7, hit_block_right7, hit_block_left7;
wire hit_block_down8, hit_block_up8, hit_block_right8, hit_block_left8;
wire hit_block_down9, hit_block_up9, hit_block_right9, hit_block_left9;
wire hit_block_down10, hit_block_up10, hit_block_right10, hit_block_left10;

wire existe_b1, existe_b2, existe_b3, existe_b4, existe_b5, existe_b6, existe_b7, existe_b8, existe_b9, existe_b10;

// wires para endgame_block
wire endgame_block1, endgame_block2, endgame_block3, endgame_block4, endgame_block5, endgame_block6, endgame_block7, endgame_block8, endgame_block9, endgame_block10;

// pensar em talvez um existe_bloco, por causa da questao da implementacao do hit_bloco estar sempre 1

// --- atribuições --- //

// atribuições para os elementos do jogo
// assign barrinha = ((next_x <= x_bar + W_BAR) && (next_x >= x_bar - W_BAR) && (next_y <= y_bar + H_BAR) && (next_y >= y_bar - H_BAR));
// assign bolinha = (((x_ball - next_x) * (x_ball - next_x) + (y_ball - next_y) * (y_ball - next_y)) <= R_BALL*R_BALL);
assign lavinha = (next_y >= 480 - 16); // ver ideias.txt !! (para fazer ondinhas)

// atribuições para hit_block
assign hit_block = (hit_block1 || hit_block2 || hit_block3 || hit_block4 || hit_block5 || hit_block6 || hit_block7 || hit_block8 || hit_block9 || hit_block10);
assign hit_block_down = (hit_block_down1 || hit_block_down2 || hit_block_down3 || hit_block_down4 || hit_block_down5 || hit_block_down6 || hit_block_down7 || hit_block_down8 || hit_block_down9 || hit_block_down10);
assign hit_block_up = (hit_block_up1 || hit_block_up2 || hit_block_up3 || hit_block_up4 || hit_block_up5 || hit_block_up6 || hit_block_up7 || hit_block_up8 || hit_block_up9 || hit_block_up10);
assign hit_block_right = (hit_block_right1 || hit_block_right2 || hit_block_right3 || hit_block_right4 || hit_block_right5 || hit_block_right6 || hit_block_right7 || hit_block_right8 || hit_block_right9 || hit_block_right10);
assign hit_block_left = (hit_block_left1 || hit_block_left2 || hit_block_left3 || hit_block_left4 || hit_block_left5 || hit_block_left6 || hit_block_left7 || hit_block_left8 || hit_block_left9 || hit_block_left10);

// atribuições para endgame
// assign endgame = (endgame_block1 || endgame_block2 || endgame_block3 || endgame_block4 || endgame_block5 || endgame_block6 || endgame_block7 || endgame_block8 || endgame_block9 || endgame_block10 || endgame_block11 || endgame_block12 || endgame_block13 || endgame_block14 || endgame_block15 || endgame_ball);
assign endgame_block = (endgame_block1 || endgame_block2 || endgame_block3 || endgame_block4 || endgame_block5 || endgame_block6 || endgame_block7 || endgame_block8 || endgame_block9 || endgame_block10);
assign endgame = (endgame_block || endgame_ball);


placar p(
  .clock(VGA_CLK),
  .reset(~SW[0]),
  .hit_block(hit_block),
  .start(~SW[2]),
  .endgame_ball(endgame_ball),
  .endgame_block(endgame_block),
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
  .next_x(next_x),
  .next_y(next_y),
  .x(x_bar),
  .y(y_bar),
  .posicao(barrinha)
);

move_ball b (
  .clock(VGA_CLK),
  .reset(~SW[0]),
  .start(~SW[2]),
  .x_bar(x_bar),
  .y_bar(y_bar),
  .next_x(next_x),
  .next_y(next_y),
  .hit_block(hit_block),
  .hit_block_down(hit_block_down),
  .hit_block_up(hit_block_up),
  .hit_block_right(hit_block_right),
  .hit_block_left(hit_block_left),
  .x(x_ball),
  .y(y_ball),
  .hit_bar(hit_bar),
  .endgame(endgame_ball),
  .posicao(bolinha)
);

// primeira fileira de bloquinhos --------------------------------------------------
bloco b1 (
  .clock(VGA_CLK),
  .reset(~SW[0]),
  .start(~SW[2]),
  .x_i(64),
  .y_i(16),
  .x_ball(x_ball),
  .y_ball(y_ball),
  .next_x(next_x),
  .next_y(next_y),
  .area(bloquinho1),
  .hit_block(hit_block1),
  .hit_block_down(hit_block_down1),
  .hit_block_up(hit_block_up1),
  .hit_block_right(hit_block_right1),
  .hit_block_left(hit_block_left1),
  .endgame(endgame_block1),
  .exist(existe_b1)
);

bloco b2 (
  .clock(VGA_CLK),
  .reset(~SW[0]),
  .start(~SW[2]),
  .x_i(192),
  .y_i(16),
  .x_ball(x_ball),
  .y_ball(y_ball),
  .next_x(next_x),
  .next_y(next_y),
  .area(bloquinho2),
  .hit_block(hit_block2),
  .hit_block_down(hit_block_down2),
  .hit_block_up(hit_block_up2),
  .hit_block_right(hit_block_right2),
  .hit_block_left(hit_block_left2),
  .endgame(endgame_block2),
  .exist(existe_b2)
);

bloco b3 (
  .clock(VGA_CLK),
  .reset(~SW[0]),
  .start(~SW[2]),
  .x_i(320),
  .y_i(16),
  .x_ball(x_ball),
  .y_ball(y_ball),
  .next_x(next_x),
  .next_y(next_y),
  .area(bloquinho3),
  .hit_block(hit_block3),
  .hit_block_down(hit_block_down3),
  .hit_block_up(hit_block_up3),
  .hit_block_right(hit_block_right3),
  .hit_block_left(hit_block_left3),
  .endgame(endgame_block3),
  .exist(existe_b3)
);

bloco b4 (
  .clock(VGA_CLK),
  .reset(~SW[0]),
  .start(~SW[2]),
  .x_i(448),
  .y_i(16),
  .x_ball(x_ball),
  .y_ball(y_ball),
  .next_x(next_x),
  .next_y(next_y),
  .area(bloquinho4),
  .hit_block(hit_block4),
  .hit_block_down(hit_block_down4),
  .hit_block_up(hit_block_up4),
  .hit_block_right(hit_block_right4),
  .hit_block_left(hit_block_left4),
  .endgame(endgame_block4),
  .exist(existe_b4)
);

bloco b5 (
  .clock(VGA_CLK),
  .reset(~SW[0]),
  .start(~SW[2]),
  .x_i(576),
  .y_i(16),
  .x_ball(x_ball),
  .y_ball(y_ball),
  .next_x(next_x),
  .next_y(next_y),
  .area(bloquinho5),
  .hit_block(hit_block5),
  .hit_block_down(hit_block_down5),
  .hit_block_up(hit_block_up5),
  .hit_block_right(hit_block_right5),
  .hit_block_left(hit_block_left5),
  .endgame(endgame_block5),
  .exist(existe_b5)
);


// segunda fileira de bloquinhos --------------------------------------------
bloco b6 (
  .clock(VGA_CLK),
  .reset(~SW[0]),
  .start(~SW[2]),
  .x_i(64),
  .y_i(48),
  .x_ball(x_ball),
  .y_ball(y_ball),
  .next_x(next_x),
  .next_y(next_y),
  .area(bloquinho6),
  .hit_block(hit_block6),
  .hit_block_down(hit_block_down6),
  .hit_block_up(hit_block_up6),
  .hit_block_right(hit_block_right6),
  .hit_block_left(hit_block_left6),
  .endgame(endgame_block6),
  .exist(existe_b6)
);

bloco b7 (
  .clock(VGA_CLK),
  .reset(~SW[0]),
  .start(~SW[2]),
  .x_i(192),
  .y_i(48),
  .x_ball(x_ball),
  .y_ball(y_ball),
  .next_x(next_x),
  .next_y(next_y),
  .area(bloquinho7),
  .hit_block(hit_block7),
  .hit_block_down(hit_block_down7),
  .hit_block_up(hit_block_up7),
  .hit_block_right(hit_block_right7),
  .hit_block_left(hit_block_left7),
  .endgame(endgame_block7),
  .exist(existe_b7)
);

bloco b8 (
  .clock(VGA_CLK),
  .reset(~SW[0]),
  .start(~SW[2]),
  .x_i(320),
  .y_i(48),
  .x_ball(x_ball),
  .y_ball(y_ball),
  .next_x(next_x),
  .next_y(next_y),
  .area(bloquinho8),
  .hit_block(hit_block8),
  .hit_block_down(hit_block_down8),
  .hit_block_up(hit_block_up8),
  .hit_block_right(hit_block_right8),
  .hit_block_left(hit_block_left8),
  .endgame(endgame_block8),
  .exist(existe_b8)
);

bloco b9 (
  .clock(VGA_CLK),
  .reset(~SW[0]),
  .start(~SW[2]),
  .x_i(448),
  .y_i(48),
  .x_ball(x_ball),
  .y_ball(y_ball),
  .next_x(next_x),
  .next_y(next_y),
  .area(bloquinho9),
  .hit_block(hit_block9),
  .hit_block_down(hit_block_down9),
  .hit_block_up(hit_block_up9),
  .hit_block_right(hit_block_right9),
  .hit_block_left(hit_block_left9),
  .endgame(endgame_block9),
  .exist(existe_b9)
);

bloco b10 (
  .clock(VGA_CLK),
  .reset(~SW[0]),
  .start(~SW[2]),
  .x_i(576),
  .y_i(48),
  .x_ball(x_ball),
  .y_ball(y_ball),
  .next_x(next_x),
  .next_y(next_y),
  .area(bloquinho10),
  .hit_block(hit_block10),
  .hit_block_down(hit_block_down10),
  .hit_block_up(hit_block_up10),
  .hit_block_right(hit_block_right10),
  .hit_block_left(hit_block_left10),
  .endgame(endgame_block10),
  .exist(existe_b10)
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
      if (bolinha) begin
        red_reg = 255; // vermelho
        green_reg = 255; // verde
        blue_reg = 255; // azul
      end
      else if (bloquinho1 && existe_b1) begin
        red_reg = 10; // vermelho
        green_reg = 230; // verde
        blue_reg = 50; // azul
      end
      else if (bloquinho2 && existe_b2) begin
        red_reg = 100; // vermelho
        green_reg = 50; // verde
        blue_reg = 230; // azul
      end
      else if (bloquinho3 && existe_b3) begin
        red_reg = 10; // vermelho
        green_reg = 230; // verde
        blue_reg = 50; // azul
      end
      else if (bloquinho4 && existe_b4) begin
        red_reg = 100; // vermelho
        green_reg = 50; // verde
        blue_reg = 230; // azul
      end
      else if (bloquinho5 && existe_b5) begin
        red_reg = 10; // vermelho
        green_reg = 230; // verde
        blue_reg = 50; // azul
      end
      else if (bloquinho6 && existe_b6) begin
        red_reg = 100; // vermelho
        green_reg = 50; // verde
        blue_reg = 230; // azul
      end
      else if (bloquinho7 && existe_b7) begin
        red_reg = 10; // vermelho
        green_reg = 230; // verde
        blue_reg = 50; // azul
      end
      else if (bloquinho8 && existe_b8) begin
        red_reg = 100; // vermelho
        green_reg = 50; // verde
        blue_reg = 230; // azul
      end
      else if (bloquinho9 && existe_b9) begin
        red_reg = 10; // vermelho
        green_reg = 230; // verde
        blue_reg = 50; // azul
      end
      else if (bloquinho10 && existe_b10) begin
        red_reg = 100; // vermelho
        green_reg = 50; // verde
        blue_reg = 230; // azul
      end
      else if (lavinha && !barrinha) begin
        red_reg = 255; // vermelho
        green_reg = 25; // verde
        blue_reg = 25; // azul
      end
      else if (barrinha) begin
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