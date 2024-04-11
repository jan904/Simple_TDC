library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY sync_counter IS
    PORT(
        clk : IN STD_LOGIC;
        cnt : OUT STD_LOGIC
    );
END ENTITY sync_counter;

ARCHITECTURE rtl OF sync_counter IS

    SIGNAL cnt_int : UNSIGNED(7 DOWNTO 0) := (OTHERS => '0');

BEGIN

    PROCESS(clk)
    BEGIN
        IF rising_edge(clk) THEN
            cnt_int <= cnt_int + 1;
        END IF;
    END PROCESS;

    cnt <= std_logic(cnt_int(7));

END ARCHITECTURE rtl;