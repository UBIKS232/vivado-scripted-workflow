create_project -force -part xc7k325tffg676-2 test ./proj
add_files -norecurse -fileset constrs_1 ./osrc/constraints/test.xdc
add_files -norecurse -fileset sources_1 [glob -nocomplain ./src/*.v]
add_files -norecurse -fileset sim_1 [glob -nocomplain ./osrc/testbench/*.v]
update_compile_order -fileset sources_1
