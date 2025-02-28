create_project -force -part xc7z020clg400-2 top /xilinx
add_files -norecurse -fileset constrs_1 ./user/data/new/top.xdc
add_files -norecurse -fileset sources_1 [glob -nocomplain ./user/src/new/*.v] 
add_files -norecurse -fileset sim_1 [glob -nocomplain ./user/sim/new/*.v] 
set_property top top [get_filesets sources_1] 
set_property top tb_top [get_filesets sim_1] 
update_compile_order -fileset sources_1 
