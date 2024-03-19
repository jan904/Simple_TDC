library ieee;
use ieee.std_logic_1164.all;

entity fdr is
    port (
        rst : in std_logic;
        lock : in std_logic;
        clk : in std_logic;
        t : in std_logic;
        q : out std_logic
    );
end fdr;

architecture rtl of fdr is
    
begin
    process(clk, rst)
    begin
        if rst = '1' then
            q <= '0';
        elsif clk'event and clk = '1' then
            if lock = '0' then
                q <= t;
            end if;
        end if;
    end process;
end rtl;