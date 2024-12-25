module bram_storage(
    input clk,
    input write_enable,
    input [7:0] data_in,
    input [15:0] addr,
    input [15:0] readaddr,
    output reg [7:0] data_out,
    output reg image_written,    // Flag indicating image is completely written
    input read_request,          // Signal to request a read operation
    output reg read_enable       // Signal indicating memory is readable
);
    reg [7:0] memory [0:2048];  // 64 KB memory
    reg [15:0] write_counter;    // Counter to track number of writes
    reg [15:0] previous_addr;

    initial begin
        write_counter = 0;
        image_written = 0;
        read_enable = 0;
        previous_addr = 16'hFFFF;
    end

    always @(posedge clk) begin
        if (write_enable) begin
            if(addr != previous_addr) begin
                previous_addr = addr;
                $display("uploading data to memory: %d at address %d write counter is %d", data_in,addr,write_counter);
                memory[addr] <= data_in;   // Write data to memory
                write_counter <= write_counter + 1; // Increment write counter
        end
            // When all 784 pixels are written, set flags
            if (write_counter == 16'd783) begin
                image_written <= 1;    // Indicate image write completion
                read_enable <= 1;      // Enable reading
            end
        end

        // Allow reading only if read_enable is set and a read_request is made
        if (read_enable && read_request) begin
            data_out <= memory[readaddr]; // Read data from memory
            $display("data from memory: %d at addr %d", data_out,readaddr);
        end else begin
            data_out <= 8'hZZ;        // Tri-state output if not readable
        end
    end
endmodule
