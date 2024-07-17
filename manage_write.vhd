LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY manage_write IS
    GENERIC (
        n_output_bits : INTEGER := 8
    );
    PORT (
        clk : IN STD_LOGIC;
        starting : IN STD_LOGIC;
        signal_1 : IN STD_LOGIC;
        signal_2 : IN STD_LOGIC;
        signal_out_1 : IN STD_LOGIC_VECTOR(n_output_bits - 1 DOWNTO 0);
        signal_out_2 : IN STD_LOGIC_VECTOR(n_output_bits - 1 DOWNTO 0);
        wr_1 : IN STD_LOGIC;
        wr_2 : IN STD_LOGIC;
        wr : OUT STD_LOGIC;
        finished : OUT STD_LOGIC;
        output : OUT STD_LOGIC_VECTOR(n_output_bits - 1 DOWNTO 0)
    );
END ENTITY manage_write;

ARCHITECTURE rtl OF manage_write IS

    TYPE stype IS (IDLE, WAIT_FOR_2, WRITE_1, WRITE_2, TEST, FINISHED_WRT, RST);
    SIGNAL state, next_state : stype;

    SIGNAL wr_next, wr_reg : STD_LOGIC;
    SIGNAL finished_next, finished_reg : STD_LOGIC;
    SIGNAL output_next, output_reg : STD_LOGIC_VECTOR(n_output_bits - 1 DOWNTO 0);

BEGIN

    PROCESS(clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF starting = '1' THEN
                state <= IDLE;
                wr_reg <= '0';
                finished_reg <= '0';
                output_reg <= (OTHERS => '0');

            ELSE
                finished_reg <= finished_next;
                wr_reg <= wr_next;
                output_reg <= output_next;
                state <= next_state;
            END IF;
        END IF;
    END PROCESS;

    PROCESS (state, signal_1, signal_2, wr_1, wr_2, finished_reg, wr_reg, output_reg, signal_out_1, signal_out_2)
    BEGIN

        next_state <= state;
        wr_next <= wr_reg;
        finished_next <= finished_reg;
        output_next <= output_reg;

        CASE state IS
            WHEN IDLE =>
                IF wr_1 = '1' THEN
                    next_state <= WAIT_FOR_2;
                ELSE
                    next_state <= IDLE;
                END IF;

            WHEN WAIT_FOR_2 =>
                IF wr_2 = '1' THEN
                    next_state <= WRITE_1;
                ELSE
                    next_state <= WAIT_FOR_2;
                END IF;

            WHEN WRITE_1 =>
                output_next <= signal_out_1;
                wr_next <= '1';
                next_state <= WRITE_2;

            WHEN WRITE_2 =>
                output_next <= signal_out_2;
                wr_next <= '1';
                next_state <= FINISHED_WRT;

            WHEN TEST =>
                wr_next <= '0';
                next_state <= FINISHED_WRT;

            WHEN FINISHED_WRT =>
                wr_next <= '0';
                IF (signal_1 = '0' and signal_2 = '0') THEN
                    finished_next <= '1';
                    next_state <= RST;
                ELSE
                    next_state <= FINISHED_WRT;
                END IF;

            WHEN RST =>
                finished_next <= '0';
                output_next <= (OTHERS => '0');
                next_state <= IDLE;
            
            WHEN OTHERS =>
                next_state <= IDLE;

        END CASE;
    END PROCESS;

    wr <= wr_reg;
    finished <= finished_reg;
    output <= output_reg;

END ARCHITECTURE rtl;
