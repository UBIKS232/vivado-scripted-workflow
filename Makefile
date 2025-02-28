# target
TARGET := top
TB := tb_$(TARGET)
FPGA :=xc7z020clg400-2# xc7k325tffg676-2
ARGS = $(filter-out add,$(MAKECMDGOALS))
XILINX_PATH := D:/Coding/Xilinx/Vivado/2024.2/bin/

# basic path, based on digital-ide structure

CFG_PATH := ./.vscode
USR_PATH := ./user
BUILD_PATH := ./prj# generated files' path
PROJ_PATH := $(BUILD_PATH)/xilinx
ICARUS_PATH := $(USR_PATH)/icarus
NETLIST_PATH := $(USR_PATH)/netlist

# code path
HDL_PATH := $(USR_PATH)/src/new
TB_PATH := $(USR_PATH)/sim/new
CS_PATH := $(USR_PATH)/data/new
BD_PATH := $(USR_PATH)/bd
IP_PATH := $(USR_PATH)/ip# not sure
SCRIPT_PATH := $(USR_PATH)/script

# flags
SIMULATOR := "XSim"
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
ifneq ($(wildcard $(SCRIPT_PATH)/create_proj.tcl),)
	rm $(SCRIPT_PATH)/create_proj.tcl
endif
ifeq ($(wildcard $(PROJ_PATH)),)
	mkdir -p $(PROJ_PATH)
endif
ifeq ($(wildcard $(BUILD_PATH)),)
	mkdir -p $(BUILD_PATH)
endif
ifeq ($(wildcard $(USR_PATH)),)
	mkdir -p $(HDL_PATH) $(CS_PATH) $(BD_PATH) $(TB_PATH)
endif
ifneq ($(wildcard $(CS_PATH)/$(TARGET).xdc),)
	rm $(CS_PATH)/$(TARGET).xdc
endif

	@echo -e "\e[1;34mAdd .gitignore.\e[0m"
	printf "# folder\n\
	.vscode/\n\
	prj/\n\
	.Xil/\n\
	# files\n" \
		>> .gitignore
	git add .gitignore

	@echo -e "\e[1;34mAdd create_project script.\e[0m"
	mkdir -p $(SCRIPT_PATH)
	echo "create_project -force -part $(FPGA) $(TARGET) $(PROJ_PATH)" \
		>> $(SCRIPT_PATH)/create_proj.tcl

	@echo -e "\e[1;34mAdd constrains(according to the board).\e[0m"
	printf "set_property IOSTANDARD LVCMOS33 [get_ports out]\n\
	set_property IOSTANDARD LVCMOS33 [get_ports rst]\n\
	set_property IOSTANDARD LVCMOS33 [get_ports clk]\n\
	set_property PACKAGE_PIN K16 [get_ports out]\n\
	set_property PACKAGE_PIN N18 [get_ports clk]\n\
	set_property PACKAGE_PIN G19 [get_ports rst]\n" \
		>> $(CS_PATH)/$(TARGET).xdc
	echo "add_files -norecurse -fileset constrs_1 $(CS_PATH)/$(TARGET).xdc" \
		>> $(SCRIPT_PATH)/create_proj.tcl

	@echo -e "\e[1;34mAdd source and testbench.\e[0m"
