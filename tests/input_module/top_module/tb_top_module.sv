module tb_top_module;
    reg clk;
    reg reset;
    reg rx;
    reg read_request;
    reg [15:0] addr;
    wire [7:0] data_out;
    wire image_written;
    wire read_enable;

    top_module uut (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .read_request(read_request),
        .addr(addr),
        .data_out(data_out),
        .image_written(image_written),
        .read_enable(read_enable)
    );

    initial begin
        clk = 0;
        reset = 1;
        rx = 1; // Idle state
        read_request = 0;
        addr = 0;

        #20 reset = 0;

        // Transmit 784 bytes
        repeat (784) begin
            #104167 rx = 0; // Start bit
            #104167 rx = $random % 2; // Data bits
            #104167 rx = 1; // Stop bit
        end

        // Wait for image to be written
        wait(image_written);

        // Read data
        #10 read_request = 1;
        addr = 16'd0;
        repeat (784) begin
            #10 addr = addr + 1;
        end

        #10 $finish;
    end

    always #5 clk = ~clk; // 100 MHz clock
endmodule
