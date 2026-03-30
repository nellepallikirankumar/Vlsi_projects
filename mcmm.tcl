##################################################################
# mcmm-timing_constrain
##################################################################
remove_modes -all
remove_corners -all
remove_scenarios -all

###################################################################
# modes
###################################################################
create_mode func
current_mode func
create_clock -period 4 [get_ports router_clock]
create_mode turbo
current_mode turbo
create_clock -period 2 [get_ports router_clock]

###################################################################
# corners
###################################################################
create_corner ff_m40c
set_process_label fast -corners ff_m40c
set_process_number 1.01 -corners ff_m40c
set_voltage 1.16 -corners ff_m40c -object_list VDD
set_voltage 0.95 -corners ff_m40c -object_list VDDL
set_voltage 0.00 -corners ff_m40c -object_list VSS
set_temperature -40 -corners ff_m40c
set_parasitic_parameters -corners ff_m40c -early_spec minTLU -late_spec maxTLU
#######################################
create_corner ss_125c
current_corner
current_corner ss_125c
set_process_label slow -corners ss_125c
set_process_number 0.99 -corners ss_125c
set_voltage 0.95 -corners ss_125c -object_list VDD
set_voltage 0.75 -corners ss_125c -object_list VDDL
set_voltage 0.00 -corners ss_125c -object_list VSS
set_temperature 125 -corners ss_125c
set_parasitic_parameters -corners ss_125c -late_spec maxTLU -early_spec minTLU
########################################
create_corner ss_m40c
current_corner ss_m40c
set_process_label slow -corners ss_m40c
set_process_number 0.99 -corners ss_m40c
set_voltage 0.95 -corners ss_m40c -object_list VDD
set_voltage 0.75 -corners ss_m40c -object_list VDDL
set_voltage 0.00 -corners ss_m40c -object_list VSS
set_temperature -40 -corners ss_m40c
set_parasitic_parameters -corners ss_m40c -early_spec maxTLU -late_spec maxTLU

###########################################################################
#scenarios-func
###########################################################################

create_scenario -mode func -corner ss_125c
current_scenario func::ss_125c
set_driving_cell -lib_cell INVX8_LVT [get_ports router_clock]
set_driving_cell -lib_cell INVX8_RVT [remove_from_collection [all_inputs] [get_ports router_clock]]
set_clock_uncertainty -setup 0.3 [get_clocks router_clock]
set_clock_latency 0.6 [get_clocks router_clock]
set_clock_transition 0.2 [get_clocks router_clock]
set_input_delay 0.5 -clock router_clock [remove_from_collection [all_inputs] [get_ports router_clock]]
set_output_delay 0.5 -clock router_clock [all_outputs]


create_scenario -mode func -corner ff_m40c
current_scenario func::ff_m40c
set_driving_cell -lib_cell INVX8_LVT [get_ports router_clock]
set_driving_cell -lib_cell INVX8_RVT [remove_from_collection [all_inputs] [get_ports router_clock]]
set_clock_uncertainty -setup 0.1 [get_clocks router_clock]
set_clock_latency 0.3 [get_clocks router_clock]
set_clock_transition 0.1 [get_clocks router_clock]
set_input_delay 0.6 -clock router_clock [remove_from_collection [all_inputs] [get_ports router_clock]]
set_output_delay 0.3 -clock router_clock [all_outputs]


create_scenario -mode func -corner ss_m40c
current_scenario func::ss_m40c
set_driving_cell -lib_cell INVX8_LVT [get_ports router_clock]
set_driving_cell -lib_cell INVX8_RVT [remove_from_collection [all_inputs] [get_ports router_clock]]
set_clock_uncertainty -setup 0.2 [get_clocks router_clock]
set_clock_latency 0.4 [get_clocks router_clock]
set_clock_transition 0.2 [get_clocks router_clock]
set_input_delay 1.0 -clock router_clock [remove_from_collection [all_inputs] [get_ports router_clock]]
set_output_delay 1.5 -clock router_clock [all_outputs]

#####################################
#scenarios-turbo
####################################
create_scenario -mode turbo -corner ss_125c
current_scenario turbo::ss_125c
set_driving_cell -lib_cell INVX8_LVT [get_ports router_clock]
set_driving_cell -lib_cell INVX8_RVT [remove_from_collection [all_inputs] [get_ports router_clock]]
set_clock_uncertainty -setup 0.3 [get_clocks router_clock]
set_clock_latency 0.6 [get_clocks router_clock]
set_clock_transition 0.2 [get_clocks router_clock]
set_input_delay 0.5 -clock router_clock [remove_from_collection [all_inputs] [get_ports router_clock]]
set_output_delay 0.5 -clock router_clock [all_outputs]

create_scenario -mode turbo -corner ss_m40c
current_scenario turbo::ss_m40c
set_driving_cell -lib_cell INVX8_LVT [get_ports router_clock]
set_driving_cell -lib_cell INVX8_RVT [remove_from_collection [all_inputs] [get_ports router_clock]]
set_clock_uncertainty -setup 0.3 [get_clocks router_clock]
set_clock_latency 0.6 [get_clocks router_clock]
set_clock_transition 0.2 [get_clocks router_clock]
set_input_delay 5.0 -clock router_clock [remove_from_collection [all_inputs] [get_ports router_clock]]
set_output_delay 5.0 -clock router_clock [all_outputs]

report_scenarios

report_pvt

save_lib

save_block
