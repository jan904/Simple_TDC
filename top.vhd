LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY top is
    GENERIC (
        carry4_count : INTEGER := 32;
        n_output_bits : INTEGER := 8
    );
    PORT (
        clk : IN STD_LOGIC;
        signal_in_1 : IN STD_LOGIC;
        signal_in_2 : IN STD_LOGIC;
        diff_out : OUT STD_LOGIC_VECTOR(n_output_bits - 1 DOWNTO 0);
        serial_out : OUT STD_LOGIC
    );
END ENTITY top;


ARCHITECTURE rtl of top IS

    SIGNAL starting : STD_LOGIC;

    SIGNAL wr_en_1 : STD_LOGIC;
    SIGNAL wr_en_2 : STD_LOGIC;
    SIGNAL wr_diff : STD_LOGIC;

    SIGNAL signal_out_1 : STD_LOGIC_VECTOR(n_output_bits - 1 DOWNTO 0);
    SIGNAL signal_out_2 : STD_LOGIC_VECTOR(n_output_bits - 1 DOWNTO 0);

    SIGNAL finished : STD_LOGIC;

    SIGNAL bin_output : STD_LOGIC_VECTOR(n_output_bits - 1 DOWNTO 0); 

    COMPONENT channel IS
        GENERIC (
            carry4_count : INTEGER := 32;
            n_output_bits : INTEGER := 8
        );
        PORT (
            clk : IN STD_LOGIC;
            signal_in : IN STD_LOGIC;
            starting : IN STD_LOGIC;
            both_finished : IN STD_LOGIC;
            wr_en : OUT STD_LOGIC;
            signal_out : OUT STD_LOGIC_VECTOR(n_output_bits - 1 DOWNTO 0)
        );
    END COMPONENT channel;

    COMPONENT uart IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        we : IN STD_LOGIC;
        din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        tx : OUT STD_LOGIC
    );
    END COMPONENT uart;

    COMPONENT handle_start IS
    PORT (
        clk : IN STD_LOGIC;
        starting : OUT STD_LOGIC
    );
    END COMPONENT handle_start;

    COMPONENT manage_write IS
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
    END COMPONENT manage_write;

BEGIN

    handle_start_inst : handle_start
    PORT MAP (
        clk => clk,
        starting => starting
    );

    channel_1_inst : channel
    GENERIC MAP (
        carry4_count => carry4_count,
        n_output_bits => n_output_bits
    )
    PORT MAP (
        clk => clk,
        signal_in => signal_in_1,
        starting => starting,
        both_finished => finished,
        wr_en => wr_en_1,
        signal_out => signal_out_1
    );

    channel_2_inst : channel
    GENERIC MAP (
        carry4_count => carry4_count,
        n_output_bits => n_output_bits
    )
    PORT MAP (
        clk => clk,
        signal_in => signal_in_2,
        starting => starting,
        both_finished => finished,
        wr_en => wr_en_2,
        signal_out => signal_out_2
    );

    manage_write_inst : manage_write
    GENERIC MAP (
        n_output_bits => n_output_bits
    )
    PORT MAP (
        clk => clk,
        starting => starting,
        signal_1 => signal_in_1,
        signal_2 => signal_in_2,
        signal_out_1 => signal_out_1,
        signal_out_2 => signal_out_2,
        wr_1 => wr_en_1,
        wr_2 => wr_en_2,
        wr => wr_diff,
        finished => finished,
        output => bin_output
    );

    uart_inst : uart
    PORT MAP (
        clk => clk,
        rst => starting,
        we => wr_diff,
        din => bin_output,
        tx => serial_out
    );

    diff_out <= bin_output;

END ARCHITECTURE rtl;