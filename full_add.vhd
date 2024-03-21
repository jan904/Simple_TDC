-- Full adder fo two 1 Bit inputs
--
-- This is a full adder that takes two 1 Bit inputs and a carry in and outputs a carry out.
-- The sum is not calculated as we don't need it for the purpose of a delay chain.
--
--Inputs:
--  a, b : 1 Bit inputs
--  Cin : Carry in
--
--Outputs:
--  Cout : Carry out

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
