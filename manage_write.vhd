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
    SIGNAL res_1, res_1_next, res_2, res_2_next : STD_LOGIC_VECTOR(n_output_bits - 1 DOWNTO 0);

    SIGNAL idle_count, idle_count_next : INTEGER RANGE 0 TO 100;

BEGIN

    PROCESS(clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF starting = '1' THEN
                state <= IDLE;
                wr_reg <= '0';
                finished_reg <= '0';
                output_reg <= (OTHERS => '0');
                res_1 <= (OTHERS => '0');
                res_2 <= (OTHERS => '0');
                idle_count <= 0;

            ELSE
                finished_reg <= finished_next;
                wr_reg <= wr_next;
                output_reg <= output_next;
                state <= next_state;
                res_1 <= res_1_next;
                res_2 <= res_2_next;
                idle_count <= idle_count_next;
            END IF;
        END IF;
    END PROCESS;

    PROCESS (state, signal_1, signal_2, idle_count, wr_1, wr_2, res_1, res_2, finished_reg, wr_reg, output_reg, signal_out_1, signal_out_2)
    BEGIN

        next_state <= state;
        wr_next <= wr_reg;
        finished_next <= finished_reg;
        output_next <= output_reg;
        res_1_next <= res_1;
        res_2_next <= res_2;
        idle_count_next <= idle_count;

        CASE state IS
            WHEN IDLE =>
                IF wr_1 = '1' and wr_2 = '1' THEN
                    next_state <= WRITE_1;
                    --output_next <= "00000001";
                    res_1_next <= signal_out_1;
                    res_2_next <= signal_out_2;
                ELSIF wr_1 = '1' and wr_2 = '0' THEN
                    next_state <= WAIT_FOR_2;
                ELSIF wr_1 = '0' and wr_2 = '1' THEN
                    next_state <= FINISHED_WRT;
                ELSE
                    --output_next <= "11000000";
                    next_state <= IDLE;
                END IF;

            WHEN WAIT_FOR_2 =>
                IF wr_2 = '1' THEN
                    next_state <= WRITE_1;
                    --output_next <= "00000001";
                    res_1_next <= signal_out_1;
                    res_2_next <= signal_out_2;
                --ELSIF idle_count = 5 THEN
                    --output_next <= "00000010";
                --    next_state <= FINISHED_WRT;
                ELSE
                    --output_next <= "00000111";
                    next_state <= FINISHED_WRT;
                    idle_count_next <= idle_count + 1;
                END IF;

            WHEN WRITE_1 =>
                output_next <= res_1;
                wr_next <= '1';
                next_state <= WRITE_2;

            WHEN WRITE_2 =>
                output_next <= res_2;
                wr_next <= '1';
                next_state <= TEST;

            WHEN TEST =>
                wr_next <= '0';
                next_state <= FINISHED_WRT;

            WHEN FINISHED_WRT =>
                --output_next <= "01000000";
                IF (signal_1 = '0' and signal_2 = '0') THEN
                    finished_next <= '1';
                    next_state <= RST;
                ELSE
                    next_state <= FINISHED_WRT;
                END IF;

            WHEN RST =>
                finished_next <= '0';
                output_next <= "01010101";
                next_state <= IDLE;
                idle_count_next <= 0;
            
            WHEN OTHERS =>
                next_state <= IDLE;

        END CASE;
    END PROCESS;

    wr <= wr_reg;
    finished <= finished_reg;
    output <= output_reg;

END ARCHITECTURE rtl;
