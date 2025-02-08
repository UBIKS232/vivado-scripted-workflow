# target
TARGET := test
TB := tb_$(TARGET)
FPGA := xc7k325tffg676-2
SIMULATOR := "XSim"
# basic path
XILINX_PATH := D:/Coding/Xilinx/Vivado/2024.2/bin/
CFG_PATH := ./.vscode
SRC_PATH := ./src
IP_PATH := ./ip
PROJ_PATH := ./proj# generated files' path
BUILD_PATH := $(PROJ_PATH)/build
SCRIPT_PATH := ./script
# code path
HDL_PATH := $(SRC_PATH)/hdl
CS_PATH := $(SRC_PATH)/constraints
BD_PATH := $(SRC_PATH)/blockdesign
TB_PATH := $(SRC_PATH)/testbench
# ip
SYSTEM_IP_PATH := $(IP_PATH)/sysip
MY_IP_PATH := $(IP_PATH)/myip
# flags
VIVADO_FLAGS := -nojournal -nolog
VIVADO_TCL_FLGAS := $(VIVADO_FLAGS) -mode tcl
VIVADO_BATCH_FLAGS := $(VIVADO_FLAGS) -mode batch -tempDir $(PROJ_PATH)

.ONE_SHELL:
all: sig # implelentation bitstream download

.PHONY:
tcl:
	vivado $(VIVADO_TCL_FLGAS)

.PHONY:
init: 
	@echo -e "\e[1;34mInit.\e[0m"
	git init
ifneq ($(wildcard .gitignore),)
	rm .gitignore
endif
	printf "# folder\n.vscode/\nproj/\nscript/\nnetlist/\nicarus/\n# files\n" \
						>> .gitignore
	git add .gitignore

ifneq ($(wildcard $(SCRIPT_PATH)/create_proj.tcl),)
	rm $(SCRIPT_PATH)/create_proj.tcl
endif
	mkdir -p $(SCRIPT_PATH)
	echo "create_project -force -part $(FPGA) $(TARGET) $(PROJ_PATH)" \
						>> $(SCRIPT_PATH)/create_proj.tcl

ifeq ($(wildcard $(PROJ_PATH)),)
	mkdir -p $(PROJ_PATH)
endif
ifeq ($(wildcard $(BUILD_PATH)),)
	mkdir -p $(BUILD_PATH)
endif
ifeq ($(wildcard $(SRC_PATH)),)
	mkdir -p $(HDL_PATH) $(CS_PATH) $(BD_PATH) $(TB_PATH)
endif
ifeq ($(wildcard $(IP_PATH)),)
	mkdir -p $(SYSTEM_IP_PATH) $(MY_IP_PATH)
endif

