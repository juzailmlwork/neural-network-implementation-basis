module uart_receiver(
    input clk,         // System clock
    input reset,       // Reset signal
    input rx,          // UART receive line
    output reg [7:0] data_out, // Received data byte
    output reg valid   // Signal to indicate valid data
);

    parameter CLK_FREQ = 100000000; // 100 MHz clock
    parameter BAUD_RATE = 115200;

    localparam TICK_CNT = CLK_FREQ / BAUD_RATE; // Clock ticks per UART bit
    localparam TICK_BITS = $clog2(TICK_CNT);

    reg [TICK_BITS-1:0] tick_count;
    reg [3:0] bit_count;  // Count bits in the received byte
    reg [7:0] shift_reg;  // Shift register for incoming bits

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tick_count <= 0;
            bit_count <= 0;
            valid <= 0;
        end else begin
            if (!rx && bit_count == 0) begin // Start bit detected
                tick_count <= TICK_CNT / 2; // Start sampling at the middle
                bit_count <= 1; // Start receiving bits
            end else if (bit_count > 0) begin
                if (tick_count == 0) begin
                    tick_count <= TICK_CNT - 1; // Reset tick count
                    shift_reg <= {rx, shift_reg[7:1]}; // Shift in next bit
                    bit_count <= bit_count + 1;

                    if (bit_count == 9) begin // Stop bit received
                        data_out <= shift_reg;
                        valid <= 1; // Signal data ready
                        bit_count <= 0; // Reset for next byte
                    end
                end else begin
                    tick_count <= tick_count - 1;
                end
            end else begin
                valid <= 0;
            end
        end
    end
endmodule
