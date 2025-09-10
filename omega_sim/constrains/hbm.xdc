

create_clock -period 10 [get_ports APB_0_PCLK]
create_clock -period 10 [get_ports APB_1_PCLK]

create_clock -period 5.000 [get_ports AXI_ACLK_IN_0]
set_property LOC MMCM_X0Y0 [get_cells -hier -filter {NAME =~ u_mmcm_0}]

create_clock -period 5.000 [get_ports AXI_ACLK_IN_1]
set_property LOC MMCM_X0Y1 [get_cells -hier -filter {NAME =~ u_mmcm_1}]

set_property IOSTANDARD LVCMOS12 [get_ports APB_0_PCLK]
set_property IOSTANDARD LVCMOS12 [get_ports APB_0_PRESET_N]
set_property IOSTANDARD LVCMOS12 [get_ports AXI_ACLK_IN_0]
set_property IOSTANDARD LVCMOS12 [get_ports AXI_ARESET_N_0]
set_property IOSTANDARD LVCMOS12 [get_ports APB_1_PCLK]
set_property IOSTANDARD LVCMOS12 [get_ports APB_1_PRESET_N]
set_property IOSTANDARD LVCMOS12 [get_ports AXI_ACLK_IN_1]
set_property IOSTANDARD LVCMOS12 [get_ports AXI_ARESET_N_1]
 
 
  

create_waiver -internal -type CDC -id CDC-12 -description "This is a safe CDC in this design per review with team" -from [get_pins */inst/TWO_STACK.u_hbm_top/TWO_STACK_HBM.hbm_apb_mst_*/apb_switch_r_reg/C] -to [get_pins apb_seq_complete_*_st*_r0_reg/D]
create_waiver -internal -type CDC -id CDC-10 -description "This is a safe CDC in this design per review with team" -from [get_pins */inst/TWO_STACK.u_hbm_top/TWO_STACK_HBM.hbm_apb_mst_*/apb_switch_r_reg/C] -to [get_pins apb_seq_complete_*_st*_r0_reg/D]
create_waiver -internal -type CDC -id CDC-1 -description "This is a safe CDC in this design per review with team" -from [get_pins */inst/TWO_STACK.u_hbm_top/TWO_STACK_HBM.hbm_apb_arbiter_1/apb_mux_sel_r_reg[0]/C] -to [get_pins */inst/TWO_STACK.u_hbm_top/TWO_STACK_HBM.u_xsdb_top_1/xsdb2adb_u0/*/CE]
create_waiver -internal -type CDC -id CDC-1 -description "This is a safe CDC in this design per review with team" -from [get_pins */inst/TWO_STACK.u_hbm_top/TWO_STACK_HBM.hbm_apb_arbiter_1/apb_mux_sel_r_reg[0]/C] -to [get_pins */inst/TWO_STACK.u_hbm_top/TWO_STACK_HBM.u_xsdb_top_1/xsdb2adb_u0/*/D]
create_waiver -internal -type CDC -id CDC-4 -description "This is a safe CDC in this design per review with team" -from [get_pins */inst/TWO_STACK.u_hbm_top/TWO_STACK_HBM.u_hbm_temp_rd_1/temp_value_r_reg[*]/C] -to [get_pins */inst/TWO_STACK.u_hbm_top/TWO_STACK_HBM.u_xsdb_top_*/xsdb2adb_u0/hbm_temp_r_reg[*]/D]
create_waiver -internal -type CDC -id CDC-13 -description "This is a safe CDC in this design per review with team" -from [get_pins */inst/TWO_STACK.u_hbm_top/TWO_STACK_HBM.u_xsdb_top_1/xsdb2adb_u0/*/C] -to [get_pins */inst/TWO_STACK.u_hbm_top/TWO_STACK_HBM.hbm_two_stack_intf/HBM_ONE_STACK_INTF<1>_INST/HBM_SNGLBLI_INTF_APB_INST/*]
create_waiver -internal -type CDC -id CDC-14 -description "This is a safe CDC in this design per review with team" -from [get_pins */inst/TWO_STACK.u_hbm_top/TWO_STACK_HBM.u_xsdb_top_1/xsdb2adb_u0/*/C] -to [get_pins */inst/TWO_STACK.u_hbm_top/TWO_STACK_HBM.hbm_two_stack_intf/HBM_ONE_STACK_INTF<1>_INST/HBM_SNGLBLI_INTF_APB_INST/*]
create_waiver -internal -type CDC -id CDC-1 -description "This is a safe CDC in this design per review with team" -from [get_pins */inst/TWO_STACK.u_hbm_top/TWO_STACK_HBM.u_xsdb_top_1/xsdb2adb_u0/*/C] -to [get_pins */inst/TWO_STACK.u_hbm_top/TWO_STACK_HBM.hbm_apb_arbiter_1/apb_mux_sel_r_reg*/*]


create_waiver -internal -type CDC -id CDC-1 -description "This is a safe CDC in this design per review with team" -from [get_pins u_atg_vio_*/inst/DECODER_INST/Hold_probe_in_reg/C] -to [get_pins u_atg_vio_*/inst/PROBE_IN_INST/probe_in_reg_reg[*]/CE]
create_waiver -internal -type CDC -id CDC-4 -description "This is a safe CDC in this design per review with team" -from [get_pins u_atg_vio_*/inst/PROBE_IN_INST/probe_in_reg_reg[*]/C] -to [get_pins u_atg_vio_*/inst/PROBE_IN_INST/data_int_sync1_reg[*]/D]

connect_debug_port dbg_hub/clk [get_nets */APB_0_PCLK]