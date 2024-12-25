#create_clock -period 20.000 -name clk -waveform {0.000 10.000} -add clk

set_property PACKAGE_PIN E3 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 20.000 -waveform {0.000 10.000} [get_ports clk]

#set_property PACKAGE_PIN U5 [get_ports {digit_out[3]}]
#set_property PACKAGE_PIN W7 [get_ports {digit_out[2]}]
#set_property PACKAGE_PIN W16 [get_ports {digit_out[1]}]
#set_property PACKAGE_PIN W6 [get_ports {digit_out[0]}]

#set_property PACKAGE_PIN U17 [get_ports reset]
#set_property PACKAGE_PIN U18 [get_ports read_request]
#set_property PACKAGE_PIN T18 [get_ports rx]
#set_property PACKAGE_PIN v8 [get_ports image_written]
#set_property PACKAGE_PIN U7 [get_ports read_enable]
#set_property PACKAGE_PIN V5 [get_ports NN_done]

set_property PACKAGE_PIN A1 [get_ports {digit_out[3]}]
set_property PACKAGE_PIN A3 [get_ports {digit_out[2]}]
set_property PACKAGE_PIN A5 [get_ports {digit_out[1]}]
set_property PACKAGE_PIN A8 [get_ports {digit_out[0]}]

set_property PACKAGE_PIN U17 [get_ports reset]
set_property PACKAGE_PIN U18 [get_ports read_request]
set_property PACKAGE_PIN T18 [get_ports rx]
set_property PACKAGE_PIN A9 [get_ports image_written]
set_property PACKAGE_PIN U7 [get_ports read_enable]
set_property PACKAGE_PIN V5 [get_ports NN_done]


set_property IOSTANDARD LVCMOS33 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports read_request]
set_property IOSTANDARD LVCMOS33 [get_ports rx]
set_property IOSTANDARD LVCMOS33 [get_ports image_written]
set_property IOSTANDARD LVCMOS33 [get_ports read_enable]
set_property IOSTANDARD LVCMOS33 [get_ports NN_done]
set_property IOSTANDARD LVCMOS33 [get_ports {digit_out[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {digit_out[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {digit_out[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {digit_out[0]}]
