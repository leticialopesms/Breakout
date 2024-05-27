module bloco(
    input clock,
    input reset,
    input start,
    input [9:0] x_i,
    input [9:0] y_i,
    input [9:0] x_ball,
    input [9:0] y_ball,
    output reg [9:0] x_block,
    output reg [9:0] y_block,
    output wire hit_block,
    output wire endgame
);

// parametros para os tamanhos da bola, barra e bloco
parameter R_BALL = 8;   // raio da bolinha
parameter H_BAR = 8;    // metade da altura da barra
parameter W_BAR = 64;   // metade da largura da barra
parameter H_BLOCK = 8;  // metade da altura do bloco
parameter W_BLOCK = 32; // metade da largura do bloco

// variável estado para a máquina de estados
reg [3:0] estado;

wire move;

// preisamos de um timer pq o bloco vai se mover (descer)
// timer_block t (
//   .clock(clock),
//   .reset(reset),
//   .pulse(move)
// );

// verificar isso aqui
assign hit_block_down = ((y_ball <= (y_block+H_BLOCK+R_BALL)) && (x_ball >= x_block-W_BLOCK) && (x_ball <= x_block+W_BLOCK));
assign hit_block_up = ((y_ball >= (y_block-H_BLOCK-R_BALL)) && (x_ball >= x_block-W_BLOCK) && (x_ball <= x_block+W_BLOCK));
assign hit_block_right = ((x_ball <= x_block+W_BLOCK+R_BALL) && (y_ball >= y_block-H_BLOCK) && (y_ball <= y_block+H_BLOCK));
assign hit_block_left = ((x_ball >= x_block-W_BLOCK-R_BALL) && (y_ball >= y_block-H_BLOCK) && (y_ball <= y_block+H_BLOCK));
assign hit_block = (hit_block_down || hit_block_up || hit_block_left || hit_block_right);

assign endgame = (y_block >= (480-16));

always @(posedge clock) begin
  if (reset) begin
    // endgame = 0;
    estado = 0;
    x_block = x_i;             // MUDAR PARA CADA BLOCO!
    y_block = y_i;
  end
  else begin
    case(estado)
      0: begin
        x_block = x_block;             // MUDAR PARA CADA BLOCO!
        y_block = y_block;
        if(start) begin
          estado = 0;
        end
      end
      1: begin
        
      end
      2: begin
        
      end
    endcase
  end
end

// case(estado)
//       0: begin
//         if(start && !endgame) begin
//             if(hit_block) estado = 1;                       // bateu na barra
//             else estado = 2;
//         end
//         else if (start && endgame) begin
//           estado = 0;
//         end
//         else begin
//           endgame = 0;
//           estado = 0;
//           x_block = 64;  // MUDAR PARA CADA BLOCO!
//           y_block = 6;
//         end
//       end
//       1: begin // bateu na barra 
//         vy_mod = vy_mod * (-1);         // vai pra cima
//         if (hit_left) begin
//           if(vx_mod > 0) vx_mod = vx_mod - 1;
//           else vx_mod = vx_mod + 1;
//         end
//         else if (hit_right) begin
//           if(vx_mod > 0) vx_mod = vx_mod + 1;
//           else vx_mod = vx_mod - 1;
//         end
//         else if(hit_center) begin
//           if(vx_mod > 0) vx_mod = vx_mod + 1;
//           else if(vx_mod < 0) vx_mod = vx_mod - 1;
//           else vx_mod = 0;
//         end
//         estado = 6;
//       end
//       2: begin      // meramente continua
//             if(move) begin
//                 x_block = x_block + 6;
//                 y_block = y_block + 6;
//                 estado = 0;
//             end
//             else estado = 6;
//       end
//       default: estado = 0;
//     endcase

endmodule