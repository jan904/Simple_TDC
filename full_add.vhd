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
    component NAND_GATE
        port (
            a,b : in std_logic;
            c : out std_logic
        );
    end component;

    signal and1, and2, xor1: std_logic;

begin
  	and1 <= a and b;
    xor1 <= a xor b;
    and2 <= xor1 and Cin;
    Cout <= transport (and1 or and2) after 500 ps;
end architecture behavioral;  
