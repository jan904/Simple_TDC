library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;

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

begin

    process(clk)	
        variable count : unsigned(n_bits_bin-1 downto 0) := (others => '0');
    begin
        if rising_edge(clk) then
            count := (others => '0');
            for i in 0 to n_bits_therm-1 loop
                if thermometer(i) = '1' then
                    count := count + 1;
                end if;
            end loop;
            count_o <= std_logic_vector(count);

        end if;
    end process;

end architecture rtl;