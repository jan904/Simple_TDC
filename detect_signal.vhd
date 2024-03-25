LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY detect_signal IS
    GENERIC (
        stages : INTEGER := 124;
        n_output_bits : INTEGER := 8
    );
    PORT (
        clock : IN STD_LOGIC;
        start : IN STD_LOGIC;
        signal_in : IN STD_LOGIC;
        interm_latch : IN STD_LOGIC_VECTOR(stages - 1 DOWNTO 0);
        signal_out : IN STD_LOGIC_VECTOR(n_output_bits - 1 DOWNTO 0);
        signal_running : OUT STD_LOGIC;
        reset : OUT STD_LOGIC;
        wrt : OUT STD_LOGIC
    );
END ENTITY detect_signal;


ARCHITECTURE fsm OF detect_signal IS

    TYPE stype IS (IDLE, DETECT_START, WRITE_FIFO, RST);
    SIGNAL state, next_state : stype;
    SIGNAL reset_reg, reset_next : STD_LOGIC;
    SIGNAL signal_running_reg, signal_running_next : STD_LOGIC;
    SIGNAL wrt_reg, wrt_next : STD_LOGIC;

BEGIN
    PROCESS(clock)
    BEGIN
        IF rising_edge(clock) THEN
            IF start = '1' THEN
                state <= IDLE;
                signal_running_reg <= '0';
                reset_reg <= '0';
                wrt_reg <= '0';
            ELSE
                signal_running_reg <= signal_running_next;
                reset_reg <= reset_next;
                wrt_reg <= wrt_next;
                state <= next_state;
            END IF;
        END IF;
    END PROCESS;

    PROCESS (state, signal_running_reg, wrt_reg, reset_reg, signal_out, signal_in, interm_latch)  
    BEGIN

        next_state <= state;
        wrt_next <= wrt_reg;
        reset_next <= reset_reg;
        signal_running_next <= signal_running_reg;

        CASE state IS
            WHEN IDLE =>
                IF interm_latch(0) = '1' THEN
                    next_state <= DETECT_START;
                    signal_running_next <= '1';
                ELSE
                    next_state <= IDLE;
                END IF;
                
            WHEN DETECT_START =>
                IF unsigned(signal_out) > 0 THEN
                    next_state <= WRITE_FIFO;
                ELSE
                    next_state <= DETECT_START;
                END IF;

            WHEN WRITE_FIFO =>
                wrt_next <= '1';
                next_state <= RST;

            WHEN RST =>
                IF signal_in = '1' THEN
                    IF reset_reg = '1' THEN
                        next_state <= IDLE;
                        signal_running_next <= '0';
                        reset_next <= '0';
                    ELSIF reset_reg = '0' THEN
                        next_state <= RST;
                        reset_next <= '1';
                    END IF;
                ELSE 
                    next_state <= RST;
                END IF;
                wrt_next <= '0';

            WHEN OTHERS =>
                next_state <= IDLE;
        END CASE;
    END PROCESS;

    signal_running <= signal_running_reg;
    reset <= reset_reg;
    wrt <= wrt_reg;

END ARCHITECTURE fsm;