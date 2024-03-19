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
      