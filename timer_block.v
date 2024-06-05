module timer_block (
    input clock,
    input reset,
    output pulse
);

parameter [30:0] PULSE_TIME = 10_000_000;
reg [30:0] contador;

assign pulse = (contador == PULSE_TIME);

always@(posedge clock) begin
    if (reset) begin
        contador = 0;
    end
    else begin
        if (contador == PULSE_TIME) 
            contador = 0;
        else
          contador = contador + 1;
    end
end

endmodule