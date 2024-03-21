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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity delay_line is
    generic (
        stages : integer 
    );
    port (
        reset : in std_logic;
        trigger : in std_logic;
        clock : in std_logic;
        signal_running : in std_logic;
        intermediate_signal : out std_logic_vector(stages-1 downto 0);
        therm_code : out std_logic_vector(stages-1 downto 0)
    );
end delay_line;


architecture rtl of delay_line is

    signal unlatched_signal : std_logic_vector(stages-1 downto 0);
    signal latched_once : std_logic_vector(stages-1 downto 0);
--  signal Cin : std_logic := '0';

    component carry4
        port (
            a, b : in std_logic_vector(3 downto 0);
            Cin : in std_logic;
            Cout_vector : out std_logic_vector(3 downto 0)
        );
    end component;

    component fdr
        port (
            rst: in std_logic;
            clk: in std_logic;
            lock : in std_logic;
            t: in std_logic;
            q: out std_logic
        );
    end component;

begin
    carry_delay_line: for i in 0 to stages/4 - 1 generate
        first_carry4: if i = 0 generate
        begin
            delayblock: carry4
                port map (
                    a => "0000",
                    b => "1111",
                    Cin => trigger,
                    Cout_vector => unlatched_signal(3 downto 0)
                );
        end generate first_carry4;

        next_carry4: if i > 0 generate
        begin
            delayblock: carry4
                port map (
                    a => "0000",
                    b => "1111",
                    Cin => unlatched_signal((4*i)-1),
                    Cout_vector => unlatched_signal((4*(i+1))-1 downto (4*i))
                );
        end generate next_carry4;
    end generate;

    latch_1: for i in 0 to stages-1 generate
    begin
        ff: fdr
            port map (
                rst => reset,
                lock => signal_running,
                clk => clock,
                t => unlatched_signal(i),
                q => latched_once(i)
            );
    end generate latch_1;

    intermediate_signal <= latched_once;

    latch_2: for i in 0 to stages-1 generate
    begin
        ff: fdr
            port map (
                rst => reset,
                lock => signal_running,
                clk => clock,
                t => latched_once(i),
                q => therm_code(i)
            );
    end generate latch_2;
    
end architecture rtl;
      
