set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 1 [current_design]
set_property CONFIG_MODE SPIx1 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]
set_property BITSTREAM.CONFIG.SPI_32BIT_ADDR NO [current_design]
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN G22} [get_ports {i_clk}]         # clk
# led   0
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN C12} [get_ports {b}]      
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN A13} [get_ports {o_led[1]}]      # led   1
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN C14} [get_ports {o_led[2]}]      # led   2
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN D19} [get_ports {o_led[3]}]      # led   3
# key   0
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN B15} [get_ports {a}]      
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN A15} [get_ports {i_key[1]}]      # key   1
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN B14} [get_ports {i_key[2]}]      # key   2
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN A14} [get_ports {i_key[3]}]      # key   3
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN D23} [get_ports {i_key[4]}]      # key   4
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN D25} [get_ports {o_core_led[0]}] # on_core_led   0
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN F25} [get_ports {o_core_led[1]}] # on_core_led   1
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN G25} [get_ports {o_core_led[2]}] # on_core_led   2
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN G26} [get_ports {o_core_led[3]}] # on_core_led   3
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN D20} [get_ports {i_uart_rx}]     # uart_rx
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN D14} [get_ports {o_uart_tx}]     # uart_tx
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN B12} [get_ports {exter_io1[0]}]  # exter_io1   0
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN A12} [get_ports {exter_io1[1]}]  # exter_io1   1
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN D18} [get_ports {exter_io1[2]}]  # exter_io1   2
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN B11} [get_ports {exter_io1[3]}]  # exter_io1   3
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN E18} [get_ports {exter_io1[4]}]  # exter_io1   4
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN A10} [get_ports {exter_io1[5]}]  # exter_io1   5
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN D16} [get_ports {exter_io1[6]}]  # exter_io1   6
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN B10} [get_ports {exter_io1[7]}]  # exter_io1   7
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN E16} [get_ports {exter_io1[8]}]  # exter_io1   8
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN A9} [get_ports {exter_io1[9]}]   # exter_io1   9
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN D15} [get_ports {exter_io1[10]}] # exter_io1   10
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN B9} [get_ports {exter_io1[11]}]  # exter_io1   11
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN E15} [get_ports {exter_io1[12]}] # exter_io1   12
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN A8} [get_ports {exter_io1[13]}]  # exter_io1   13
# set_property -dict {PACKAGE_PIN B17 IOSTANDARD TMDS_33} [get_ports {o_hdmi_d_p[2]}]   # hdmi_d_p   2
# set_property -dict {PACKAGE_PIN C17 IOSTANDARD TMDS_33} [get_ports {o_hdmi_d_p[1]}]   # hdmi_d_p   1
# set_property -dict {PACKAGE_PIN A18 IOSTANDARD TMDS_33} [get_ports {o_hdmi_d_p[0]}]   # hdmi_d_p   0
# set_property -dict {PACKAGE_PIN C19 IOSTANDARD TMDS_33} [get_ports o_hdmi_clk_p]      # hdmi_clk_p