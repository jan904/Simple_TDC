LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY detect_signal IS
    GENERIC (
        stages : INTEGER;
        n_output_bits : INTEGER
    );
    PORT (
        clock : IN STD_LOGIC;
        signal_in : IN STD_LOGIC;
        interm_latch : IN STD_LOGIC_VECTOR(stages - 1 DOWNTO 0);
        signal_out : IN STD_LOGIC_VECTOR(n_output_bits - 1 DOWNTO 0);
        signal_running : OUT STD_LOGIC;
        reset : OUT STD_LOGIC;
        wrt : OUT STD_LOGIC
    );
END ENTITY detect_signal;

ARCHITECTURE rtl OF detect_signal IS

    SIGNAL check_write : STD_LOGIC;
    SIGNAL check_reset : STD_LOGIC;
    SIGNAL check_running : STD_LOGIC;
    SIGNAL count : INTEGER := 0;

BEGIN

    wrt <= check_write;
    reset <= check_reset;
    signal_running <= check_running;

    PROCESS (clock)
    BEGIN
        IF rising_edge(clock) THEN
            IF ((interm_latch(0) = '1')) THEN
                check_running <= '1';
            ELSE
                check_running <= '0';
            END IF;

            IF ((unsigned(signal_out) > 0) AND (signal_in = '1')) THEN
                check_reset <= '1';
            ELSE
                check_reset <= '0';
            END IF;

            IF check_running = '1' THEN
                IF count = 1 THEN
                    check_write <= '1';
                    count <= 0;
                ELSE
                    check_write <= '0';
                    count <= count + 1;
                END IF;
            ELSIF check_write = '1' THEN
                check_write <= '0';
            END IF;
            
        END IF;
    END PROCESS;

END ARCHITECTURE rtl;