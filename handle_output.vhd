LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY handle_output IS
    GENERIC(
        coarse_bits : INTEGER := 32;
        fine_bits : INTEGER := 8
    );
    PORT(
        clk : IN STD_LOGIC;
        start : IN STD_LOGIC;
        data_coarse : IN STD_LOGIC_VECTOR(coarse_bits-1 DOWNTO 0);
        data_fine : IN STD_LOGIC_VECTOR(fine_bits-1 DOWNTO 0);
        wr_en : IN STD_LOGIC;
        fifo_empty : IN STD_LOGIC;
        data_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        wr_en_out : OUT STD_LOGIC;
        done_wr : OUT STD_LOGIC
    );
END handle_output;

ARCHITECTURE rtl OF handle_output IS
    
    TYPE stype IS (IDLE_O, FINE, COARSE, DONE);
    SIGNAL state, next_state : stype;

    SIGNAL data_out_reg, data_out_next : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL wr_en_out_reg, wr_en_out_next : STD_LOGIC;
    SIGNAL done_wr_reg, done_wr_next : STD_LOGIC;
    SIGNAL count, count_next : INTEGER range 0 to 5;

BEGIN

    PROCESS(clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF start = '1' THEN
                state <= IDLE_O;
                data_out_reg <= (OTHERS => '0');
                wr_en_out_reg <= '0';
                count <= 0;
                done_wr_reg <= '0';
            ELSE
                data_out_reg <= data_out_next;
                wr_en_out_reg <= wr_en_out_next;
                state <= next_state;
                count <= count_next;
                done_wr_reg <= done_wr_next;
            END IF;
        END IF;
    END PROCESS;

    PROCESS(data_coarse, data_fine, wr_en, data_out_reg, wr_en_out_reg, state, count, done_wr_reg, fifo_empty)
    BEGIN

        next_state <= state;
        data_out_next <= data_out_reg;
        wr_en_out_next <= wr_en_out_reg;
        count_next <= count;
        done_wr_next <= done_wr_reg;

        CASE state IS
            WHEN IDLE_O =>
                IF wr_en = '1' and fifo_empty = '1' THEN
                    next_state <= FINE;
                ELSE
                    next_state <= IDLE_O;
                END IF;

            WHEN FINE =>
                data_out_next(7 DOWNTO 0) <= data_fine;
                wr_en_out_next <= '1';
                next_state <= COARSE;

            WHEN COARSE =>
                IF count = 0 THEN
                    data_out_next(7 DOWNTO 0) <= data_coarse(7 DOWNTO 0);
                    wr_en_out_next <= '1';
                    count_next <= count + 1;
                    next_state <= COARSE;
                ELSIF count = 1 THEN
                    data_out_next(7 DOWNTO 0) <= data_coarse(15 DOWNTO 8);
                    wr_en_out_next <= '1';
                    count_next <= count + 1;
                    next_state <= COARSE;
                ELSIF count = 2 THEN
                    data_out_next(7 DOWNTO 0) <= data_coarse(23 DOWNTO 16);
                    wr_en_out_next <= '1';
                    count_next <= count + 1;
                    next_state <= COARSE;
                ELSIF count = 3 THEN
                    data_out_next(7 DOWNTO 0) <= data_coarse(31 DOWNTO 24);
                    wr_en_out_next <= '1';
                    count_next <= count + 1;
                    next_state <= DONE;
                END IF;
            
            WHEN DONE =>
                IF count = 5 THEN
                    next_state <= IDLE_O;
                    data_out_next <= (OTHERS => '0');
                    done_wr_next <= '0';
                    count_next <= 0;
                ELSE
                    next_state <= DONE;
                    wr_en_out_next <= '0';
                    done_wr_next <= '1';
                    count_next <= count + 1;
                END IF;

            WHEN OTHERS =>
                next_state <= IDLE_O;

        END CASE;
    END PROCESS;

    data_out <= data_out_reg;
    wr_en_out <= wr_en_out_reg;
    done_wr <= done_wr_reg;

END rtl;
