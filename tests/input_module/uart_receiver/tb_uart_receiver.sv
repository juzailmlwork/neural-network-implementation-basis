`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/15/2024 08:14:25 AM
// Design Name: 
// Module Name: tb_uart_receiver
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_uart_receiver();
    reg clk;
    reg reset;
    reg rx;
    wire [7:0] data_out;
    wire valid;

    uart_receiver uut (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .data_out(data_out),
        .valid(valid)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz clock
    end

    initial begin
        // Test sequence
        reset = 1; #10;
        reset = 0; #10;

        // Send UART data (8N1 format: start bit, 8 data bits, stop bit)
        send_uart_byte(8'hAB); // Example: Send 0xAB
        #200;

        send_uart_byte(8'hCD); // Example: Send 0xCD
        #200;

        $stop; // End simulation
    end

    task send_uart_byte(input [7:0] byte);
        integer i;
        begin
            rx = 0; // Start bit
            #8680; // Wait one baud (115200 baud at 100 MHz clock)

            for (i = 0; i < 8; i = i + 1) begin
                rx = byte[i];
                #8680;
            end

            rx = 1; // Stop bit
            #8680;
        end
    endtask
endmodule

