library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity carry4 is
    port (
        a, b : in std_logic_vector(3 downto 0);
        Cin : in std_logic;
        trigger : in std_logic;
        Cout_vector : out std_logic_vector(3 downto 0)
    );
end entity carry4;

architecture rtl of carry4 is

    signal carry : std_logic_vector(3 downto 0);
    signal last_bit : std_logic;

    component full_add is
        port (
            a : in std_logic;
            b : in std_logic;
            Cin : in std_logic;
            Cout : out std_logic
        );  
    end component full_add;

begin
    carry(0) <= Cin or trigger;
    
    instan_fa : for ii in 0 to 2 generate
        fa : full_add port map (
            a => a(ii), 
            b => b(ii),
            Cin => carry(ii),
            Cout => carry(ii+1)
        );
    end generate instan_fa;

    fa_last : full_add port map (
        a => a(3),
        b => b(3),
        Cin => carry(3),
        Cout => last_bit
    );
    
    process(carry, last_bit, trigger)
    begin
        for jj in 1 to 3 loop
            Cout_vector(jj-1) <= carry(jj);
        end loop;
        Cout_vector(3) <= last_bit;
    end process;
    
end architecture rtl;

