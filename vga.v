module vga (
    input wire clock,       // 50 MHz
    input wire reset,
    output [9:0] next_x,    // x-coordinate of NEXT pixel that will be drawn
    output [9:0] next_y,    // y-coordinate of NEXT pixel that will be drawn
    output vga_hs,          // HSYNC (to VGA connector)
    output vga_vs,          // VSYNC (to VGA connector)
    output vga_sync_n,      // SYNC to VGA connector
    output vga_blank_n,     // BLANK to VGA connector
    output active 
);


    parameter [9:0] H_TOTAL = 10'd800;
    // parametros horizontais
    parameter [9:0] H_ACTIVE = 10'd640; // c
    parameter [9:0] H_FRONT =  10'd16;  // d
    parameter [9:0] H_PULSE =  10'd96;  // a
    parameter [9:0] H_BACK =  10'd48;   // b

    parameter [9:0] V_TOTAL = 10'd525;
    // parametros verticais
    parameter [9:0] V_ACTIVE = 10'd480; // c
    parameter [9:0] V_FRONT =  10'd10;  // d
    parameter [9:0] V_PULSE =  10'd2;   // a
    parameter [9:0] V_BACK  =  10'd33;  // b


    // Contadores x e y
    reg [9:0] x; // h_counter
    reg [9:0] y; // v_counter
    always@(posedge clock) begin
        if (reset) begin
            x = 0;
            y = 0;
        end
        else begin
            x = x + 1;
            if (x == H_TOTAL) begin
                x = 0;
                y = y + 1;
                if (y == V_TOTAL) begin
                    y = 0;
                end
            end
        end
    end

    assign vga_hs = (x < H_PULSE) ? 0 : 1;
    assign vga_vs = (y < V_PULSE) ? 0 : 1;
    assign active = ((x > H_PULSE + H_BACK) && (y > V_PULSE + V_BACK)) && ((x < H_PULSE + H_BACK + H_ACTIVE) && (y < V_PULSE + V_BACK + V_ACTIVE));


    assign vga_sync_n = 0;
    assign vga_blank_n = active;
    
    assign next_x = x-H_PULSE-H_BACK;
    assign next_y = y-V_PULSE-V_BACK;

endmodule