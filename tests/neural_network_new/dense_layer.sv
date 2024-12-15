`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.01.2023 23:47:02
// Design Name: 
// Module Name: dense_layer
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

/**********
* Dense layer implementation
*
* Parameters: NEURON_NB => The # of neurons
*             IN_SIZE => The input vector size
*             WIDTH => The width of the weights and biases
*
* Inputs: clk => clock signal, layer_en => enable signal, 
*         reset => active high sync reset signal, in_data => in vector, 
*         weights => neurons weights, biases => neurons biases
*
* Outputs: neuron_out => dense layer output
*          layer_done => done signal
* 
***********/

module dense_layer #(
    parameter NEURON_NB = 32, 
    parameter IN_SIZE = 196, 
    parameter WIDTH = 8
)(
    input clk,
    input layer_en,
    input reset,
    input signed [2*WIDTH-1:0] in_data [0:IN_SIZE-1],
    input signed [WIDTH-1:0] weights [0:NEURON_NB-1][0:IN_SIZE-1],
    input signed [WIDTH-1:0] biases [0:NEURON_NB-1],
    output signed [4*WIDTH-1:0] neuron_out [0:NEURON_NB-1],
    output layer_done
);

    reg [0:NEURON_NB-1] neuron_done;
    reg done = 0;

    // Generate block for instantiating multiple neurons
    genvar i;
    generate
        for (i = 0; i < NEURON_NB; i = i + 1) begin : neuron_gen
            neuron #(
                .IN_SIZE(IN_SIZE), 
                .WIDTH(WIDTH)
            ) dense_neuron (
                .clk(clk), 
                .en(layer_en), 
                .reset(reset), 
                .in_data(in_data), 
                .weight(weights[i]),  // Pass weights for the i-th neuron
                .bias(biases[i]),     // Pass bias for the i-th neuron
                .neuron_out(neuron_out[i]), 
                .neuron_done(neuron_done[i])
            );
        end
    endgenerate

    // Monitor when all neurons have completed processing
    always @(posedge clk) begin
        if (reset) begin
            done <= 0;
        end else if (neuron_done == {NEURON_NB{1'b1}}) begin
            done <= 1;  // All neurons completed
        end
    end

    assign layer_done = done;

endmodule