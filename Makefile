# target
TARGET := test
TB := tb_$(TARGET)
FPGA := xc7k325tffg676-2
# basic path
XILINX_PATH := D:/Coding/Xilinx/Vivado/2024.2/bin/
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
	printf "# folder\nproj/\nscript/\n# files\n" \
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


	@echo -e "\e[1;34mAdd constrains(according to the board).\e[0m"
	cat constraints.xdc > $(CS_PATH)/$(TARGET).xdc
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
	printf "1ns/1ps\nmodule $(TB)();\n\nendmodule\n" \
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
	# echo "set_property top $(TARGET) [current_fileset]" \
	# 					>> $(SCRIPT_PATH)/create_proj.tcl
	# echo "set_property source_mgmt_mode All [current_project]" \
	# 					>> $(SCRIPT_PATH)/create_proj.tcl
	echo "update_compile_order -fileset sources_1" \
						>> $(SCRIPT_PATH)/create_proj.tcl

	vivado $(VIVADO_BATCH_FLAGS) -source $(SCRIPT_PATH)/create_proj.tcl
	git add .
	git commit -m "init"
#endif

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


# clean, full clean(fc2223, USE WITH CAUTION)
clean:
	@echo -e "\e[1;31mClean.\e[0m"
	rm -rf $(PROJ_PATH) $(SCRIPT_PATH)

cc:
	@echo -e "\e[1;31mClean script and constrains.\e[0m"
	rm -rf $(SCRIPT_PATH)

fc2223:
	@echo -e "\e[1;31mFull clean(y/n)?\e[0m"
	@read -p ">> " ans; \
	if [ "$$ans" == "y" ]; then \
		rm -rf .gitignore $(PROJ_PATH) $(SCRIPT_PATH) $(SRC_PATH) $(IP_PATH); \
	else \
		echo -e "\e[1;31mFull clean canceled.\e[0m"; \
	fi
