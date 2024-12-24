module top_module(
    input clk,          // System clock
    input reset,        // Reset signal
    input rx,           // UART receive line
    input read_request, // Signal to request a read operation
    input [15:0] addr,  // Address for read operations
    output [7:0] data_out,  // Data output from BRAM
    output image_written,   // Flag indicating image is completely written
    output read_enable      // Signal indicating memory is readable
);

    // Internal signals
    wire [7:0] received_data;
    wire valid_data;

    reg [15:0] write_address;
    reg write_enable;

    reg [15:0] pixel_counter; // Counter to track received pixels

    // Instantiate UART receiver
    uart_receiver uart_inst (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .data_out(received_data),
        .valid(valid_data)
    );

    // Instantiate BRAM storage
    bram_storage bram_inst (
        .clk(clk),
        .write_enable(write_enable),
        .data_in(received_data),
        .addr(write_address),
        .data_out(data_out),
        .image_written(image_written),
        .read_request(read_request),
        .read_enable(read_enable)
    );

    // Control logic for receiving and writing image data
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            write_address <= 16'd0;
            write_enable <= 1'b0;
            pixel_counter <= 16'd0;
        end else begin
            if (valid_data && pixel_counter < 16'd784) begin
                write_enable <= 1'b1;           // Enable writing to BRAM
                write_address <= pixel_counter; // Set write address
                pixel_counter <= pixel_counter + 1; // Increment pixel counter
            end else begin
                write_enable <= 1'b0;           // Disable writing to BRAM
            end
        end
    end

endmodule