ifeq ($(wildcard $(HDL_PATH)/*.v),)
	touch $(HDL_PATH)/$(TARGET).v
	printf "module $(TARGET)();\n\nendmodule\n\n" \
		>> $(HDL_PATH)/$(TARGET).v
endif
ifeq ($(wildcard $(TB_PATH)/*.v),)
	touch $(TB_PATH)/$(TB).v
	printf "\`timescale 1ns / 1ps\n\n\
	module $(TB)();\n\n\
		/*iverilog */\n\
		initial\n\
		begin\n\
			\$dumpfile(\"$(TB).vcd\");\n\
			\$dumpvars(0, $(TB));\n\
		end\n\
		/*iverilog */\n\n\n\
	endmodule\n\n" \
		>> $(TB_PATH)/$(TB).v
endif

	@echo -e "\e[1;34mUpdate create-project script.\e[0m"
	printf "add_files -norecurse -fileset sources_1 [glob -nocomplain $(HDL_PATH)/*.v] \n\
	add_files -norecurse -fileset sim_1 [glob -nocomplain $(TB_PATH)/*.v] \n\
	set_property top $(TARGET) [get_filesets sources_1] \n\
	set_property top $(TB) [get_filesets sim_1] \n\
	update_compile_order -fileset sources_1 \n"\
		>> $(SCRIPT_PATH)/create_proj.tcl

ifeq ($(wildcard $(PROJ_PATH)/$(TARGET).xpr),)
	vivado $(VIVADO_BATCH_FLAGS) -source $(SCRIPT_PATH)/create_proj.tcl
	git add .
	git commit -m "init"
endif

.PHONY:
cons:
	@echo -e "\e[1;34mAdd constrains(according to the board).\e[0m"
ifneq ($(wildcard $(CS_PATH)/$(TARGET).xdc),)
	rm $(CS_PATH)/$(TARGET).xdc
endif
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
	
	echo "add_files -norecurse -fileset constrs_1 $(CS_PATH)/$(TARGET).xdc" \
						>> $(SCRIPT_PATH)/update_const.tcl

	vivado $(VIVADO_BATCH_FLAGS) -source $(SCRIPT_PATH)/update_const.tcl

.PHONY:
add:
	@echo -e "\e[1;34mAdd hdl.\e[0m"
ifneq ($(wildcard $(SCRIPT_PATH)/update_hdl.tcl),)
	rm $(SCRIPT_PATH)/update_hdl.tcl
endif
	touch $(HDL_PATH)/$(ARGS).v
	printf "module $(ARGS)();\n\nendmodule\n" \
		>> $(HDL_PATH)/$(ARGS).v

	echo "add_files -norecurse -fileset sources_1 [glob -nocomplain $(HDL_PATH)/$(ARGS).v] \n\
	update_compile_order -fileset sources_1 \n"\
		>> $(SCRIPT_PATH)/update_hdl.tcl

	vivado $(VIVADO_BATCH_FLAGS) -source $(SCRIPT_PATH)/update_hdl.tcl

.PHONY:
sig:
	@echo -e "\e[1;34mSynthesis, implelentation and generate bitstream.\e[0m"
ifneq ($(wildcard $(SCRIPT_PATH)/sig.tcl),)
	rm $(SCRIPT_PATH)/sig.tcl
endif
	printf "open_project $(PROJ_PATH)/$(TARGET).xpr \n\
	reset_runs synth_1 \n\
	set_property top_file "$(HDL_PATH)/$(TARGET).v" [current_fileset] \n\
	launch_runs synth_1 -jobs 18 \n\
	wait_on_run synth_1 \n\
	reset_runs impl_1 \n\
	launch_runs impl_1 -jobs 18 \n\
	wait_on_run impl_1 \n\
	open_run impl_1 \n\
	report_utilization -file $(BUILD_PATH)/$(TARGET)_utilization.rpt \n\
	report_utilization -hierarchical -file $(BUILD_PATH)/$(TARGET)_utilization_hierarchical.rpt \n\
	write_bitstream -force $(BUILD_PATH)/$(TARGET).bit \n\
	write_debug_probes -force $(BUILD_PATH)/$(TARGET).ltx \n"\
		>> $(SCRIPT_PATH)/sig.tcl
	# echo "report_timing_summary -file $(BUILD_PATH)/$(TARGET)_timing_summary.rpt" \
	# 					>> $(SCRIPT_PATH)/sig.tcl

	vivado $(VIVADO_BATCH_FLAGS) -source $(SCRIPT_PATH)/sig.tcl

.PHONY:
xsim:
	@echo -e "\e[1;34mAutomatic Simulation(Xsim).\e[0m"
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
	cp $(PROJ_PATH)/$(TARGET).sim/sim_1/behav/xsim/xsim.dir/dump.vcd $(BUILD_PATH)/$(TARGET).vcd

# iverilog
.PHONY:
isim:
	@echo -e "\e[1;34mAutomatic Simulation(Icarus).\e[0m"
	iverilog -g2005 -o $(ICARUS_PATH)/$(TARGET) -s $(TARGET) $(HDL_PATH)/*.v $(TB_PATH)/*.v
	vvp -n $(ICARUS_PATH)/$(TARGET) -ltx2

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
	echo "update_compile_order -fileset sim_1" \
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
	echo "report_utilization -hierarchical -file $(BUILD_PATH)/$(TARGET)_utilization_hierarchical.rpt" \
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
	rm -rf $(PROJ_PATH) $(ICARUS_PATH) $(NETLIST_PATH) $(SCRIPT_PATH)

.PHONY:
fc2223:
	@echo -e "\e[1;31mFull clean(y/n)?\e[0m"
	@read -p ">> " ans; \
	if [ "$$ans" == "y" ]; then \
		rm -rf .gitignore $(PROJ_PATH) $(SCRIPT_PATH) $(USR_PATH) $(IP_PATH); \
	else \
		echo -e "\e[1;31mFull clean canceled.\e[0m"; \
	fi
