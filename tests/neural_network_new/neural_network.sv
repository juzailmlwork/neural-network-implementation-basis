`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// Module Name: neural_network
//////////////////////////////////////////////////////////////////////////////////

/**********
* Neural Network implementation
*
* Inputs: clk => clock signal, enable => NN enable signal, img => in vector, 
*
* Outputs: digit out => handwritten digit
*          NN_done => done signal
* 
***********/

module neural_network(
    input clk,
    input enable,
    input reset,
    //input [7:0] img [0:783],
    output [7:0] digit_out,
    output NN_done
    );
    
    /* Average pooling layer */
    
    reg pool_enable;
    wire finished_pool;
    reg signed [15:0] pool [0:195];
    reg signed [7:0] img [0:783];
    
    // Pixel value registers
    wire signed [7:0] pool_in1;
    wire signed [7:0] pool_in2;
    wire signed [7:0] pool_in3;
    wire signed [7:0] pool_in4;
    wire signed [7:0] pool_final;
    
    // Pixel address registers
    reg [15:0] pool_in1_addr;
    reg [15:0] pool_in2_addr;
    reg [15:0] pool_in3_addr;
    reg [15:0] pool_in4_addr;
    reg [15:0] pool_final_addr = 0;
    reg [15:0] pool_addr = 0;
    reg [15:0] pool_row = 0;
    
    // Initialize addresses
    initial
    begin
        pool_in1_addr <= 8'b0000_0000;
        pool_in2_addr <= 8'b0000_0001;
        pool_in3_addr <= 8'b0001_1100;
        pool_in4_addr <= 8'b0001_1101;
        pool_enable <= 1'b1;
        img  = '{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 31, 97, 31, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 16, 93, 31, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 98, 127, 27, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 20, 113, 120, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 19, 126, 64, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 67, 127, 57, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 60, 127, 45, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 110, 127, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 67, 127, 45, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 40, 126, 90, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 113, 124, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 101, 127, 33, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 115, 124, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 127, 127, 33, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 115, 124, 0, 36, 76, 0, 0, 0, 0, 0, 0, 0, 0, 127, 116, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 115, 126, 120, 123, 28, 0, 0, 0, 0, 0, 0, 0, 0, 124, 127, 57, 3, 0, 5, 7, 7, 7, 7, 10, 55, 55, 37, 87, 124, 126, 88, 26, 0, 0, 0, 0, 0, 0, 0, 0, 0, 37, 122, 127, 102, 86, 115, 127, 127, 127, 127, 127, 127, 105, 88, 57, 86, 126, 31, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32, 92, 105, 105, 88, 85, 105, 71, 57, 55, 9, 4, 0, 0, 67, 127, 45, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 47, 127, 65, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 19, 127, 93, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 19, 127, 98, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 105, 127, 14, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32, 127, 105, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 40, 110, 63, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
        img = '{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 69, 100, 126, 127, 116, 53, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 109, 126, 126, 105, 103, 107, 126, 59, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 69, 126, 116, 44, 3, 0, 6, 101, 64, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 21, 126, 126, 91, 0, 0, 0, 0, 79, 14, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 58, 126, 126, 39, 0, 0, 0, 0, 31, 21, 110, 53, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 58, 127, 116, 19, 0, 0, 0, 0, 3, 106, 126, 115, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 21, 126, 126, 77, 15, 0, 0, 4, 77, 126, 126, 115, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 111, 126, 126, 113, 92, 66, 98, 126, 126, 126, 99, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 12, 59, 80, 118, 126, 126, 126, 113, 80, 122, 58, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 79, 0, 0, 30, 42, 37, 11, 8, 0, 89, 110, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 64, 5, 0, 0, 0, 0, 0, 0, 0, 0, 115, 115, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 46, 126, 58, 0, 0, 0, 0, 0, 0, 0, 0, 78, 115, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 46, 126, 58, 0, 0, 0, 0, 0, 0, 0, 0, 58, 118, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 67, 126, 31, 0, 0, 0, 0, 0, 0, 0, 0, 58, 117, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 51, 126, 58, 0, 0, 0, 0, 0, 0, 0, 0, 110, 120, 21, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 46, 126, 122, 30, 0, 0, 0, 0, 0, 19, 116, 126, 110, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 17, 108, 126, 118, 64, 4, 0, 0, 15, 77, 126, 115, 21, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 42, 126, 126, 126, 98, 40, 92, 114, 126, 113, 65, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28, 109, 126, 126, 126, 126, 126, 126, 59, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 27, 89, 73, 95, 58, 11, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

    end
    
    avg_pooling AvgPooling(clk,pool_enable,pool_in1,pool_in2,pool_in3,pool_in4,pool_final,finished_pool);
    
    // Load pixel values
    assign pool_in1 = ((img[pool_in1_addr]));
    assign pool_in2 = ((img[pool_in2_addr]));
    assign pool_in3 = ((img[pool_in3_addr]));
    assign pool_in4 = ((img[pool_in4_addr]));
    
    always @(posedge clk) begin
    if(reset) begin
        pool_in1_addr <= 8'b0000_0000;
        pool_in2_addr <= 8'b0000_0001;
        pool_in3_addr <= 8'b0001_1100;
        pool_in4_addr <= 8'b0001_1101;
        pool_final_addr <= 0;
        pool_row <= 0;
        pool_addr <= 0;
        pool_enable <= 1'b1; 
    end
    else if(enable) begin
        if(finished_pool) begin // Average done
            pool[pool_final_addr] = pool_final;
            pool_addr = pool_addr + 2; // Increment address
            pool_row = pool_row + 2;
            if(pool_row == 28) begin // End of row, go down by 2 rows
                pool_addr = pool_addr + pool_row;
                pool_row = 0;
            end
            if(pool_in4_addr == 783) begin // Global averaging done
                pool_enable <= 0;
            end
            else if(pool_in4_addr != 783) begin // Update addresses
                pool_in1_addr <= pool_addr;
                pool_in2_addr <= pool_addr + 1;
                pool_in3_addr <= pool_addr + 28;
                pool_in4_addr <= pool_addr + 29;
                pool_final_addr <= pool_final_addr + 1;
            end
        end
    end       
    end
    
    /* Hidden layer */
    
    reg dense1_enable;
    wire finished_dense1;
    reg signed [15:0] dense1_res [0:31];
    initial dense1_enable <= 0;
    
    dense_layer1 layer2 (.clk(clk), .enable(dense1_enable), .reset(reset), .pooled_img(pool), .layer_out(dense1_res), .layer_done(finished_dense1));

    always @(posedge clk) begin
        if(reset) begin
            dense1_enable <= 0;
        end
        else if(enable) begin
            if(pool_enable == 0 && finished_dense1 == 0) begin // Pooling done
                dense1_enable <= 1;
            end
            else dense1_enable <= 0; // Hidden layer done
        end
    end
    
    /* Output layer */
    
    reg dense2_enable;
    wire finished_dense2;
    reg signed [15:0] dense2_res [0:9];
    initial dense2_enable <= 0;

    dense_layer2 layer3 (.clk(clk), .enable(dense2_enable), .reset(reset), .in_data(dense1_res), .layer_out(dense2_res), .layer_done(finished_dense2));

    always @(posedge clk) begin
        if(reset) begin
            dense2_enable <= 0;
        end
        else if(enable) begin
            if(pool_enable == 0 && finished_dense1 == 1 && finished_dense2 == 0) begin // Previous layers done
                dense2_enable <= 1;
            end
            else dense2_enable <= 0; // Output layer done
        end
    end
    
    /* Handwritten digit selection layer */
    
    reg max_enable;
    wire digit_recog_done;
    reg [7:0] digit;
    
    initial max_enable <= 0;
    
    select_max last_layer (.clk(clk), .enable(max_enable), .reset(reset), .in_data(dense2_res), .digit(digit), .layer_done(digit_recog_done));
        
    always @(posedge clk) begin
        if(reset) begin
            max_enable <= 0;
        end
        else if(enable) begin
            if(finished_dense2 == 1) begin // Output layer done
                max_enable <= 1;
            end
            else max_enable <= 0;
        end
    end
    
    assign digit_out = digit;
    assign NN_done = digit_recog_done;
    
endmodule
