#variable declration
set clock_period 4.2
set worst NangateOpenCellLibrary_ss0p95vn40c
set typical NangateOpenCellLibrary_tt1p1v25c

#clock creation
create_clock -name clk -period $clock_period [get_ports clk]
#stop making buffers in this stage before cts and reset
set_dont_touch_network [get_ports clk]
set_dont_touch_network [get_ports reset]
 
#driving cell is flipflop
set_driving_cell -library $worst -lib_cell DFFRS_X1 -pin Q [get_ports Instr]
#set load capacitance worst as possible
set_load 10 [all_outputs]
#input and output delay 
set_input_delay -max 0.5 -clock clk [remove_from_collection [all_inputs] [get_ports clk]]
set_output_delay -max  0.5 -clock clk [all_outputs]

