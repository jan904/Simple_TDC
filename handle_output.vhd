LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY handle_output is
    GENERIC(
        coarse_bits : INTEGER := 4;
        fine_bits : INTEGER := 4
    );
    PORT(
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        data_coarse : IN STD_LOGIC_VECTOR(coarse_bits-1 DOWNTO 0);
        data_fine : IN STD_LOGIC_VECTOR(fine_bits-1 DOWNTO 0);
        wr_en : IN STD_LOGIC;
        data_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        wr_en_out : OUT STD_LOGIC
    );
END handle_output;