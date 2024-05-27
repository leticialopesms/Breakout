module move_bar(
    input clock,
    input reset,
    input left,          // move_left
    input right,         // move_right
    output wire [9:0]x,
    output wire [9:0]y
);

// parametros para os limites do monitor (até onde o quadrado pode ir)
parameter H_BAR = 8;    // metade da altura da barra
parameter W_BAR = 64;   // metade da largura da barra
parameter LIM_LEFT = W_BAR;
parameter LIM_RIGHT = (640 - W_BAR);

// variável estado para a máquina de estados
reg [3:0] estado;

// coordenadas do centro do quadrado
reg [9:0] x_pos;
reg [9:0] y_pos;

wire move;

timer t (.clock(clock), .reset(reset), .pulse(move));

always @(posedge clock) begin
  if (reset) begin
    estado = 0;
    x_pos = 320;
    y_pos = 464;
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
          if (x_pos > LIM_LEFT) begin // caso em que dá pra andar pra esquerda
            x_pos = x_pos - 4;
          end
          else begin // caso em que chegou no limite da esquerda (vai pra direita)
            x_pos = x_pos;
          end
          estado = 0;
        end 
        else begin
          estado = 1;
        end
      end

      2: begin
        if (move) begin
          if (x_pos < LIM_RIGHT) begin // caso em que dá pra andar pra direita
            x_pos = x_pos + 4;
          end
          else begin // caso em que chegou no limite da direita (vai pra esquerda)
            x_pos = x_pos;
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

assign x = x_pos;
assign y = y_pos;

endmodule