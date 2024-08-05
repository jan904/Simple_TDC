-- Top level entity for the project
--
-- This module takes the input signal and generates timing information for it. 
-- The timing information is then encoded into a binary signal and sent to the
-- UART module for serial output.
--
-- Inputs:
--   clk: The clock signal
--   signal_in: Trigger signal we want to get timing information on
--
-- Outputs:
--   signal_out: Binary timing information 
--   serial_out: Serial output of the binary timing information     


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY channel IS
    GENERIC (
        carry4_count : INTEGER := 32;
        n_output_bits : INTEGER := 8
    );
    PORT (
        clk : IN STD_LOGIC;
        signal_in : IN STD_LOGIC;
        starting : IN STD_LOGIC;
        both_finished : IN STD_LOGIC;
        wr_en : OUT STD_LOGIC;
        signal_out : OUT STD_LOGIC_VECTOR(n_output_bits - 1 DOWNTO 0)
    );
END ENTITY channel;


ARCHITECTURE rtl OF channel IS

    SIGNAL reset_after_signal : STD_LOGIC;
    SIGNAL busy : STD_LOGIC;
    SIGNAL wr_en_reg : STD_LOGIC;
    SIGNAL therm_code : STD_LOGIC_VECTOR(carry4_count * 4 - 1 DOWNTO 0);
    SIGNAL bin_output : STD_LOGIC_VECTOR(n_output_bits - 1 DOWNTO 0);

    -- Component declarations
    COMPONENT delay_line IS
        GENERIC (
            stages : POSITIVE
        );
        PORT (
            reset : IN STD_LOGIC;
            trigger : IN STD_LOGIC;
            clock : IN STD_LOGIC;
            signal_running : IN STD_LOGIC;
            therm_code : OUT STD_LOGIC_VECTOR(stages - 1 DOWNTO 0)
        );
    END COMPONENT delay_line;

    COMPONENT encoder IS
        GENERIC (
            n_bits_bin : POSITIVE;
            n_bits_therm : POSITIVE
        );
        PORT (
            clk : IN STD_LOGIC;
            thermometer : IN STD_LOGIC_VECTOR((n_bits_therm - 1) DOWNTO 0);
            count_bin : OUT STD_LOGIC_VECTOR(n_bits_bin - 1 DOWNTO 0)
        );
    END COMPONENT encoder;

    COMPONENT detect_signal IS
        GENERIC (
            stages : POSITIVE;
            n_output_bits : POSITIVE
        );
        PORT (
            clock : IN STD_LOGIC;
            start : IN STD_LOGIC;
            signal_in : IN STD_LOGIC;
            both_finished : IN STD_LOGIC;
            signal_running : OUT STD_LOGIC;
            reset : OUT STD_LOGIC;
            wrt : OUT STD_LOGIC
        );
    END COMPONENT detect_signal;


BEGIN

    -- delay line itself
    delay_line_inst : delay_line
    GENERIC MAP(
        stages => carry4_count * 4
    )
    PORT MAP(
        reset => reset_after_signal,
        signal_running => busy,
        trigger => signal_in,
        clock => clk,
        therm_code => therm_code
    );
	 
    -- logic to detect signal and handle current state of TDC
    detect_signal_inst : detect_signal
    GENERIC MAP(
        stages => carry4_count * 4,
        n_output_bits => n_output_bits
    )
    PORT MAP(
        clock => clk,
        start => starting,
        signal_in => signal_in,
        both_finished => both_finished,
        signal_running => busy,
        reset => reset_after_signal,
        wrt => wr_en_reg
    );

    -- convert thermometer code to binary
    encoder_inst : encoder
    GENERIC MAP(
        n_bits_bin => n_output_bits,
        n_bits_therm => 4 * carry4_count
    )
    PORT MAP(
        clk => clk,
        thermometer => therm_code,
        count_bin => bin_output
    );

    signal_out <= bin_output;
    wr_en <= wr_en_reg;

END ARCHITECTURE rtl;