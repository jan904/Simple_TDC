library ieee;
use ieee.std_logic_1164.all;

entity fdr is
    port (
        clk : in std_logic;
        t : in std_logic;
        q : out std_logic
    );
end fdr;

architecture rtl of fdr is

    signal temp : std_logic;
    
begin
    process(clk)
    begin
        if clk'event and clk = '1' then
            q <= not t;
        end if;
    end process;
end rtl;