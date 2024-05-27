module bloco(
    input clock,
    input reset,
    input start,
    input [9:0] x_bar,
    input [9:0] y_bar,
    output wire [9:0] x_p,
    output wire [9:0] y_p,
    output wire hit_bar,
    output reg endgame
);

// parametros para os limites do monitor (até onde o quadrado pode ir)
parameter H_BAR = 8;    // metade da altura da barra
parameter W_BAR = 64;   // metade da largura da barra
parameter LIM_LEFT = W_BAR;
parameter LIM_RIGHT = (640 - W_BAR);

// variável estado para a máquina de estados
reg [3:0] estado;

// coordenadas do centro da bolinha
reg [9:0] x_ball;
reg [9:0] y_ball;
reg [9:0] vx_mod;   // modulo da velocidade em x
reg [9:0] vy_mod;   // modulo da velocidade em y

wire move;

timer t (
  .clock(clock),
  .reset(reset),
  .pulse(move)
);

assign hit_right = ((x_ball >= x_bar + 32) && (x_ball <= x_bar + W_BAR));


assign x_p = x_ball;
assign y_p = y_ball;

endmodule