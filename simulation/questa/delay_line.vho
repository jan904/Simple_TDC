-- Copyright (C) 2023  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- VENDOR "Altera"
-- PROGRAM "Quartus Prime"
-- VERSION "Version 23.1std.0 Build 991 11/28/2023 SC Standard Edition"

-- DATE "03/15/2024 15:11:05"

-- 
-- Device: Altera 10M08SAU169C8G Package UFBGA169
-- 

-- 
-- This VHDL file should be used for Questa Intel FPGA (VHDL) only
-- 

LIBRARY FIFTYFIVENM;
LIBRARY IEEE;
USE FIFTYFIVENM.FIFTYFIVENM_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	hard_block IS
    PORT (
	devoe : IN std_logic;
	devclrn : IN std_logic;
	devpor : IN std_logic
	);
END hard_block;

-- Design Ports Information
-- ~ALTERA_TMS~	=>  Location: PIN_G1,	 I/O Standard: 2.5 V Schmitt Trigger,	 Current Strength: Default
-- ~ALTERA_TCK~	=>  Location: PIN_G2,	 I/O Standard: 2.5 V Schmitt Trigger,	 Current Strength: Default
-- ~ALTERA_TDI~	=>  Location: PIN_F5,	 I/O Standard: 2.5 V Schmitt Trigger,	 Current Strength: Default
-- ~ALTERA_TDO~	=>  Location: PIN_F6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ~ALTERA_CONFIG_SEL~	=>  Location: PIN_D7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ~ALTERA_nCONFIG~	=>  Location: PIN_E7,	 I/O Standard: 2.5 V Schmitt Trigger,	 Current Strength: Default
-- ~ALTERA_nSTATUS~	=>  Location: PIN_C4,	 I/O Standard: 2.5 V Schmitt Trigger,	 Current Strength: Default
-- ~ALTERA_CONF_DONE~	=>  Location: PIN_C5,	 I/O Standard: 2.5 V Schmitt Trigger,	 Current Strength: Default


ARCHITECTURE structure OF hard_block IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL \~ALTERA_TMS~~padout\ : std_logic;
SIGNAL \~ALTERA_TCK~~padout\ : std_logic;
SIGNAL \~ALTERA_TDI~~padout\ : std_logic;
SIGNAL \~ALTERA_CONFIG_SEL~~padout\ : std_logic;
SIGNAL \~ALTERA_nCONFIG~~padout\ : std_logic;
SIGNAL \~ALTERA_nSTATUS~~padout\ : std_logic;
SIGNAL \~ALTERA_CONF_DONE~~padout\ : std_logic;
SIGNAL \~ALTERA_TMS~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_TCK~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_TDI~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_CONFIG_SEL~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_nCONFIG~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_nSTATUS~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_CONF_DONE~~ibuf_o\ : std_logic;

BEGIN

ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
END structure;


LIBRARY ALTERA;
LIBRARY FIFTYFIVENM;
LIBRARY IEEE;
USE ALTERA.ALTERA_PRIMITIVES_COMPONENTS.ALL;
USE FIFTYFIVENM.FIFTYFIVENM_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	channel IS
    PORT (
	clk : IN std_logic;
	signal_in : IN std_logic;
	signal_out : BUFFER std_logic_vector(7 DOWNTO 0)
	);
END channel;

