module tb_bram_storage();
    reg clk;
    reg write_enable;
    reg [15:0] addr;
    reg [7:0] data_in;
    wire [7:0] data_out;

    bram_storage uut (
        .clk(clk),
        .write_enable(write_enable),
        .data_in(data_in),
        .addr(addr),
        .data_out(data_out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz clock
    end

    initial begin
        // Test writing to BRAM
        write_enable = 1;
        addr = 16'h0000;
        data_in = 8'h12;
        #10; // Wait for 10ns

        addr = 16'h0001;
        data_in = 8'h34;
        #10; // Wait for 10ns

        // Test reading from BRAM
        write_enable = 0;
        addr = 16'h0000;
        #10; // Wait for 10ns

        addr = 16'h0001;
        #10; // Wait for 10ns

        $stop; // End simulation
    end
endmodule
