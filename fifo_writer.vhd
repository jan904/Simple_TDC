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
        written_channels : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        fifo_data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END ENTITY fifo_writer;

ARCHITECTURE rtl OF fifo_writer IS

    TYPE state_type IS (IDLE, WRITE_FIRST_BYTE, WRITE_SECOND_BYTE);
    SIGNAL state, next_state : state_type;

    SIGNAL channel_next, channel_reg : INTEGER range 0 to 3;
    SIGNAL data_next, data_reg : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL fifo_data_reg, fifo_data_next : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL wr_next, wr_reg : STD_LOGIC;

    SIGNAL written_channels_next, written_channels_reg : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN

    PROCESS(clk, reset)
    BEGIN
        IF reset = '1' THEN
            state <= IDLE;
            channel_reg <= 0;
            data_reg <= (OTHERS => '0');
            wr_reg <= '0';
            fifo_data_reg <= (OTHERS => '0');
            written_channels_reg <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            state <= next_state;
            channel_reg <= channel_next;
            data_reg <= data_next;
            wr_reg <= wr_next;
            fifo_data_reg <= fifo_data_next;
            written_channels_reg <= written_channels_next;
        END IF;
    END PROCESS;

    PROCESS(state, ch_valid, ch_data, fifo_full, channel_reg, data_reg, wr_reg, fifo_data_reg, written_channels_reg)
    BEGIN

        next_state <= state;
        channel_next <= channel_reg;
        data_next <= data_reg;
        wr_next <= wr_reg;
        fifo_data_next <= fifo_data_reg;
        written_channels_next <= written_channels_reg;

        CASE state IS
            WHEN IDLE =>
                wr_next <= '0';
                written_channels_next <= "0000";
                IF fifo_full = '0' THEN
                    IF ch_valid(channel_reg) = '1' THEN
                        next_state <= WRITE_FIRST_BYTE;
                        data_next <= ch_data((16 * channel_reg) + 15 DOWNTO 16 * channel_reg);
                    ELSE
                        channel_next <= (channel_reg + 1) mod 4;
                    END IF;
                ELSE
                    next_state <= IDLE;
                END IF;

            WHEN WRITE_FIRST_BYTE =>
                IF fifo_full = '0' THEN
                    fifo_data_next <= data_reg(15 DOWNTO 8);
                    written_channels_next(channel_reg) <= '1';
                    wr_next <= '1';
                    next_state <= WRITE_SECOND_BYTE;
                ELSE
                    next_state <= WRITE_FIRST_BYTE;
                END IF;

            WHEN WRITE_SECOND_BYTE =>
                IF fifo_full = '0' THEN
                    fifo_data_next <= data_reg(7 DOWNTO 0);
                    wr_next <= '1';
                    channel_next <= (channel_reg + 1) mod 4;
                    next_state <= IDLE;
                ELSE
                    next_state <= WRITE_SECOND_BYTE;
                END IF;

            WHEN OTHERS =>
                next_state <= IDLE;

        END CASE;

    END PROCESS;

    fifo_wr <= wr_reg;
    fifo_data <= fifo_data_reg;
    written_channels <= written_channels_reg;

END ARCHITECTURE rtl;