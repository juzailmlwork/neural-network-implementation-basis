module tb_bram_storage;
    reg clk;
    reg write_enable;
    reg [7:0] data_in;
    reg [15:0] addr;
    wire [7:0] data_out;
    wire image_written;
    reg read_request;
    wire read_enable;

    bram_storage uut (
        .clk(clk),
        .write_enable(write_enable),
        .data_in(data_in),
        .addr(addr),
        .data_out(data_out),
        .image_written(image_written),
        .read_request(read_request),
        .read_enable(read_enable)
    );

    initial begin
        clk = 0;
        write_enable = 0;
        data_in = 0;
        addr = 0;
        read_request = 0;

        // Write 784 bytes
        repeat (784) begin
            #10 write_enable = 1;
            data_in = $random % 256;
            addr = addr + 1;
        end

        #10 write_enable = 0;

        // Read the data back
        #10 read_request = 1;
        addr = 16'd0;
        repeat (784) begin
            #10 addr = addr + 1;
        end

        #10 $finish;
    end

    always #5 clk = ~clk; // 100 MHz clock
endmodule