-- Design Ports Information
-- signal_out[0]	=>  Location: PIN_H2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- signal_out[1]	=>  Location: PIN_L1,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- signal_out[2]	=>  Location: PIN_K5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- signal_out[3]	=>  Location: PIN_E8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- signal_out[4]	=>  Location: PIN_K8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- signal_out[5]	=>  Location: PIN_H8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- signal_out[6]	=>  Location: PIN_K6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- signal_out[7]	=>  Location: PIN_M13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- clk	=>  Location: PIN_H5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- signal_in	=>  Location: PIN_M10,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF channel IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_clk : std_logic;
SIGNAL ww_signal_in : std_logic;
SIGNAL ww_signal_out : std_logic_vector(7 DOWNTO 0);
SIGNAL \~QUARTUS_CREATED_ADC1~_CHSEL_bus\ : std_logic_vector(4 DOWNTO 0);
SIGNAL \clk~inputclkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \~QUARTUS_CREATED_GND~I_combout\ : std_logic;
SIGNAL \~QUARTUS_CREATED_UNVM~~busy\ : std_logic;
SIGNAL \~QUARTUS_CREATED_ADC1~~eoc\ : std_logic;
SIGNAL \signal_out[0]~output_o\ : std_logic;
SIGNAL \signal_out[1]~output_o\ : std_logic;
SIGNAL \signal_out[2]~output_o\ : std_logic;
SIGNAL \signal_out[3]~output_o\ : std_logic;
SIGNAL \signal_out[4]~output_o\ : std_logic;
SIGNAL \signal_out[5]~output_o\ : std_logic;
SIGNAL \signal_out[6]~output_o\ : std_logic;
SIGNAL \signal_out[7]~output_o\ : std_logic;
SIGNAL \clk~input_o\ : std_logic;
SIGNAL \clk~inputclkctrl_outclk\ : std_logic;
SIGNAL \signal_in~input_o\ : std_logic;
SIGNAL \delay_line_inst|latch_1:0:ff|q~feeder_combout\ : std_logic;
SIGNAL \detect_signal_inst|process_0~0_combout\ : std_logic;
SIGNAL \detect_signal_inst|reset~q\ : std_logic;
SIGNAL \delay_line_inst|latch_1:0:ff|q~q\ : std_logic;
SIGNAL \delay_line_inst|latch_2:0:ff|q~feeder_combout\ : std_logic;
SIGNAL \delay_line_inst|latch_2:0:ff|q~q\ : std_logic;
SIGNAL \encoder_inst|count_o[4]~feeder_combout\ : std_logic;
SIGNAL \encoder_inst|count_o\ : std_logic_vector(7 DOWNTO 0);
SIGNAL \detect_signal_inst|ALT_INV_reset~q\ : std_logic;

COMPONENT hard_block
    PORT (
	devoe : IN std_logic;
	devclrn : IN std_logic;
	devpor : IN std_logic);
END COMPONENT;

BEGIN

ww_clk <= clk;
ww_signal_in <= signal_in;
signal_out <= ww_signal_out;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;

\~QUARTUS_CREATED_ADC1~_CHSEL_bus\ <= (\~QUARTUS_CREATED_GND~I_combout\ & \~QUARTUS_CREATED_GND~I_combout\ & \~QUARTUS_CREATED_GND~I_combout\ & \~QUARTUS_CREATED_GND~I_combout\ & \~QUARTUS_CREATED_GND~I_combout\);

\clk~inputclkctrl_INCLK_bus\ <= (vcc & vcc & vcc & \clk~input_o\);
\detect_signal_inst|ALT_INV_reset~q\ <= NOT \detect_signal_inst|reset~q\;
auto_generated_inst : hard_block
PORT MAP (
	devoe => ww_devoe,
	devclrn => ww_devclrn,
	devpor => ww_devpor);

-- Location: LCCOMB_X11_Y22_N20
\~QUARTUS_CREATED_GND~I\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \~QUARTUS_CREATED_GND~I_combout\ = GND

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	combout => \~QUARTUS_CREATED_GND~I_combout\);

-- Location: IOOBUF_X0_Y8_N16
\signal_out[0]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \signal_out[0]~output_o\);

-- Location: IOOBUF_X0_Y5_N2
\signal_out[1]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \signal_out[1]~output_o\);

-- Location: IOOBUF_X6_Y0_N23
\signal_out[2]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \signal_out[2]~output_o\);

-- Location: IOOBUF_X13_Y25_N16
\signal_out[3]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \signal_out[3]~output_o\);

-- Location: IOOBUF_X17_Y0_N23
\signal_out[4]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \encoder_inst|count_o\(4),
	devoe => ww_devoe,
	o => \signal_out[4]~output_o\);

-- Location: IOOBUF_X31_Y6_N16
\signal_out[5]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \signal_out[5]~output_o\);

-- Location: IOOBUF_X11_Y0_N30
\signal_out[6]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \signal_out[6]~output_o\);

-- Location: IOOBUF_X13_Y0_N16
\signal_out[7]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \signal_out[7]~output_o\);

-- Location: IOIBUF_X0_Y6_N15
\clk~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_clk,
	o => \clk~input_o\);

-- Location: CLKCTRL_G3
\clk~inputclkctrl\ : fiftyfivenm_clkctrl
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	ena_register_mode => "none")
-- pragma translate_on
PORT MAP (
	inclk => \clk~inputclkctrl_INCLK_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	outclk => \clk~inputclkctrl_outclk\);

-- Location: IOIBUF_X17_Y0_N1
\signal_in~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_signal_in,
	o => \signal_in~input_o\);

-- Location: LCCOMB_X17_Y1_N28
\delay_line_inst|latch_1:0:ff|q~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \delay_line_inst|latch_1:0:ff|q~feeder_combout\ = \signal_in~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \signal_in~input_o\,
	combout => \delay_line_inst|latch_1:0:ff|q~feeder_combout\);

