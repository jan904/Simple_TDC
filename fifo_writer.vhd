-- write data from 4 channels into fifo

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY fifo_writer IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        ch_valid : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        ch_data : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
        fifo_full : IN STD_LOGIC;
        fifo_wr : OUT STD_LOGIC;
        fifo_data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END ENTITY fifo_writer;

ARCHITECTURE rtl OF fifo_writer IS

    TYPE state_type IS (IDLE, WRITE_FIRST_BYTE, WRITE_SECOND_BYTE);
    SIGNAL state, next_state : state_type;

    SIGNAL channel_next, channel_reg : INTEGER range 0 to 3;
    SIGNAL data_next, data_reg : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL wr_next, wr_reg : STD_LOGIC;

BEGIN

    PROCESS(clk, reset)
    BEGIN
        IF reset = '1' THEN
            state <= IDLE;
            channel_reg <= 0;
            data_reg <= (OTHERS => '0');
            wr_reg <= '0';
        ELSIF rising_edge(clk) THEN
            state <= next_state;
            channel_reg <= channel_next;
            data_reg <= data_next;
            wr_reg <= wr_next;
        END IF;
    END PROCESS;

    PROCESS(state, ch_valid, ch_data, fifo_full, channel_reg, data_reg, wr_reg)
    BEGIN

        next_state <= state;
        channel_next <= channel_reg;
        data_next <= data_reg;
        wr_next <= wr_reg;

        CASE state IS
            WHEN IDLE =>
                IF fifo_full = '0' THEN
                    IF ch_valid(channel_reg) = '1' THEN
                        next_state <= WRITE_FIRST_BYTE;
                        data_next <= ch_data(7 * channel_reg + 7 DOWNTO 7 * channel_reg);
                    ELSE
                        channel_next <= channel_reg + 1;
                    END IF;
                END IF;