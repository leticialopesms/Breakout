module bloco(
    input clock,
    input reset,
    input start,
    input [9:0] x_i,
    input [9:0] y_i,
    input [9:0] x_ball,
    input [9:0] y_ball,
    input [9:0] next_x,
    input [9:0] next_y,
    output wire area,
    output wire hit_block,
    output wire hit_block_up,
    output wire hit_block_down,
    output wire hit_block_right,
    output wire hit_block_left,
    output wire endgame,
    output reg exist
);

// parametros para os tamanhos da bola, barra e bloco
parameter R_BALL = 8;   // raio da bolinha
parameter H_BAR = 8;    // metade da altura da barra
parameter W_BAR = 64;   // metade da largura da barra
parameter H_BLOCK = 32;  // metade da altura do bloco
parameter W_BLOCK = 64; // metade da largura do bloco

// variável estado para a máquina de estados
reg [3:0] estado;
reg [9:0] x_block;
reg [9:0] y_block;
reg [9:0] v_block;

// wire move;

// preisamos de um timer pq o bloco vai se mover (descer)
wire move;

timer t (
  .clock(clock),
  .reset(reset),
  .pulse(move)
);

// area do bloco
assign area = ((next_x <= x_block + W_BLOCK) && (next_x >= x_block - W_BLOCK) && (next_y <= y_block + H_BLOCK) && (next_y >= y_block - H_BLOCK));

// verificar isso aqui
assign hit_block_up = ((y_ball == (y_block-H_BLOCK-R_BALL)) && (x_ball >= x_block-W_BLOCK) && (x_ball <= x_block+W_BLOCK));
assign hit_block_down = ((y_ball == (y_block+H_BLOCK+R_BALL)) && (x_ball >= x_block-W_BLOCK) && (x_ball <= x_block+W_BLOCK));
assign hit_block_right = ((x_ball == x_block+W_BLOCK+R_BALL) && (y_ball >= y_block-H_BLOCK) && (y_ball <= y_block+H_BLOCK));
assign hit_block_left = ((x_ball == x_block-W_BLOCK-R_BALL) && (y_ball >= y_block-H_BLOCK) && (y_ball <= y_block+H_BLOCK));
assign hit_block = (exist) ? (hit_block_down || hit_block_up || hit_block_left || hit_block_right) : 0;

assign endgame = (y_block >= (480-16));

// ver onde colocar o movimento do bloco aqui

always @(posedge clock) begin
  if (reset) begin
    // endgame = 0;
    exist = 1;
    estado = 0;
    x_block = x_i;             // MUDAR PARA CADA BLOCO!
    y_block = y_i;
    v_block = 1;
  end
  else begin
    case(estado)
      0: begin
        x_block = x_block;             // MUDAR PARA CADA BLOCO!
        y_block = y_block;
        if(start) begin
          if (hit_block) estado = 1;
          else estado = 3;
        end
        else estado = 0;
      end
      1: begin
        // esperando a bolinha bater e voltar
        exist = 1;
        estado = 2;
      end
      2: begin
        exist = 0;
        estado = 0;
      end
      3: begin
        if (move) begin
          y_block = y_block + v_block;
          estado = 0;
        end
        else estado = 3;
      end
      default: estado = 0;
    endcase
  end
end

endmodule