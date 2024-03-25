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


ARCHITECTURE fsm OF detect_signal IS

    TYPE stype IS (IDLE, DETECT_START, WRITE, RST);
    SIGNAL state, next_state : stype;
    SIGNAL reset_reg : STD_LOGIC;
    SIGNAL signal_running_reg : STD_LOGIC;
    SIGNAL wrt_reg : STD_LOGIC;

BEGIN
    PROCESS(clock)
    BEGIN
        IF rising_edge(clock) THEN
            signal_running <= signal_running_reg;
            reset <= reset_reg;
            wrt <= wrt_reg;
            state <= next_state;
        END IF;
    END PROCESS;

    PROCESS (state, signal_running_reg, wrt_reg, reset_reg, signal_out, signal_in, interm_latch)  
    BEGIN
        CASE state IS
            WHEN IDLE =>
                reset_reg <= '0';
                signal_running_reg <= '0';
                wrt_reg <= '0';
                IF interm_latch(0) = '1' THEN
                    next_state <= DETECT_START;
                    signal_running_reg <= '1';
                ELSE
                    next_state <= IDLE;
                END IF;

            WHEN DETECT_START =>
                IF unsigned(signal_out) > 0 THEN
                    next_state <= WRITE;
                ELSE
                    next_state <= DETECT_START;
                END IF;

            WHEN WRITE =>
                wrt_reg <= '1';
                next_state <= RST;

            WHEN RST =>
                IF signal_in = '1' THEN
                    next_state <= IDLE;
                    signal_running_reg <= '0';
                    reset_reg <= '1';
                ELSE 
                    next_state <= RST;
                END IF;
                wrt_reg <= '0';

            WHEN OTHERS =>
                next_state <= IDLE;
        END CASE;
    END PROCESS;

END ARCHITECTURE fsm;