##########################
#SETUP_PnR
##########################
compile_fusion -to final_opto
check_legality
check_pg_connectivity
check_pg_drc
check_pg_missing_vias
report_timing

refine_placement
legalize_placement
check_pg_connectivity
check_pg_drc
check_pg_missing_vias
#######################
#CTS
######################
source ./cts/cts_include_refs.tcl
source ./cts/ndr.tcl
clock_opt
check_pg_connectivity
check_pg_drc
check_pg_missing_vias
#########################
#ROUTE
#########################
source ../../ref/tech/saed32nm_ant_1p9m.tcl
route_auto -max_detail_route_iterations 200
check_pg_missing_vias
check_pg_drc
check_pg_connectivity
route_opt
check_pg_connectivity
check_pg_drc
check_pg_missing_vias
route_auto -max_detail_route_iterations 400
check_pg_drc
check_pg_connectivity
check_pg_missing_vias
route_opt
check_pg_missing_vias
check_pg_connectivity
check_pg_drc
#############################
route_eco -nets {VDD VDDL VSS}
save_block
save_lib
check_pg_connectivity
check_pg_drc
check_pg_missing_vias
save_block
############################
#END
############################