-- Location: LCCOMB_X17_Y1_N14
\detect_signal_inst|process_0~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \detect_signal_inst|process_0~0_combout\ = (!\signal_in~input_o\ & \delay_line_inst|latch_1:0:ff|q~q\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \signal_in~input_o\,
	datad => \delay_line_inst|latch_1:0:ff|q~q\,
	combout => \detect_signal_inst|process_0~0_combout\);

-- Location: FF_X17_Y1_N15
\detect_signal_inst|reset\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \detect_signal_inst|process_0~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \detect_signal_inst|reset~q\);

-- Location: FF_X17_Y1_N29
\delay_line_inst|latch_1:0:ff|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \delay_line_inst|latch_1:0:ff|q~feeder_combout\,
	clrn => \detect_signal_inst|ALT_INV_reset~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \delay_line_inst|latch_1:0:ff|q~q\);

-- Location: LCCOMB_X17_Y1_N18
\delay_line_inst|latch_2:0:ff|q~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \delay_line_inst|latch_2:0:ff|q~feeder_combout\ = \delay_line_inst|latch_1:0:ff|q~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \delay_line_inst|latch_1:0:ff|q~q\,
	combout => \delay_line_inst|latch_2:0:ff|q~feeder_combout\);

-- Location: FF_X17_Y1_N19
\delay_line_inst|latch_2:0:ff|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \delay_line_inst|latch_2:0:ff|q~feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \delay_line_inst|latch_2:0:ff|q~q\);

-- Location: LCCOMB_X17_Y1_N20
\encoder_inst|count_o[4]~feeder\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \encoder_inst|count_o[4]~feeder_combout\ = \delay_line_inst|latch_2:0:ff|q~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \delay_line_inst|latch_2:0:ff|q~q\,
	combout => \encoder_inst|count_o[4]~feeder_combout\);

-- Location: FF_X17_Y1_N21
\encoder_inst|count_o[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \encoder_inst|count_o[4]~feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \encoder_inst|count_o\(4));

-- Location: UNVM_X0_Y11_N40
\~QUARTUS_CREATED_UNVM~\ : fiftyfivenm_unvm
-- pragma translate_off
GENERIC MAP (
	addr_range1_end_addr => -1,
	addr_range1_offset => -1,
	addr_range2_end_addr => -1,
	addr_range2_offset => -1,
	addr_range3_offset => -1,
	is_compressed_image => "false",
	is_dual_boot => "false",
	is_eram_skip => "false",
	max_ufm_valid_addr => -1,
	max_valid_addr => -1,
	min_ufm_valid_addr => -1,
	min_valid_addr => -1,
	part_name => "quartus_created_unvm",
	reserve_block => "true")
-- pragma translate_on
PORT MAP (
	nosc_ena => \~QUARTUS_CREATED_GND~I_combout\,
	xe_ye => \~QUARTUS_CREATED_GND~I_combout\,
	se => \~QUARTUS_CREATED_GND~I_combout\,
	busy => \~QUARTUS_CREATED_UNVM~~busy\);

-- Location: ADCBLOCK_X10_Y24_N0
\~QUARTUS_CREATED_ADC1~\ : fiftyfivenm_adcblock
-- pragma translate_off
GENERIC MAP (
	analog_input_pin_mask => 0,
	clkdiv => 1,
	device_partname_fivechar_prefix => "none",
	is_this_first_or_second_adc => 1,
	prescalar => 0,
	pwd => 1,
	refsel => 0,
	reserve_block => "true",
	testbits => 66,
	tsclkdiv => 1,
	tsclksel => 0)
-- pragma translate_on
PORT MAP (
	soc => \~QUARTUS_CREATED_GND~I_combout\,
	usr_pwd => VCC,
	tsen => \~QUARTUS_CREATED_GND~I_combout\,
	chsel => \~QUARTUS_CREATED_ADC1~_CHSEL_bus\,
	eoc => \~QUARTUS_CREATED_ADC1~~eoc\);

ww_signal_out(0) <= \signal_out[0]~output_o\;

ww_signal_out(1) <= \signal_out[1]~output_o\;

ww_signal_out(2) <= \signal_out[2]~output_o\;

ww_signal_out(3) <= \signal_out[3]~output_o\;

ww_signal_out(4) <= \signal_out[4]~output_o\;

ww_signal_out(5) <= \signal_out[5]~output_o\;

ww_signal_out(6) <= \signal_out[6]~output_o\;

ww_signal_out(7) <= \signal_out[7]~output_o\;
END structure;


