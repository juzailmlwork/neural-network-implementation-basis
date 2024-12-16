`timescale 1ns / 1ps

module clock_generator #(
    parameter real CLOCK_PERIOD = 10,   // Clock period in time units
    parameter real RESET_PERIOD = 10    // Reset pulse width in time units
) (
    output reg clock,                 // Clock signal output
    output reg reset                  // Reset signal output
);

    localparam real CLOCK_HALF_PERIOD = CLOCK_PERIOD / 2;  // Half-period for toggling clock
    localparam real RESET_HALF_PERIOD = RESET_PERIOD / 2;  // Half-period for reset pulse

    initial begin
        // Initialize signals
        clock = 0;
        reset = 0;

        // Generate reset pulse
        #RESET_HALF_PERIOD
        reset = 1;
        #RESET_HALF_PERIOD
        reset = 0;

        // Generate clock signal
        forever begin
            #CLOCK_HALF_PERIOD;
            clock = ~clock;
        end
    end

endmodule
