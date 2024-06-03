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

// ---------------------------------- //
// ---------- WIRES e REGS ---------- //
// ---------------------------------- //

// Cores
reg [7:0] red_reg;
reg [7:0] green_reg;
reg [7:0] blue_reg;

// Coordenadas do centro dos elementos
wire [9:0] x_bar;
wire [9:0] y_bar;
wire [9:0] x_ball;
wire [9:0] y_ball;
wire [9:0] x_block;
wire [9:0] y_block;

// VGA
wire [9:0] next_x;
wire [9:0] next_y;
wire active;

// Flags de controle para barra, a bola, os blocos e a lava
wire barrinha;
wire bolinha;
wire bloquinho1, bloquinho2, bloquinho3, bloquinho4, bloquinho5, bloquinho6, bloquinho7, bloquinho8, bloquinho9, bloquinho10;
wire lavinha;

// Flags de parada
wire hit_bar;
wire hit_block;
wire endgame_ball;
wire endgame_block;
wire endgame;

// Flags para identificar a colisão com os blocos
wire hit_block1, hit_block2, hit_block3, hit_block4, hit_block5, hit_block6, hit_block7, hit_block8, hit_block9, hit_block10;
wire hit_block_u1, hit_block_d1, hit_block_l1, hit_block_r1;
wire hit_block_u2, hit_block_d2, hit_block_l2, hit_block_r2;
wire hit_block_u3, hit_block_d3, hit_block_l3, hit_block_r3;
wire hit_block_u4, hit_block_d4, hit_block_l4, hit_block_r4;
wire hit_block_u5, hit_block_d5, hit_block_l5, hit_block_r5;
wire hit_block_u6, hit_block_d6, hit_block_l6, hit_block_r6;
wire hit_block_u7, hit_block_d7, hit_block_l7, hit_block_r7;
wire hit_block_u8, hit_block_d8, hit_block_l8, hit_block_r8;
wire hit_block_u9, hit_block_d9, hit_block_l9, hit_block_r9;
wire hit_block_u10, hit_block_d10, hit_block_l10, hit_block_r10;

// Flags para identificar se os blocos existem
wire existe;
wire existe_b1, existe_b2, existe_b3, existe_b4, existe_b5, existe_b6, existe_b7, existe_b8, existe_b9, existe_b10;

// Flags para identificar se os blocos chegaram ao final da tela
wire endgame_block;
wire endgame_block1, endgame_block2, endgame_block3, endgame_block4, endgame_block5, endgame_block6, endgame_block7, endgame_block8, endgame_block9, endgame_block10;

// ----------------------------------- //
// ------------- ASSINGS ------------- //
// ----------------------------------- //

// Área da lava
assign lavinha = (next_y >= 480 - 16);

// Atribuições para hit_block
assign hit_block_d = (hit_block_d1 || hit_block_d2 || hit_block_d3 || hit_block_d4 || hit_block_d5 || hit_block_d6 || hit_block_d7 || hit_block_d8 || hit_block_d9 || hit_block_d10);
assign hit_block_u = (hit_block_u1 || hit_block_u2 || hit_block_u3 || hit_block_u4 || hit_block_u5 || hit_block_u6 || hit_block_u7 || hit_block_u8 || hit_block_u9 || hit_block_u10);
assign hit_block_r = (hit_block_r1 || hit_block_r2 || hit_block_r3 || hit_block_r4 || hit_block_r5 || hit_block_r6 || hit_block_r7 || hit_block_r8 || hit_block_r9 || hit_block_r10);
assign hit_block_l = (hit_block_l1 || hit_block_l2 || hit_block_l3 || hit_block_l4 || hit_block_l5 || hit_block_l6 || hit_block_l7 || hit_block_l8 || hit_block_l9 || hit_block_l10);
assign hit_block = (hit_block1 || hit_block2 || hit_block3 || hit_block4 || hit_block5 || hit_block6 || hit_block7 || hit_block8 || hit_block9 || hit_block10);

// Atribuições para endgame
assign endgame_block = (endgame_block1 || endgame_block2 || endgame_block3 || endgame_block4 || endgame_block5 || endgame_block6 || endgame_block7 || endgame_block8 || endgame_block9 || endgame_block10);
assign endgame = (endgame_block || endgame_ball);


// ----------------------------------- //
// ------------- MODULES ------------- //
// ----------------------------------- //

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

