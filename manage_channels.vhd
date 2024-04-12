LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY manage_channels IS
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
END ENTITY manage_channels;
        

ARCHITECTURE rtl OF manage_channels IS

    SIGNAL signal_out_vector : STD_LOGIC_VECTOR(n_output_bits - 1 DOWNTO 0);
    SIGNAL wr_en : STD_LOGIC;
    SIGNAL reset_after_start : STD_LOGIC;

    COMPONENT channel IS
        GENERIC (
            carry4_count : INTEGER := 32;
            n_output_bits : INTEGER := 8
        );
        PORT (
            clk : IN STD_LOGIC;
            signal_in : IN STD_LOGIC;
            reset_after_start_out : OUT STD_LOGIC;
            wr_en_out : OUT STD_LOGIC;
            signal_out : OUT STD_LOGIC_VECTOR(n_output_bits - 1 DOWNTO 0);
            serial_out : OUT STD_LOGIC
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


BEGIN

    -- instantiate 2 channels
    channel_1_inst : channel
    PORT MAP(
        clk => clk,
        signal_in => signal_in_1,
        reset_after_start_out => reset_after_start,
        wr_en_out => wr_en,
        signal_out => signal_out_vector(7 DOWNTO 0),
        serial_out => serial_out
    );

    diff_out <= signal_out_vector(7 DOWNTO 0);

END ARCHITECTURE rtl;