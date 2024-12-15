`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/15/2024 09:43:23 AM
// Design Name: 
// Module Name: bram_storage
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


module bram_storage(
    input clk,
    input write_enable,
    input [7:0] data_in,
    input [15:0] addr,
    output reg [7:0] data_out
);
    reg [7:0] memory [0:65535]; // 64 KB memory

    always @(posedge clk) begin
        if (write_enable) begin
            memory[addr] <= data_in; // Write data
        end
        data_out <= memory[addr];    // Read data
    end
endmodule

