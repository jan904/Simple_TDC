create_clock -name CLK12M -period 83.333 [get_ports {clk}]

derive_clock_uncertainty

set_false_path -from [get_ports {signal_in}]
set_false_path -from * -to [get_ports {signal_out*}]


set_max_skew -from [get_pins {delay_line_inst|\carry_delay_line:0:first_carry4:delayblock|carry[1]|combout}] -to [get_pins {delay_line_inst|\carry_delay_line:0:first_carry4:delayblock|carry[2]|dataa}] 1
set_max_skew -from [get_pins {delay_line_inst|\carry_delay_line:0:first_carry4:delayblock|carry[1]|combout}] -to [get_pins {delay_line_inst|\carry_delay_line:0:first_carry4:delayblock|carry[2]|datab}] 1
set_max_skew -from [get_pins {delay_line_inst|\carry_delay_line:0:first_carry4:delayblock|carry[1]|combout}] -to [get_pins {delay_line_inst|\carry_delay_line:0:first_carry4:delayblock|carry[2]|datac}] 1
set_max_skew -from [get_pins {delay_line_inst|\carry_delay_line:0:first_carry4:delayblock|carry[2]|combout}] -to [get_pins {delay_line_inst|\carry_delay_line:0:first_carry4:delayblock|carry[3]|datad}] 1
set_max_skew -from [get_pins {delay_line_inst|\carry_delay_line:0:first_carry4:delayblock|carry[3]|combout}] -to [get_pins {delay_line_inst|\carry_delay_line:0:first_carry4:delayblock|carry[4]|datad}] 1
