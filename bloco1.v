module bloco1(
    input clock,
    input reset,
    input start,
    input [9:0] x_ball,
    input [9:0] y_ball,
    output wire [9:0] x_bloco,
    output wire [9:0] y_bloco,
    output wire hit_bloco,
    output reg endgame
);

parameter H_BLOCK = 6;    // metade da altura do block
parameter W_BLOCK = 64;   // metade da largura do block

// variável estado para a máquina de estados
reg [3:0] estado;

// coordenadas do centro da bolinha
reg [9:0] x_ball;
reg [9:0] y_ball;

wire move;

// preisamos de um timer pq o bloco vai se mover (descer)
timer_block t (
  .clock(clock),
  .reset(reset),
  .pulse(move)
);

// verificar isso aqui
assign hit_block = ((y_ball <= (y_bloco+H_BLOCK+8)) && (x_ball >= x_bloco - W_BLOCK) && (x_ball <= x_bloco + W_BLOCK));

always @(posedge clock) begin
  if (reset) begin
    endgame = 0;
    estado = 0;
    x_bloco = 64;             // MUDAR PARA CADA BLOCO!
    y_bloco = 6;
  end
  else begin
    case(estado)
      0: begin
        x_bloco = x_bloco;             // MUDAR PARA CADA BLOCO!
        y_bloco = y_bloco;
        if(start) begin
          estado = 1;
        end
      end
      1: begin
        
      end
      2: begin
        
      end
    endcase
  end
end

case(estado)
      0: begin
        if(start && !endgame) begin
            if(hit_bloco) estado = 1;                       // bateu na barra
            else estado = 2;
        end
        else if (start && endgame) begin
          estado = 0;
        end
        else begin
          endgame = 0;
          estado = 0;
          x_bloco = 64;  // MUDAR PARA CADA BLOCO!
          y_bloco = 6;
        end
      end
      1: begin // bateu na barra 
        vy_mod = vy_mod * (-1);         // vai pra cima
        if (hit_left) begin
          if(vx_mod > 0) vx_mod = vx_mod - 1;
          else vx_mod = vx_mod + 1;
        end
        else if (hit_right) begin
          if(vx_mod > 0) vx_mod = vx_mod + 1;
          else vx_mod = vx_mod - 1;
        end
        else if(hit_center) begin
          if(vx_mod > 0) vx_mod = vx_mod + 1;
          else if(vx_mod < 0) vx_mod = vx_mod - 1;
          else vx_mod = 0;
        end
        estado = 6;
      end
      2: begin      // meramente continua
            if(move) begin
                x_bloco = x_bloco + 6;
                y_bloco = y_bloco + 6;
                estado = 0;
            end
            else estado = 6;
      end
      default: estado = 0;
    endcase




endmodule