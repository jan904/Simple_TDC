library ieee;
use ieee.std_logic_1164.all;

entity encoder is
    generic (
        n_bits_bin : positive;
        n_bits_therm : positive
    );
    port (
        clk : in std_logic;
        thermometer : in std_logic_vector((n_bits_therm-1) downto 0);
        count_o : out std_logic_vector(n_bits_bin-1 downto 0) 
    );
end entity encoder;


architecture rtl of encoder is

signal completed_in : std_logic_vector(2**(n_bits_bin)-2 downto 0);
signal count : std_logic_vector(n_bits_bin-1 downto 0);

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

    expand: if n_bits_therm < 2**(n_bits_bin)-1 generate
        completed_in <= thermometer & ((2**(n_bits_bin)-1 - n_bits_therm) downto 0 => '0');
    end generate expand;

    not_expand: if n_bits_therm = 2**(n_bits_bin)-1 generate
        completed_in <= thermometer;
    end generate not_expand;

    process(clk)
    begin
        if rising_edge(clk) then
            count <= cls(completed_in, '1');
        end if;
    end process;
    count_o <= count;
end architecture rtl;