# ifeq ($(wildcard $(CFG_PATH)/property.json),)
# 	mkdir -p $(CFG_PATH)
# 	touch $(CFG_PATH)/property.json
# 	printf "{\n\
# 		\"toolChain\": \"xilinx\",\n\
# 		\"toolVersion\": \"2024.2\",\n\
# 		\"prjName\": {\n\
# 			\"PL\": \"$(TARGET)\",\n\
# 			\"PS\": \"$(TARGET)\"\n\
# 		},\n\
# 		\"arch\": {\n\
# 			\"structure\": \"custom\",\n\
# 			\"prjPath\": \"$${workspace}/proj\",\n\
# 			\"hardware\": {\n\
# 				\"src\": \"$(HDL_PATH)\",\n\
# 				\"sim\": \"$(TB_PATH)\",\n\
# 				\"data\": \"$${workspace}\"\n\
# 			},\n\
# 			\"software\": {\n\
# 				\"src\": \"$(HDL_PATH)\",\n\
# 				\"data\": \"$${workspace}\"\n\
# 			}\n\
# 		},\n\
# 		\"library\": {\n\
# 			\"state\": \"local\",\n\
# 			\"hardware\": {\n\
# 				\"common\": [],\n\
# 				\"custom\": []\n\
# 			}\n\
# 		},\n\
# 		\"IP_REPO\": [],\n\
# 		\"soc\": {\n\
# 			\"core\": \"none\",\n\
# 			\"bd\": \"\",\n\
# 			\"os\": \"\",\n\
# 			\"app\": \"\"\n\
# 		},\n\
# 		\"device\": \"$(FPGA)\"\n\
# 		}\n" >> $(CFG_PATH)/property.json
# endif

	@echo -e "\e[1;34mAdd constrains(according to the board).\e[0m"
	printf "set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 1 [current_design]\n\
	set_property CONFIG_MODE SPIx1 [current_design]\n\
	set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]\n\
	set_property BITSTREAM.CONFIG.SPI_32BIT_ADDR NO [current_design]\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN G22} [get_ports {i_clk}]         # clk\n\
	set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN C12} [get_ports {b}]      # led   0\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN A13} [get_ports {o_led[1]}]      # led   1\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN C14} [get_ports {o_led[2]}]      # led   2\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN D19} [get_ports {o_led[3]}]      # led   3\n\
	set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN B15} [get_ports {a}]      # key   0\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN A15} [get_ports {i_key[1]}]      # key   1\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN B14} [get_ports {i_key[2]}]      # key   2\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN A14} [get_ports {i_key[3]}]      # key   3\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN D23} [get_ports {i_key[4]}]      # key   4\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN D25} [get_ports {o_core_led[0]}] # on_core_led   0\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN F25} [get_ports {o_core_led[1]}] # on_core_led   1\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN G25} [get_ports {o_core_led[2]}] # on_core_led   2\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN G26} [get_ports {o_core_led[3]}] # on_core_led   3\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN D20} [get_ports {i_uart_rx}]     # uart_rx\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN D14} [get_ports {o_uart_tx}]     # uart_tx\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN B12} [get_ports {exter_io1[0]}]  # exter_io1   0\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN A12} [get_ports {exter_io1[1]}]  # exter_io1   1\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN D18} [get_ports {exter_io1[2]}]  # exter_io1   2\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN B11} [get_ports {exter_io1[3]}]  # exter_io1   3\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN E18} [get_ports {exter_io1[4]}]  # exter_io1   4\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN A10} [get_ports {exter_io1[5]}]  # exter_io1   5\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN D16} [get_ports {exter_io1[6]}]  # exter_io1   6\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN B10} [get_ports {exter_io1[7]}]  # exter_io1   7\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN E16} [get_ports {exter_io1[8]}]  # exter_io1   8\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN A9} [get_ports {exter_io1[9]}]   # exter_io1   9\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN D15} [get_ports {exter_io1[10]}] # exter_io1   10\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN B9} [get_ports {exter_io1[11]}]  # exter_io1   11\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN E15} [get_ports {exter_io1[12]}] # exter_io1   12\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN A8} [get_ports {exter_io1[13]}]  # exter_io1   13\n\
	# set_property -dict {PACKAGE_PIN B17 IOSTANDARD TMDS_33} [get_ports {o_hdmi_d_p[2]}]   # hdmi_d_p   2\n\
	# set_property -dict {PACKAGE_PIN C17 IOSTANDARD TMDS_33} [get_ports {o_hdmi_d_p[1]}]   # hdmi_d_p   1\n\
	# set_property -dict {PACKAGE_PIN A18 IOSTANDARD TMDS_33} [get_ports {o_hdmi_d_p[0]}]   # hdmi_d_p   0\n\
	# set_property -dict {PACKAGE_PIN C19 IOSTANDARD TMDS_33} [get_ports o_hdmi_clk_p]      # hdmi_clk_p\n" \
						>> $(CS_PATH)/$(TARGET).xdc
	# cat constraints.xdc > $(CS_PATH)/$(TARGET).xdc
	# cp constraints.xdc $(CS_PATH)/$(TARGET).xdc
	echo "add_files -norecurse -fileset constrs_1 $(CS_PATH)/$(TARGET).xdc" \
						>> $(SCRIPT_PATH)/create_proj.tcl

# ifeq ($(wildcard $(BD_PATH)/*.bd),)
# 	touch $(BD_PATH)/$(TARGET).bd
# endif

