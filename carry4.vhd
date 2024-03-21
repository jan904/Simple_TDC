-- Carry4 module consisting of 4 full adders
--
-- The carry-in of the first full adder is connected to the Cin input of the module.
-- Each carry-out of the full adders is connected to the carry-in of the next full adder.
-- The carry-outs are stored asynchonously in the Cout_vector output of the module.
--
-- Inputs: 
--  a, b: 4-bit vectors
--  Cin: carry-in
--
-- Outputs:
--  Cout_vector: 4-bit vector containing the carry-outs of the full adders

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY carry4 IS
    PORT (
        a, b : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        Cin : IN STD_LOGIC;
        Cout_vector : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END ENTITY carry4;

ARCHITECTURE rtl OF carry4 IS

    SIGNAL carry : STD_LOGIC_VECTOR(4 DOWNTO 0);

    COMPONENT full_add IS
        PORT (
            a : IN STD_LOGIC;
            b : IN STD_LOGIC;
            Cin : IN STD_LOGIC;
            Cout : OUT STD_LOGIC
        );
    END COMPONENT full_add;

BEGIN
    carry(0) <= Cin;
    instan_fa : FOR ii IN 0 TO 3 GENERATE
        --fa : full_add port map (
        --    a => a(ii), 
        --    b => b(ii),
        --    Cin => carry(ii),
        --    Cout => carry(ii+1)
        --);
        carry(ii + 1) <= (a(ii) AND b(ii)) OR (carry(ii) AND (a(ii) XOR b(ii)));
    END GENERATE instan_fa;

    Cout_vector(0) <= carry(1);
    Cout_vector(1) <= carry(2);
    Cout_vector(2) <= carry(3);
    Cout_vector(3) <= carry(4);

END ARCHITECTURE rtl;