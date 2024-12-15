`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/15/2024 09:55:55 AM
// Design Name: 
// Module Name: top_module
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


module top_module(
    input clk,
    input reset,
    input rx,
    output [7:0] led // Display received data on LEDs
);
    wire [7:0] uart_data;
    wire valid;
    reg [15:0] addr = 0;
    reg write_enable;

    // Instantiate UART receiver
    uart_receiver uart(
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .data_out(uart_data),
        .valid(valid)
    );

    // Instantiate BRAM
    bram_storage bram(
        .clk(clk),
        .write_enable(write_enable),
        .data_in(uart_data),
        .addr(addr),
        .data_out()
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            addr <= 0;
            write_enable <= 0;
        end else if (valid) begin
            write_enable <= 1;
            addr <= addr + 1; // Increment address for the next byte
        end else begin
            write_enable <= 0;
        end
    end

    assign led = uart_data; // Show received byte on LEDs
endmodule

