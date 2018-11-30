set_property SRC_FILE_INFO {cfile:c:/Users/blade/Desktop/thinpad_top-rev.2/thinpad_top-rev.2/thinpad_top.srcs/sources_1/ip/pll_example/pll_example.xdc rfile:../thinpad_top.srcs/sources_1/ip/pll_example/pll_example.xdc id:1 order:EARLY scoped_inst:clock_gen/inst} [current_design]
set_property SRC_FILE_INFO {cfile:C:/Users/blade/Desktop/thinpad_top-rev.2/thinpad_top-rev.2/thinpad_top.srcs/constrs_1/new/thinpad_top.xdc rfile:../thinpad_top.srcs/constrs_1/new/thinpad_top.xdc id:2} [current_design]
set_property src_info {type:SCOPED_XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk_in1]] 0.2
set_property src_info {type:XDC file:2 line:2 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict {PACKAGE_PIN D18 IOSTANDARD LVCMOS33} [get_ports clk_50M] ;#50MHz main clock in
set_property src_info {type:XDC file:2 line:4 export:INPUT save:INPUT read:READ} [current_design]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets clk_11M0592_IBUF]
set_property src_info {type:XDC file:2 line:18 export:INPUT save:INPUT read:READ} [current_design]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets clock_btn_IBUF]
