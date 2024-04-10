-- Coarse counter for number of clock cycles
--
-- This module is a simple counter that counts the number of clock cycles. When an input signal is detected,
-- the current count is stored in a vector. 

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY coarse_counter IS
    GENERIC(
        coarse_bits : INTEGER := 32
    );
    PORT(
        clk : IN STD_LOGIC;
        start : IN STD_LOGIC;  
        signal_start : IN STD_LOGIC;
        signal_done : IN STD_LOGIC;
        count : OUT STD_LOGIC_VECTOR(coarse_bits-1 DOWNTO 0)
    );
END ENTITY coarse_counter;

ARCHITECTURE rtl OF coarse_counter IS
    
    SIGNAL count_reg : UNSIGNED(coarse_bits-1 DOWNTO 0) := (OTHERS => '0');

    COMPONENT fdr IS
        PORT(
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            lock : IN STD_LOGIC;
            t : IN STD_LOGIC;
            q : OUT STD_LOGIC
        );
    END COMPONENT fdr;


BEGIN
    
    PROCESS(clk, start)
    BEGIN
        IF start = '1' THEN
            count_reg <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            --IF count_reg = 11111111111111111111111111111111 THEN
            --    count_reg <= (OTHERS => '0');
            --ELSE
                count_reg <= count_reg + 1;
            --END IF;
        END IF;
    END PROCESS;

    
    store_coarse : FOR i IN 0 TO coarse_bits-1 GENERATE
    BEGIN
        PROCESS(clk)
        BEGIN
            IF (rising_edge(clk) AND signal_start = '0') THEN
                count(i) <= count_reg(i);
            END IF;
        END PROCESS;
    END GENERATE store_coarse;
    
    END ARCHITECTURE rtl;