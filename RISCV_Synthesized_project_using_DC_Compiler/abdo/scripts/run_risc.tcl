#variable used to deal with design
set design_name "RISC_v"

#prepare folders for outputs
file mkdir ../${design_name}
file mkdir ../${design_name}/outputs/
file mkdir ../${design_name}/reports/
#remove library and create it
sh rm -rf work
sh mkdir -p work

#read_file -format verilog  ../src/${design_name}.v
#check syntax
analyze -library work -format verilog "../src/RISCV/${design_name}.v"
#elaboration and mapping to gtech 
elaborate ${design_name}  -library work 
#link to link library 
link
#check our design from errors and warnings 
check_design
#load constraints
source ../cons/const_RISC.tcl

  

compile -map_effort medium
report_timing
#output the reports
report_area > ../${design_name}/reports/synth_area.rpt
report_cell > ../${design_name}/reports/synth_cells.rpt
report_qor  > ../${design_name}/reports/synth_qor.rpt
report_resources > ../${design_name}/reports/synth_resources.rpt
report_timing -max_paths 10 > ../${design_name}/reports/synth_timing.rpt 




define_name_rules  no_case -case_insensitive
change_names -rule no_case -hierarchy
change_names -rule verilog -hierarchy
set verilogout_no_tri	 true
set verilogout_equation  false

#outputs
write -f ddc -hierarchy -output ../${design_name}/outputs/${design_name}.ddc   
write_sdf "../${design_name}/outputs/${design_name}.sdf" 
write -hierarchy -format verilog -output ../${design_name}/outputs/syn_${design_name}.v




