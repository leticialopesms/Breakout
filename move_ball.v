module move_ball(
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
parameter LIM_LEFT = R_BALL;
parameter LIM_RIGHT = 640 - R_BALL;
parameter LIM_UP = R_BALL;
parameter LIM_DOWN = 480 - R_BALL;

// parametros para os tamanhos da bola e da barra
parameter R_BALL = 8;   // raio da bolinha
parameter H_BAR = 8;    // metade da altura da barra
parameter W_BAR = 64;   // metade da largura da barra

// variável estado para a máquina de estados
reg [3:0] estado;

// coordenadas do centro da bolinha
reg [9:0] x_ball;
reg [9:0] y_ball;
reg [9:0] vx_mod;   // modulo da velocidade em x
reg [9:0] vy_mod;   // modulo da velocidade em y

// Ideia: colocar velocidade máx para a bolinha

wire move;

timer_ball t (
  .clock(clock),
  .reset(reset),
  .pulse(move)
);

// colocar os parametros pros tamanhos da bola/barra
assign hit_bar = ((y_ball >= LIM_DOWN - (2*H_BAR + 8)) && (x_ball >= x_bar - W_BAR) && (x_ball <= x_bar + W_BAR));
assign hit_center = ((x_ball >= x_bar - 32) && (x_ball <= x_bar + 32));
assign hit_left = ((x_ball >= x_bar - W_BAR) && (x_ball <= x_bar - 32));
assign hit_right = ((x_ball >= x_bar + 32) && (x_ball <= x_bar + W_BAR));


always @(posedge clock) begin
  if (reset) begin
    endgame = 0;
    estado = 0;
    x_ball = 320;
    y_ball = 240;
    vx_mod = 1;
    vy_mod = -1;
  end
  else begin
  // implementação da máquina de estados aqui
  // colocar os estados nos leds
    case(estado)
      0: begin
        if(start && !endgame) begin
            if(hit_bar) estado = 4;                       // bateu na barra
            else if(y_ball <= LIM_UP) estado = 1;         // bateu em cima
            else if(x_ball <= LIM_LEFT) estado = 2;       // bateu na esquerda
            else if(x_ball >= LIM_RIGHT) estado = 3;      // bateu na direita
            else if(y_ball >= LIM_DOWN) estado = 5;       // ENDGAME!
            else estado = 6;
        end
        else if (start && endgame) begin
          estado = 0;
        end
        else begin
          endgame = 0;
          estado = 0;
          x_ball = 320;
          y_ball = 240;
          vx_mod = 1;
          vy_mod = -1;
        end
      end
      1: begin // bateu na borda de cima
        vy_mod = vy_mod * (-1);         // vai pra baixo
        estado = 6;
      end
      2: begin // bateu na borda da esquerda
        vx_mod = vx_mod * (-1);         // vai pra direita
        estado = 6;
      end
      3: begin // bateu na borda da direita
        vx_mod = vx_mod * (-1);         // vai pra esquerda
        estado = 6;
      end
      4: begin // bateu na barra 
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
        //   vy_mod = vy_mod - 1;
        end
        estado = 6;
      end
      5: begin // bateu na borda de baixo (endgame)
        estado = 0; // ideia: o bola fica parada até a peesoa que está jogando
        endgame = 1;
        // apertar em reset ou start novamente
      end
      6: begin         // meramente continua
            if(move) begin
                x_ball = x_ball + vx_mod;
                y_ball = y_ball + vy_mod;
                estado = 0;
            end
            else estado = 6;
      end
      default: estado = 0;
    endcase
  end
end

assign x_p = x_ball;
assign y_p = y_ball;

endmodule