ifeq ($(wildcard $(HDL_PATH)/*.v),)
	touch $(HDL_PATH)/$(TARGET).v
	printf "module $(TARGET)();\n\nendmodule\n" \
						> $(HDL_PATH)/$(TARGET).v
endif
ifeq ($(wildcard $(TB_PATH)/*.v),)
	touch $(TB_PATH)/$(TB).v
	printf "`timescale 1ns / 1ps\n\n\
	module $(TB)();\n\nendmodule\n" \
						> $(TB_PATH)/$(TB).v
endif
	echo "add_files -norecurse -fileset sources_1 [glob -nocomplain $(HDL_PATH)/*.v]" \
						>> $(SCRIPT_PATH)/create_proj.tcl
	echo "add_files -norecurse -fileset sim_1 [glob -nocomplain $(TB_PATH)/*.v]" \
						>> $(SCRIPT_PATH)/create_proj.tcl
	# echo "add_files -norecurse -fileset sources_1 [glob -nocomplain $(SYSTEM_IP_PATH)/*.xci]" \
	# 					>> $(SCRIPT_PATH)/create_proj.tcl
	# echo "add_files -norecurse -fileset sources_1 [glob -nocomplain $(MY_IP_PATH)/*.xci]" \
	# 					>> $(SCRIPT_PATH)/create_proj.tcl
	# echo "set_property source_mgmt_mode None [current_project]" \
	# 					>> $(SCRIPT_PATH)/create_proj.tcl
	echo "set_property top $(TARGET) [get_filesets sources_1]" \
						>> $(SCRIPT_PATH)/create_proj.tcl
	echo "set_property top $(TB) [get_filesets sim_1]" \
						>> $(SCRIPT_PATH)/create_proj.tcl
	# echo "set_property source_mgmt_mode All [current_project]" \
	# 					>> $(SCRIPT_PATH)/create_proj.tcl
	echo "update_compile_order -fileset sources_1" \
						>> $(SCRIPT_PATH)/create_proj.tcl

ifeq ($(wildcard $(PROJ_PATH)/$(TARGET).xpr),)
	vivado $(VIVADO_BATCH_FLAGS) -source $(SCRIPT_PATH)/create_proj.tcl
	git add .
	git commit -m "init"
endif

.PHONY:
cons:
	@echo -e "\e[1;34mAdd constrains(according to the board).\e[0m"
	printf "set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 1 [current_design]\n\
	set_property CONFIG_MODE SPIx1 [current_design]\n\
	set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]\n\
	set_property BITSTREAM.CONFIG.SPI_32BIT_ADDR NO [current_design]\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN G22} [get_ports {i_clk}]         # clk\n\
	set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN C12} [get_ports {b}]      # led   0\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN A13} [get_ports {o_led[1]}]      # led   1\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN C14} [get_ports {o_led[2]}]      # led   2\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN D19} [get_ports {o_led[3]}]      # led   3\n\
	set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN B15} [get_ports {a}]      # key   0\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN A15} [get_ports {i_key[1]}]      # key   1\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN B14} [get_ports {i_key[2]}]      # key   2\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN A14} [get_ports {i_key[3]}]      # key   3\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN D23} [get_ports {i_key[4]}]      # key   4\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN D25} [get_ports {o_core_led[0]}] # on_core_led   0\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN F25} [get_ports {o_core_led[1]}] # on_core_led   1\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN G25} [get_ports {o_core_led[2]}] # on_core_led   2\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN G26} [get_ports {o_core_led[3]}] # on_core_led   3\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN D20} [get_ports {i_uart_rx}]     # uart_rx\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN D14} [get_ports {o_uart_tx}]     # uart_tx\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN B12} [get_ports {exter_io1[0]}]  # exter_io1   0\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN A12} [get_ports {exter_io1[1]}]  # exter_io1   1\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN D18} [get_ports {exter_io1[2]}]  # exter_io1   2\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN B11} [get_ports {exter_io1[3]}]  # exter_io1   3\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN E18} [get_ports {exter_io1[4]}]  # exter_io1   4\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN A10} [get_ports {exter_io1[5]}]  # exter_io1   5\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN D16} [get_ports {exter_io1[6]}]  # exter_io1   6\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN B10} [get_ports {exter_io1[7]}]  # exter_io1   7\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN E16} [get_ports {exter_io1[8]}]  # exter_io1   8\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN A9} [get_ports {exter_io1[9]}]   # exter_io1   9\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN D15} [get_ports {exter_io1[10]}] # exter_io1   10\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN B9} [get_ports {exter_io1[11]}]  # exter_io1   11\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN E15} [get_ports {exter_io1[12]}] # exter_io1   12\n\
	# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN A8} [get_ports {exter_io1[13]}]  # exter_io1   13\n\
	# set_property -dict {PACKAGE_PIN B17 IOSTANDARD TMDS_33} [get_ports {o_hdmi_d_p[2]}]   # hdmi_d_p   2\n\
	# set_property -dict {PACKAGE_PIN C17 IOSTANDARD TMDS_33} [get_ports {o_hdmi_d_p[1]}]   # hdmi_d_p   1\n\
	# set_property -dict {PACKAGE_PIN A18 IOSTANDARD TMDS_33} [get_ports {o_hdmi_d_p[0]}]   # hdmi_d_p   0\n\
	# set_property -dict {PACKAGE_PIN C19 IOSTANDARD TMDS_33} [get_ports o_hdmi_clk_p]      # hdmi_clk_p\n" \
						> $(CS_PATH)/$(TARGET).xdc

.PHONY:
sig:
	@echo -e "\e[1;34mSynthesis, implelentation and generate bitstream.\e[0m"
ifneq ($(wildcard $(SCRIPT_PATH)/sig.tcl),)
	rm $(SCRIPT_PATH)/sig.tcl
endif
	echo "open_project $(PROJ_PATH)/$(TARGET).xpr" \
						> $(SCRIPT_PATH)/sig.tcl

	echo "reset_runs synth_1" \
						>> $(SCRIPT_PATH)/sig.tcl
	echo "set_property top_file "$(HDL_PATH)/$(TARGET).v" [current_fileset]" \
						>> $(SCRIPT_PATH)/sig.tcl
	echo "launch_runs synth_1 -jobs 18" \
						>> $(SCRIPT_PATH)/sig.tcl
	echo "wait_on_run synth_1" \
						>> $(SCRIPT_PATH)/sig.tcl

	echo "reset_runs impl_1" \
						>> $(SCRIPT_PATH)/sig.tcl
	echo "launch_runs impl_1 -jobs 18" \
						>> $(SCRIPT_PATH)/sig.tcl
	echo "wait_on_run impl_1" \
						>> $(SCRIPT_PATH)/sig.tcl
	echo "open_run impl_1" \
						>> $(SCRIPT_PATH)/sig.tcl
	# echo "report_timing_summary -file $(BUILD_PATH)/$(TARGET)_timing_summary.rpt" \
	# 					>> $(SCRIPT_PATH)/sig.tcl
	echo "report_utilization -file $(BUILD_PATH)/$(TARGET)_utilization.rpt" \
						>> $(SCRIPT_PATH)/sig.tcl
	echo "report_utilization -hierarchical -file $(BUILD_PATH)/$(TARGET)_utilization_hierarchical.rpt" \
						>> $(SCRIPT_PATH)/sig.tcl
	echo "write_bitstream -force $(BUILD_PATH)/$(TARGET).bit" \
						>> $(SCRIPT_PATH)/sig.tcl
	echo "write_debug_probes -force $(BUILD_PATH)/$(TARGET).ltx" \
						>> $(SCRIPT_PATH)/sig.tcl

	vivado $(VIVADO_BATCH_FLAGS) -source $(SCRIPT_PATH)/sig.tcl

.PHONY:
sim:
	@echo -e "\e[1;34mAutomatic Simulation.\e[0m"
ifneq ($(wildcard $(SCRIPT_PATH)/sim.tcl),)
	rm $(SCRIPT_PATH)/sim.tcl
endif
	echo "open_project $(PROJ_PATH)/$(TARGET).xpr" \
						>> $(SCRIPT_PATH)/sim.tcl

	echo "set_property top $(TB) [get_filesets sim_1]" \
						>> $(SCRIPT_PATH)/sim.tcl
	echo "update_compile_order -fileset sim_1" \
						>> $(SCRIPT_PATH)/sim.tcl
	echo "set_property target_simulator $(SIMULATOR) [current_project]" \
						>> $(SCRIPT_PATH)/sim.tcl
	echo "launch_simulation -noclean_dir -mode \"behavioral\" " \
						>> $(SCRIPT_PATH)/sim.tcl

	vivado $(VIVADO_BATCH_FLAGS) -source $(SCRIPT_PATH)/sim.tcl

.PHONY:
syn:
	@echo -e "\e[1;34mSynthesis.\e[0m"
ifneq ($(wildcard $(SCRIPT_PATH)/syn.tcl),)
	rm $(SCRIPT_PATH)/syn.tcl
endif
	echo "open_project $(PROJ_PATH)/$(TARGET).xpr" \
						>> $(SCRIPT_PATH)/syn.tcl

	echo "reset_runs synth_1" \
						>> $(SCRIPT_PATH)/syn.tcl
	echo "set_property top_file "$(HDL_PATH)/$(TARGET).v" [current_fileset]" \
						>> $(SCRIPT_PATH)/syn.tcl
	echo "launch_runs synth_1 -jobs 18" \
						>> $(SCRIPT_PATH)/syn.tcl
	echo "wait_on_run synth_1" \
						>> $(SCRIPT_PATH)/syn.tcl

	vivado $(VIVADO_BATCH_FLAGS) -source $(SCRIPT_PATH)/syn.tcl

.PHONY:
impl:
	@echo -e "\e[1;34mImplelentation.\e[0m"
ifneq ($(wildcard $(SCRIPT_PATH)/impl.tcl),)
	rm $(SCRIPT_PATH)/impl.tcl
endif
	echo "open_project $(PROJ_PATH)/$(TARGET).xpr" \
						>> $(SCRIPT_PATH)/impl.tcl

	echo "reset_runs impl_1" \
						>> $(SCRIPT_PATH)/impl.tcl
	echo "launch_runs impl_1 -jobs 18" \
						>> $(SCRIPT_PATH)/impl.tcl
	echo "wait_on_run impl_1" \
						>> $(SCRIPT_PATH)/impl.tcl
	echo "open_run impl_1" \
						>> $(SCRIPT_PATH)/impl.tcl
	echo "report_timing_summary -file $(BUILD_PATH)/$(TARGET)_timing_summary.rpt" \
						>> $(SCRIPT_PATH)/impl.tcl
	echo "report_utilization -file $(BUILD_PATH)/$(TARGET)_utilization.rpt" \
						>> $(SCRIPT_PATH)/impl.tcl
	echo "report_utilization -hierarchical -file $(TARGET)_utilization_hierarchical.rpt" \
						>> $(SCRIPT_PATH)/impl.tcl

	vivado $(VIVADO_BATCH_FLAGS) -source $(SCRIPT_PATH)/impl.tcl

.PHONY:
bit:
	@echo -e "\e[1;34mGenerate bitstream.\e[0m"
ifneq ($(wildcard $(SCRIPT_PATH)/bit.tcl),)
	rm $(SCRIPT_PATH)/bit.tcl
endif
	echo "open_project $(PROJ_PATH)/$(TARGET).xpr" \
						>> $(SCRIPT_PATH)/bit.tcl

	echo "open_run impl_1" \
						>> $(SCRIPT_PATH)/bit.tcl
	
	echo "write_bitstream -force $(BUILD_PATH)/$(TARGET).bit" \
						>> $(SCRIPT_PATH)/bit.tcl
	echo "write_debug_probes -force $(BUILD_PATH)/$(TARGET).ltx" \
						>> $(SCRIPT_PATH)/bit.tcl

	vivado $(VIVADO_BATCH_FLAGS) -source $(SCRIPT_PATH)/bit.tcl

.PHONY:
down:
	@echo -e "\e[1;34mDownload bitstream.\e[0m"
ifneq ($(wildcard $(SCRIPT_PATH)/down.tcl),)
	rm $(SCRIPT_PATH)/down.tcl
endif
	echo "open_project $(PROJ_PATH)/$(TARGET).xpr" \
						>> $(SCRIPT_PATH)/down.tcl

	echo "open_hw_manager" \
						>> $(SCRIPT_PATH)/down.tcl
	echo "connect_hw_server" \
						>> $(SCRIPT_PATH)/down.tcl
	echo "open_hw_target" \
						>> $(SCRIPT_PATH)/down.tcl
	echo "current_hw_device [lindex [get_hw_devices] 0]" \
						>> $(SCRIPT_PATH)/down.tcl
	echo "refresh_hw_device -update_hw_probes flase [current_hw_device]" \
						>> $(SCRIPT_PATH)/down.tcl
	echo "set_property PROGRAM.FILE $(BUILD_PATH)/$(TARGET).bit [current_hw_device]" \
						>> $(SCRIPT_PATH)/down.tcl
	echo "program_hw_devices [current_hw_device]" \
						>> $(SCRIPT_PATH)/down.tcl

	vivado $(VIVADO_BATCH_FLAGS) -source $(SCRIPT_PATH)/down.tcl

# clean, full clean(fc2223, USE WITH CAUTION)
.PHONY:
clean:
	@echo -e "\e[1;31mClean.\e[0m"
	rm -rf $(PROJ_PATH) $(SCRIPT_PATH)

.PHONY:
fc2223:
	@echo -e "\e[1;31mFull clean(y/n)?\e[0m"
	@read -p ">> " ans; \
	if [ "$$ans" == "y" ]; then \
		rm -rf .gitignore .netlist .icarus $(PROJ_PATH) $(SCRIPT_PATH) $(SRC_PATH) $(IP_PATH); \
	else \
		echo -e "\e[1;31mFull clean canceled.\e[0m"; \
	fi
