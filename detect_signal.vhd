library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity detect_signal is
    generic (
        stages : integer;
        n_output_bits : integer
    );
    port (
        clock : in std_logic;
        signal_in : in std_logic;
        interm_latch : in std_logic_vector(stages-1 downto 0);
        signal_out : in std_logic_vector(n_output_bits-1 downto 0);
        signal_running : out std_logic;
        reset : out std_logic
    );
end entity detect_signal;

architecture rtl of detect_signal is
begin
    
    process(clock)
    begin   
        if rising_edge(clock) then
            if ((interm_latch(0) = '1')) then
                signal_running <= '1';
            else
                signal_running <= '0';
            end if;

            if ((unsigned(signal_out) > 0) and (signal_in = '0')) then
                reset <= '1';
            else
                reset <= '0';
            end if;

        end if;
    end process;
    
end architecture rtl;