bar bar (
  .clock(VGA_CLK),
  .reset(~SW[0]),
  .left(KEY[1]),
  .right(KEY[0]),
  .next_x(next_x),
  .next_y(next_y),
  .x(x_bar),
  .y(y_bar),
  .area(barrinha)
);

ball ball (
  .clock(VGA_CLK),
  .reset(~SW[0]),
  .start(~SW[2]),
  .x_bar(x_bar),
  .y_bar(y_bar),
  .next_x(next_x),
  .next_y(next_y),
  .hit_block(hit_block),
  .hit_block_u(hit_block_u),
  .hit_block_d(hit_block_d),
  .hit_block_l(hit_block_l),
  .hit_block_r(hit_block_r),
  .x(x_ball),
  .y(y_ball),
  .hit_bar(hit_bar),
  .endgame(endgame_ball),
  .area(bolinha)
);

bloco b1 (
  .clock(VGA_CLK),
  .reset(~SW[0]),
  .start(~SW[2]),
  .x_i(64),
  .y_i(32),
  .x_ball(x_ball),
  .y_ball(y_ball),
  .next_x(next_x),
  .next_y(next_y),
  .area(bloquinho1),
  .hit_block(hit_block1),
  .hit_block_u(hit_block_u1),
  .hit_block_d(hit_block_d1),
  .hit_block_l(hit_block_l1),
  .hit_block_r(hit_block_r1),
  .endgame(endgame_block1),
  .exist(existe_b1)
);

bloco b2 (
  .clock(VGA_CLK),
  .reset(~SW[0]),
  .start(~SW[2]),
  .x_i(192),
  .y_i(32),
  .x_ball(x_ball),
  .y_ball(y_ball),
  .next_x(next_x),
  .next_y(next_y),
  .area(bloquinho2),
  .hit_block(hit_block2),
  .hit_block_u(hit_block_u2),
  .hit_block_d(hit_block_d2),
  .hit_block_l(hit_block_l2),
  .hit_block_r(hit_block_r2),
  .endgame(endgame_block2),
  .exist(existe_b2)
);

bloco b3 (
  .clock(VGA_CLK),
  .reset(~SW[0]),
  .start(~SW[2]),
  .x_i(320),
  .y_i(32),
  .x_ball(x_ball),
  .y_ball(y_ball),
  .next_x(next_x),
  .next_y(next_y),
  .area(bloquinho3),
  .hit_block(hit_block3),
  .hit_block_u(hit_block_u3),
  .hit_block_d(hit_block_d3),
  .hit_block_l(hit_block_l3),
  .hit_block_r(hit_block_r3),
  .endgame(endgame_block3),
  .exist(existe_b3)
);

bloco b4 (
  .clock(VGA_CLK),
  .reset(~SW[0]),
  .start(~SW[2]),
  .x_i(448),
  .y_i(32),
  .x_ball(x_ball),
  .y_ball(y_ball),
  .next_x(next_x),
  .next_y(next_y),
  .area(bloquinho4),
  .hit_block(hit_block4),
  .hit_block_u(hit_block_u4),
  .hit_block_d(hit_block_d4),
  .hit_block_l(hit_block_l4),
  .hit_block_r(hit_block_r4),
  .endgame(endgame_block4),
  .exist(existe_b4)
);

bloco b5 (
  .clock(VGA_CLK),
  .reset(~SW[0]),
  .start(~SW[2]),
  .x_i(576),
  .y_i(32),
  .x_ball(x_ball),
  .y_ball(y_ball),
  .next_x(next_x),
  .next_y(next_y),
  .area(bloquinho5),
  .hit_block(hit_block5),
  .hit_block_u(hit_block_u5),
  .hit_block_d(hit_block_d5),
  .hit_block_l(hit_block_l5),
  .hit_block_r(hit_block_r5),
  .endgame(endgame_block5),
  .exist(existe_b5)
);

// ---------------------------------- //
// ------------- ALWAYS ------------- //
// ---------------------------------- //

// Divisor de frequência para o VGA
always@(posedge CLOCK_50) begin
    VGA_CLK = ~VGA_CLK;
end

// Lógica de cores para cada elemento
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
      red_reg = 200; // vermelho
      green_reg = 100; // verde
      blue_reg = 50; // azul
    end
    else if (bloquinho4 && existe_b4) begin
      red_reg = 50; // vermelho
      green_reg = 200; // verde
      blue_reg = 100; // azul
    end
    else if (bloquinho5 && existe_b5) begin
      red_reg = 100; // vermelho
      green_reg = 50; // verde
      blue_reg = 200; // azul
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