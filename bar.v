module bar(
    input clock,
    input reset,
    input left,          // move_left
    input right,         // move_right
    input [9:0] next_x,
    input [9:0] next_y,
    output wire [9:0]x,
    output wire [9:0]y,
    output wire area
);

// parametros para os limites do monitor (até onde o quadrado pode ir)
parameter H_BAR = 8;    // metade da altura da barra
parameter W_BAR = 64;   // metade da largura da barra
parameter LIM_LEFT = W_BAR;
parameter LIM_RIGHT = (640 - W_BAR);

// variável estado para a máquina de estados
reg [3:0] estado;

// coordenadas do centro do quadrado
reg [9:0] x_bar;
reg [9:0] y_bar;

wire move;

timer t (.clock(clock), .reset(reset), .pulse(move));

always @(posedge clock) begin
  if (reset) begin
    estado = 0;
    x_bar = 320;
    y_bar = 464;
  end
  else begin
  // implementação da máquina de estados aqui
  // colocar os estados nos leds
    case(estado)
      0: begin
          case ({!left, !right})
            4'b0010: estado = 1; // left
            4'b0001: estado = 2; // right
            default: estado = 0; // parado
          endcase
      end

      1: begin
        if (move) begin
          if (x_bar > LIM_LEFT) begin // caso em que dá pra andar pra esquerda
            x_bar = x_bar - 4;
          end
          else begin // caso em que chegou no limite da esquerda (vai pra direita)
            x_bar = x_bar;
          end
          estado = 0;
        end 
        else begin
          estado = 1;
        end
      end

      2: begin
        if (move) begin
          if (x_bar < LIM_RIGHT) begin // caso em que dá pra andar pra direita
            x_bar = x_bar + 4;
          end
          else begin // caso em que chegou no limite da direita (vai pra esquerda)
            x_bar = x_bar;
          end
          estado = 0;
        end
        else begin
          estado = 2;
        end
      end
      default: estado = 0;
    endcase
  end
end

assign x = x_bar;
assign y = y_bar;
assign area = ((next_x <= x + W_BAR) && (next_x >= x - W_BAR) && (next_y <= y + H_BAR) && (next_y >= y - H_BAR));

endmodule