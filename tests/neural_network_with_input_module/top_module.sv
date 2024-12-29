module top_module(
    input clk,          // System clock
    input reset,        // Reset signal
    input rx,           // UART receive line
    input read_request,
    output image_written,  
    output read_enable, 
    output NN_done,
    output [3:0] digit_out
);

    // Internal signals
    wire [7:0] received_data;
    reg [7:0] data_latched;
    wire valid_data;

    reg [15:0] write_address;
    reg [15:0] read_address;
    reg write_enable;
    reg already_done;

    wire [3:0] digit_out;
    wire [7:0] data_out;
    wire NN_done;
    reg enable;
    reg [7:0] img [0:783]; 

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
        .readaddr(read_address),
        .reset(reset),
        .data_out(data_out),
        .image_written(image_written),
        .read_request(read_request),
        .read_enable(read_enable)
    );

    neural_network NN(
        .clk(clk),
        .enable(enable), 
        .reset(reset),
        .img(img), 
        .digit_out(digit_out), 
        .NN_done(NN_done));

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            write_address <= 16'd0;
            write_enable <= 1'b0;
            pixel_counter <= 16'd0;
            already_done <= 1'b0;
        end else begin
            if (valid_data && pixel_counter < 16'd784) begin
                if(!already_done) begin
                    already_done <= 1'b1;
                    write_enable <= 1'b1;           // Enable writing to BRAM
                    write_address <= pixel_counter; // Set write address
                    pixel_counter <= pixel_counter + 1; // Increment pixel counter
//                    $display(" Recieved_data in top_module is : %d", received_data); 
                end              
            end else begin
                 already_done <= 1'b0;
                write_enable <= 1'b0;           
            end
        end
    end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        read_address <= 16'd0;
    end else if (image_written && read_address < 16'd784) begin
//        img[read_address-1] <= data_out;  
        img[read_address-1] <= data_out;          
        $display("Recreating img[%d]: %d", read_address, data_out );
        read_address <= read_address + 1; 
    end else if (image_written && read_address == 16'd784) begin
//        $display("Image recreation complete.");
           img[783]<=0;
           enable <= 1'b1;
    end
end


endmodule
