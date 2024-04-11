create_clock -name CLK12M -period 83.333 [get_ports {clk}]

derive_clock_uncertainty

set_false_path -from [get_ports {signal_in_1}]
set_false_path -from [get_ports {signal_in_2}]
set_false_path -from * -to [get_ports {serial_out*}]


