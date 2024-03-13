library ieee;
use ieee.std_logic_1164.all;

entity encoder is
    generic (
        g_N : positive := 4;
        g_NIN : positive := 15
    );
    port (
        clk : in std_logic;
        thermometer : in std_logic_vector((g_NIN-1) downto 0);
        count_o : out std_logic_vector(g_N-1 downto 0) 
    );
end entity encoder;


architecture rtl of encoder is

signal completed_in : std_logic_vector(2**g_N-2 downto 0);

function cls(d: std_logic_vector; symbol: std_logic) return std_logic_vector is
    variable v_d: std_logic_vector(d'length-1 downto 0);
begin
    v_d := d;
    if v_d'length = 1 then
        if v_d(0) = symbol then
            return "1";
        else
            return "0";
        end if;
    else
        if v_d(v_d'length-1 downto v_d'length/2) = (v_d'length-1 downto v_d'length/2 => symbol) then
            return "1" & cls(v_d(v_d'length/2-1 downto 0), symbol);
        else
            return "0" & cls(v_d(v_d'length-1 downto v_d'length/2+1), symbol);
        end if;
    end if;
end function cls;

begin

    expand: if g_NIN < 2**g_N-1 generate
        completed_in <= thermometer & (others => '0');
    end generate expand;

    not_expand: if g_NIN < 2**g_N-1 generate
        completed_in <= thermometer;
    end generate expand;

    process(clk)
    begin
        if rising_edge(clk) then
            count_o <= cls(completed_in, '1');
        end if;
    end process;
end architecture rtl;

