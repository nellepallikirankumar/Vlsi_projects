##################################
#pns
##################################
remove_pg_strategies -all
remove_pg_patterns -all
remove_pg_regions -all
remove_pg_via_master_rules -all
remove_pg_strategy_via_rules -all
remove_routes -net_types {power ground} -ring -stripe -macro_pin_connect -lib_cell_pin_connect > /dev/null

connect_pg_net

##################################################
#creating rings
####################################################
create_pg_ring_pattern ring_pattern \
   -horizontal_layer M7 -horizontal_width {0.5} -horizontal_spacing {2} \
   -vertical_layer M8 -vertical_width {0.5} -vertical_spacing {2} 

set_pg_strategy core_ring \
   -pattern {{name: ring_pattern} \
   {nets: {VDD VDDL VSS}} {offset: {2 2}}} -core \
   -extension {{nets: {VDD VDDL VSS}}{side:1}{direction:T}{stop:design_boundary_and_generate_pin}}

compile_pg -strategies core_ring
#######################################
# creating rails
##########################################

create_pg_std_cell_conn_pattern rail_pattern -layers M1 -rail_width {0.08}
set_pg_strategy M2_rails  \
   -voltage_areas DEFAULT_VA -pattern {{name: rail_pattern}{nets: VDD VSS}} \
   -blockage {{nets:VDD VSS} {voltage_areas:sub_domain}} 


compile_pg -strategies M2_rails

create_pg_std_cell_conn_pattern rail_pattern -layers M1 -rail_width {0.08}

set_pg_strategy M2_rails1 \
   -voltage_areas sub_domain -pattern {{name: rail_pattern}{nets: VDDL VSS}} \
   -blockage {{nets:VDDL VSS} {voltage_areas:DEFAULT_VA}} 

compile_pg -strategies M2_rails1


###########################################
# creating Mesh
########################################
create_pg_mesh_pattern mesh_pattern \
   -layers {{{vertical_layer: M6} {width: 0.08}\
             {pitch:8} {offset:3.35}{spacing:interleaving}}\
            {{horizontal_layer: M5} {width: 0.08}\
             {pitch:10} {offset:6}{spacing:interleaving}}}

set_pg_strategy M5M6_mesh -voltage_areas DEFAULT_VA -pattern {{name: mesh_pattern} {nets: VDD VSS}} \
    -blockage {{nets: VDD VSS}{voltage_areas:sub_domain}} \
    -extension {{nets: VDD VSS} {stop:outermost_ring} }

compile_pg -strategies M5M6_mesh
create_pg_mesh_pattern mesh_pattern1 \
   -layers {{{vertical_layer: M6} {width: 0.08}\
             {pitch:8} {offset:3.5}{spacing:interleaving}}\
            {{horizontal_layer: M5} {width: 0.08}\
             {pitch:8} {offset:3.5}{spacing:interleaving}}}

set_pg_strategy M5M6_mesh1 -voltage_areas sub_domain -pattern {{name: mesh_pattern1} {nets: VDDL VSS}} \
  -blockage {{nets: VDDL VSS}{voltage_areas:DEFAULT_VA}} \
  -extension {{nets: VDDL VSS} {side: 4}{direction:L T} {stop:outermost_ring}}
compile_pg -strategies M5M6_mesh1
#############################
#checks
#############################

check_pg_connectivity
