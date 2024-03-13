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

    signal carry : std_logic_vector(4 downto 0);

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
    
    instan_fa : for ii in 0 to 3 generate
        fa : full_add port map (
            a => a(ii), 
            b => b(ii),
            Cin => carry(ii),
            Cout => carry(ii+1)
        );
    end generate instan_fa;

    Cout_vector(0) <= carry(1);
    Cout_vector(1) <= carry(2);
    Cout_vector(2) <= carry(3);
    Cout_vector(3) <= carry(4);
    
end architecture rtl;

