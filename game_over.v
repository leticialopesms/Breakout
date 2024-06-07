module game_over(
    input clock,
    input reset,
    input [9:0] pixel_x,
    input [9:0] pixel_y,
    output reg [7:0] red,
    output reg [7:0] green,
    output reg [7:0] blue
    );

    // Posições e tamanhos da mensagem "GAME OVER"
    localparam MSG_X = 200;
    localparam MSG_Y = 150;
    localparam CHAR_W = 8;
    localparam CHAR_H = 16;

    // Defina a matriz de caracteres "GAME OVER" (8x16 cada caractere)
    reg [127:0] font_rom [0:7];  // cada caractere 8x16 pixels

    initial begin
        // G
        font_rom[0] = 128'h1E33331F03030303;
        // A
        font_rom[1] = 128'h0E33333E33333333;
        // M
        font_rom[2] = 128'h333333333F3F3333;
        // E
        font_rom[3] = 128'h3F03033F03030303;
        // (space)
        font_rom[4] = 128'h0000000000000000;
        // O
        font_rom[5] = 128'h1E3333333333331E;
        // V
        font_rom[6] = 128'h3333333333331E0C;
        // R
        font_rom[7] = 128'h1F33331F0B0B0B0B;
    end

    // Calcula a posição na mensagem
    wire [9:0] msg_x = pixel_x - MSG_X;
    wire [9:0] msg_y = pixel_y - MSG_Y;

    always @(posedge clock) begin
        if (reset) begin
            red = 8'b00000000;
            green = 8'b00000000;
            blue = 8'b00000000;
        end
        else if (pixel_x >= MSG_X && pixel_x < MSG_X + 64 && pixel_y >= MSG_Y && pixel_y < MSG_Y + 16) begin
            // Verifique o caractere e o pixel correspondente
            if (font_rom[msg_x[6:3]][msg_y[3:0] * 8 + msg_x[2:0]]) begin
                red = 8'b11111111;  // Branco
                green = 8'b11111111;  // Branco
                blue = 8'b11111111;  // Branco
            end
            else begin
                red = 8'b00000000;  // Preto
                green = 8'b00000000;  // Preto
                blue = 8'b00000000;  // Preto
            end
        end else begin
            red = 8'b00000000;  // Preto
            green = 8'b00000000;  // Preto
            blue = 8'b00000000;  // Preto
        end
    end
endmodule
