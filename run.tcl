#######################################################
# Read_rtl
#######################################################
source -echo ../scripts/setup_router.tcl
create_lib -technology $TECH_FILE -ref_libs $REFERENCE_LIBRARY  router.dlib
analyze -format verilog [glob ../rtl/router_*.v]
elaborate router_top
set_top_module router_top
#######################################################
# Read_parastics_using_tech_file
#######################################################
read_parasitic_tech -layermap ../../ref/tech/saed32nm_tf_itf_tluplus.map -tlup ../../ref/tech/saed32nm_1p9m_Cmax.lv.nxtgrd -name maxTLU
read_parasitic_tech -layermap ../../ref/tech/saed32nm_tf_itf_tluplus.map -tlup ../../ref/tech/saed32nm_1p9m_Cmin.lv.nxtgrd -name minTLU
##############################
set_attribute [get_site_defs unit] symmetry Y
set_attribute [get_site_defs unit] is_default true
set_attribute [get_layers {M1 M3 M5 M7 M9}] routing_direction horizontal
set_attribute [get_layers {M2 M4 M6 M8}] routing_direction vertical
report_ignored_layers
set_ignored_layers -max_routing_layer M8
report_ignored_layers
#######################################################
# Load_upf
#######################################################
create_supply_net VSS
create_supply_net VDD
create_supply_net VDDL

create_supply_set set_top_high -function {power VDD} -function {ground VSS}
create_supply_set sub_set_low -function {power VDDL} -function {ground VSS}

create_power_domain top_domain -supply {primary set_top_high}
create_power_domain sub_domain -supply {primary sub_set_low} -elements {REG SYNCH}

create_supply_port VDD -direction in
create_supply_port VDDL -direction in
create_supply_port VSS -direction in

connect_supply_net VDD -ports VDD
connect_supply_net VDDL -ports VDDL
connect_supply_net VSS -ports VSS

set_level_shifter h2l -domain sub_domain -rule high_to_low -location self -applies_to inputs
set_level_shifter l2h -domain sub_domain -rule low_to_high -location parent -applies_to outputs

#gui_show_man_page add_power_state

add_power_state set_top_high -state ON {-supply_expr {(power == {FULL_ON 1.16}) && (ground =={FULL_ON 0.0})}}
add_power_state sub_set_low -state ON {-supply_expr {(power == {FULL_ON 0.95}) && (ground =={FULL_ON 0.0})}}

report_voltage_areas
check_mv_design
commit_upf
save_lib
save_block