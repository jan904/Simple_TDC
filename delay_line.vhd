-- Tapped delay line 
--
-- This module implements a tapped delay line with a configurable number of stages.
-- The delay line is implemented using a chain of carry4 cells. The 4-bit inputs to 
-- the carry4 cells are '0000' and '1111', such that the carry-in propagates through
-- the chain of cells. The carry-in of the first cell is driven by the trigger signal. If a '1' comes in
-- as a trigger, this one propagates through the chain of cells.
-- Each cell has 4 carry-out signals, one for each full adder.
-- One the rising edge of the clock signal, the carry-out signals are latched using a FDR FlipFlop. 
-- The number of ones in the latched signal indicates the number of stages that the input signal has been 
-- propagated through and thus gives timing information. The output of the latches should be perfect thermometer code.
-- The signal is then latched twice for stability reasons.
--
-- Inputs:
--  reset: Asynchronous reset signal. Set to '1' when the TDC is ready for a new signal 
--  trigger: Signal that triggers the delay line
--  clock: Clock signal
--  signal_running: Signal that indicates that the delay chain is busy with a signal
--
-- Outputs:
--  intermediate_signal: signal after the first row of latches
--  therm_code: signal after the second row of latches



LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY delay_line IS
    GENERIC (
        stages : INTEGER := 8
    );
    PORT (
        reset : IN STD_LOGIC;
        trigger : IN STD_LOGIC;
        clock : IN STD_LOGIC;
        signal_running : IN STD_LOGIC;
        intermediate_signal : OUT STD_LOGIC_VECTOR(stages - 1 DOWNTO 0);
        therm_code : OUT STD_LOGIC_VECTOR(stages - 1 DOWNTO 0)
    );
END delay_line;
ARCHITECTURE rtl OF delay_line IS

    SIGNAL unlatched_signal : STD_LOGIC_VECTOR(stages - 1 DOWNTO 0);
    SIGNAL latched_once : STD_LOGIC_VECTOR(stages - 1 DOWNTO 0);
    SIGNAL inverted : STD_LOGIC;

    COMPONENT carry4
        PORT (
            a, b : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            Cin : IN STD_LOGIC;
            Cout_vector : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT fdr
        PORT (
            rst : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            lock : IN STD_LOGIC;
            t : IN STD_LOGIC;
            q : OUT STD_LOGIC
        );
    END COMPONENT;
	
	ATTRIBUTE keep : boolean;
    ATTRIBUTE keep OF unlatched_signal : SIGNAL IS TRUE;
	
BEGIN

    inverted <= NOT trigger;

    carry_delay_line : FOR i IN 0 TO stages/4 - 1 GENERATE
        first_carry4 : IF i = 0 GENERATE
        BEGIN
            delayblock : carry4
            PORT MAP(
                a => "0000",
                b => "1111",
                Cin => inverted,
                Cout_vector => unlatched_signal(3 DOWNTO 0)
            );
        END GENERATE first_carry4;

        next_carry4 : IF i > 0 GENERATE
        BEGIN
            delayblock : carry4
            PORT MAP(
                a => "0000",
                b => "1111",
                Cin => unlatched_signal((4 * i) - 1),
                Cout_vector => unlatched_signal((4 * (i + 1)) - 1 DOWNTO (4 * i))
            );
        END GENERATE next_carry4;
    END GENERATE;

    latch_1 : FOR i IN 0 TO stages - 1 GENERATE
    BEGIN
        ff1 : fdr
        PORT MAP(
            rst => reset,
            lock => signal_running,
            clk => clock,
            t => unlatched_signal(i),
            q => latched_once(i)
        );
    --END GENERATE latch_1;


    --latch_2 : FOR i IN 0 TO stages - 1 GENERATE
    --BEGIN
        ff2 : fdr
        PORT MAP(
            rst => reset,
            lock => signal_running,
            clk => clock,
            t => latched_once(i),
            q => therm_code(i)
        );
    END GENERATE latch_1;

    intermediate_signal <= latched_once;

END ARCHITECTURE rtl;