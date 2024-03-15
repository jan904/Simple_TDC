library ieee;
use ieee.std_logic_1164.all;

entity full_add is
    port (
      a : in std_logic;
      b : in std_logic;
      Cin : in std_logic;
      Cout : out std_logic
    );
end entity full_add;

architecture behavioral of full_add is

begin
    Cout <= transport (a and b) or (Cin and (a xor b)) after 6 ns;
end architecture behavioral;  
