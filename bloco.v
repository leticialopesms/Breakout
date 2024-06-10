module bloco(
    input clock,
    input reset,
    input start,
    input endgame,
    input hit_lava,
    input [9:0] x_i,
    input [9:0] y_i,
    input [9:0] x_ball,
    input [9:0] y_ball,
    input [9:0] next_x,
    input [9:0] next_y,
    output wire area,
    output wire hit_block,
    output wire hit_block_u,
    output wire hit_block_d,
    output wire hit_block_l,
    output wire hit_block_r,
    output wire endgame_block,
    output reg exist
);

// parametros para os tamanhos da bola, barra e bloco
parameter R_BALL = 8;   // raio da bolinha
parameter H_BAR = 8;    // metade da altura da barra
parameter W_BAR = 64;   // metade da largura da barra
parameter H_BLOCK = 16;  // metade da altura do bloco
parameter W_BLOCK = 64; // metade da largura do bloco
parameter V_BLOCK = 2;  // velocidade do bloco

// variável estado para a máquina de estados
reg [5:0] estado;
reg [9:0] x_block;
reg [9:0] y_block;

wire move;

// preisamos de um timer pq o bloco vai se mover (descer)
timer_block t (
  .clock(clock),
  .reset(reset),
  .pulse(move)
);

// area do bloco
assign area = ((next_x <= x_block + W_BLOCK) && (next_x >= x_block - W_BLOCK) && (next_y <= y_block + H_BLOCK) && (next_y >= y_block - H_BLOCK));

// versao modificada
assign hit_block_u = ((y_ball >= (y_block-H_BLOCK-R_BALL+2)) && (y_ball <= (y_block-H_BLOCK+2)) && (x_ball >= x_block-W_BLOCK+2) && (x_ball <= x_block+W_BLOCK-2));
assign hit_block_d = ((y_ball <= (y_block+H_BLOCK+R_BALL-2)) && (y_ball >= (y_block+H_BLOCK-2)) && (x_ball >= x_block-W_BLOCK+2) && (x_ball <= x_block+W_BLOCK-2));
assign hit_block_l = ((x_ball >= x_block-W_BLOCK-R_BALL+2) && (x_ball <= x_block-W_BLOCK+2) && (y_ball >= y_block-H_BLOCK+2) && (y_ball <= y_block+H_BLOCK-2));
assign hit_block_r = ((x_ball <= x_block+W_BLOCK+R_BALL-2) && (x_ball >= x_block+W_BLOCK-2) && (y_ball >= y_block-H_BLOCK+2) && (y_ball <= y_block+H_BLOCK-2));

assign hit_block = (exist) ? (hit_block_d || hit_block_u || hit_block_l || hit_block_r) : 0;

assign endgame_block = (y_block >= (480-26)); // verificar aqui


always @(posedge clock) begin
  if (reset) begin
    exist = 1;
    estado = 0;
    x_block = x_i;             
    y_block = y_i;
  end
  else begin
    case(estado)
      0: begin
        if(start) estado = 4;
        else estado = 0;
      end
      1: begin
        // esperando a bolinha bater e voltar
        // exist = 1;
        estado = 2;
      end
      2: begin
        exist = 0;
        estado = 4;
      end
      3: begin
        if (exist) begin
          if (endgame) estado = 5;
          else if (hit_lava) estado = 0;
          else if (hit_block) estado = 1;
          else if(move) begin
            y_block = y_block + V_BLOCK;
            estado = 4;
          end
          else estado = 3;
        end
        else estado = 5;
      end
      4: begin
        if (endgame) estado = 5;
        else if (hit_lava) estado = 0;
        else if (hit_block) estado = 1;
        else estado = 3;
      end
      5: begin
        estado = 5;
      end
      default: estado = 4;
    endcase
  end
end

endmodule