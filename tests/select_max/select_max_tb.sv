`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.12.2024 05:10:23
//////////////////////////////////////////////////////////////////////////////////


module select_max_tb;

logic signed [15:0] test_data_a [0:9] = {0,0,5,85,0,10,0,0,0,0};

localparam period = 20;
reg clk, enable, reset, layer_done;  
reg signed [15:0] in_data [0:9];
reg signed [15:0] max;
reg [7:0] digit;

select_max s_max(.clk(clk), .reset(reset), .enable(enable), .in_data(in_data),
                 .digit(digit), .layer_done(layer_done),.max(max));

initial begin
clk = 0;
enable = 0;
reset = 0;
in_data = test_data_a;
#145
enable = 1;
#2500

if (layer_done) begin
    if (digit == 3) begin
        $display("max index is :  %d", digit);
    end
end

end

always begin
#10 clk = ~clk;
end


endmodule
