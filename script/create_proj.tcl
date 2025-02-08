create_project -force -part xc7k325tffg676-2 test ./proj
add_files -norecurse -fileset constrs_1 ./src/constraints/test.xdc
add_files -norecurse -fileset sources_1 [glob -nocomplain ./src/hdl/*.v]
add_files -norecurse -fileset sim_1 [glob -nocomplain ./src/testbench/*.v]
set_property top test [get_filesets sources_1]
set_property top tb_test [get_filesets sim_1]
update_compile_order -fileset sources_1
