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
        n_output_bits : INTEGER := 8;
        coarse_bits : INTEGER := 32
    );
    PORT (
        clk : IN STD_LOGIC;
        signal_in : IN STD_LOGIC;
        signal_out : OUT STD_LOGIC_VECTOR(n_output_bits - 1 DOWNTO 0);
        serial_out : OUT STD_LOGIC
    );
END ENTITY channel;
ARCHITECTURE rtl OF channel IS

    SIGNAL reset_after_start : STD_LOGIC;
    SIGNAL reset_after_signal : STD_LOGIC;
    SIGNAL busy : STD_LOGIC;
    SIGNAL wr_en : STD_LOGIC;
    SIGNAL therm_code : STD_LOGIC_VECTOR(carry4_count * 4 - 1 DOWNTO 0);
    SIGNAL detect_edge : STD_LOGIC_VECTOR(carry4_count * 4 - 1 DOWNTO 0);
    SIGNAL bin_output : STD_LOGIC_VECTOR(n_output_bits - 1 DOWNTO 0);
    SIGNAL tap_clk : STD_LOGIC;
    SIGNAL fifo_empty : STD_LOGIC;
    SIGNAL coarse_count : STD_LOGIC_VECTOR(coarse_bits-1 DOWNTO 0);
    SIGNAL output : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL wr_en_out : STD_LOGIC;
    SIGNAL done_writing : STD_LOGIC;

    COMPONENT delay_line IS
        GENERIC (
            stages : POSITIVE
        );
        PORT (
            reset : IN STD_LOGIC;
            trigger : IN STD_LOGIC;
            clock : IN STD_LOGIC;
            signal_running : IN STD_LOGIC;
            intermediate_signal : OUT STD_LOGIC_VECTOR(stages - 1 DOWNTO 0);
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
            interm_latch : IN STD_LOGIC_VECTOR(stages - 1 DOWNTO 0);
            signal_out : IN STD_LOGIC_VECTOR(n_output_bits - 1 DOWNTO 0);
            done_write : IN STD_LOGIC;
            uart_not_full : IN STD_LOGIC;
            signal_running : OUT STD_LOGIC;
            reset : OUT STD_LOGIC;
            wrt : OUT STD_LOGIC
        );
    END COMPONENT detect_signal;

    COMPONENT uart IS
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            we : IN STD_LOGIC;
            din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            empty : OUT STD_LOGIC;
            tx : OUT STD_LOGIC
        );
    END COMPONENT uart;

    COMPONENT handle_start IS
        PORT (
            clk : IN STD_LOGIC;
            starting : OUT STD_LOGIC
        );
    END COMPONENT handle_start;

    COMPONENT coarse_counter IS
        GENERIC (
            coarse_bits : INTEGER
        );
        PORT (
            clk : IN STD_LOGIC;
            start : IN STD_LOGIC;
            signal_start : IN STD_LOGIC;
            signal_done : IN STD_LOGIC;
            count : OUT STD_LOGIC_VECTOR(coarse_bits-1 DOWNTO 0)
        );
    END COMPONENT coarse_counter;

    COMPONENT handle_output IS
        GENERIC (
            coarse_bits : INTEGER;
            fine_bits : INTEGER
        );
        PORT (
            clk : IN STD_LOGIC;
            start : IN STD_LOGIC;
            data_coarse : IN STD_LOGIC_VECTOR(coarse_bits-1 DOWNTO 0);
            data_fine : IN STD_LOGIC_VECTOR(fine_bits-1 DOWNTO 0);
            wr_en : IN STD_LOGIC;
            fifo_empty : IN STD_LOGIC;
            data_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            wr_en_out : OUT STD_LOGIC;
            done_wr : OUT STD_LOGIC
        );
    END COMPONENT handle_output;


BEGIN

    --tap_clk <= clk;

    -- send reset signal to all components after start
    handle_start_inst : handle_start
    PORT MAP(
        clk => clk,
        starting => reset_after_start
    );

    -- count the number of clock cycles
    coarse_counter_inst : coarse_counter
    GENERIC MAP(
        coarse_bits => coarse_bits
    )
    PORT MAP(
        clk => clk,
        start => reset_after_start,
        signal_start => busy,
        signal_done => reset_after_signal,
        count => coarse_count
    );


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
        intermediate_signal => detect_edge,
        therm_code => therm_code
    );
	 

    -- detection logic
    detect_signal_inst : detect_signal
    GENERIC MAP(
        stages => carry4_count * 4,
        n_output_bits => n_output_bits
    )
    PORT MAP(
        clock => clk,
        start => reset_after_start,
        signal_in => signal_in,
        interm_latch => detect_edge,
        signal_out => bin_output,
        done_write => done_writing,
        uart_not_full => fifo_empty,
        signal_running => busy,
        reset => reset_after_signal,
        wrt => wr_en
    );
	 

    -- encode the thermometer code into binary
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


    -- send fine + coarse timing information to UART
    handle_output_inst : handle_output
    GENERIC MAP(
        coarse_bits => coarse_bits,
        fine_bits => n_output_bits
    )
    PORT MAP(
        clk => clk,
        start => reset_after_start,
        data_coarse => coarse_count,
        data_fine => bin_output,
        wr_en => wr_en,
        fifo_empty => fifo_empty,
        data_out => output,
        wr_en_out => wr_en_out,
        done_wr => done_writing
    );


    -- send the output via UART
    uart_inst : uart
    PORT MAP(
        clk => clk,
        rst => reset_after_start,
        we => wr_en_out,
        din => output,
        empty => fifo_empty,
        tx => serial_out
    );
        
END ARCHITECTURE rtl;