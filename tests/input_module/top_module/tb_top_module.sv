`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/15/2024 09:57:02 AM
// Design Name: 
// Module Name: tb_top_module
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


module tb_top_module();
    reg clk;
    reg reset;
    reg rx;
    wire [7:0] led;

    top_module uut (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .led(led)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz clock
    end

    initial begin
        // Initialize inputs
        reset = 1;
        rx = 1; // Idle UART line
        #10;

        reset = 0;
        #10;

        // Simulate sending data
        send_uart_byte(8'h56); // Example: Send 0x56
        #200;

        send_uart_byte(8'h78); // Example: Send 0x78
        #200;

        $stop; // End simulation
    end

    task send_uart_byte(input [7:0] byte);
        integer i;
        begin
            rx = 0; // Start bit
            #8680;

            for (i = 0; i < 8; i = i + 1) begin
                rx = byte[i];
                #8680;
            end

            rx = 1; // Stop bit
            #8680;
        end
    endtask
endmodule
