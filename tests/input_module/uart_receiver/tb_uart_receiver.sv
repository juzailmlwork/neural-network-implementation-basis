`timescale 1ns / 1ps

module tb_uart_receiver;

    // Parameters
    parameter CLK_FREQ = 100_000_000; // 100 MHz clock
    parameter BAUD_RATE = 115200;     // Baud rate
    parameter TICK_CNT = CLK_FREQ / BAUD_RATE; // Clock ticks per UART bit

    // Inputs to the UART receiver
    reg clk;
    reg reset;
    reg rx;

    // Outputs from the UART receiver
    wire [7:0] data_out;
    wire valid;

    // Instantiate the uart_receiver module
    uart_receiver #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) uut (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .data_out(data_out),
        .valid(valid)
    );

    // Clock generation (100 MHz)
    initial clk = 0;
    always #5 clk = ~clk; // 100 MHz clock period = 10 ns

    // Task to send a byte via UART
    task send_uart_byte;
        input [7:0] byte_data; // Byte to send
        integer i;
        begin
            // Send start bit (low)
            rx <= 0;
            #(TICK_CNT * 10);

            // Send 8 data bits (LSB first)
            for (i = 0; i < 8; i = i + 1) begin
                rx <= byte_data[i];
                #(TICK_CNT * 10);
            end

            // Send stop bit (high)
            rx <= 1;
            #(TICK_CNT * 10);
        end
    endtask

    // Testbench logic
    integer row, col;
    reg [7:0] pixel_value;

    initial begin
        // Initialize inputs
        reset = 1;
        rx = 1; // Idle state of UART line
        #(TICK_CNT * 10);

        // Release reset
        reset = 0;

        // Simulate sending a 28x28 image (784 pixels)
        for (row = 0; row < 28; row = row + 1) begin
            for (col = 0; col < 28; col = col + 1) begin
                // Generate pixel value (for example, a grayscale gradient)
                pixel_value = row * 28 + col; // Example: linear gradient
                send_uart_byte(pixel_value);

                // Wait for valid signal to ensure receiver processed the byte
                wait(valid);
                if (data_out !== pixel_value) begin
                    $display("Error: Expected %d, Got %d at pixel (%d, %d)", pixel_value, data_out, row, col);
                end else begin
                    $display("Received pixel (%d, %d): %d", row, col, data_out);
                end
            end
        end

        // End simulation
        $finish;
    end

endmodule
