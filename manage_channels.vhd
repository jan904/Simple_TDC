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

    SIGNAL signal_in : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL signal_out_vector : STD_LOGIC_VECTOR(2*(n_output_bits) -1 DOWNTO 0);
    SIGNAL diff : UNSIGNED(n_output_bits - 1 DOWNTO 0) ;
    SIGNAL signal_out_1 : UNSIGNED(n_output_bits - 1 DOWNTO 0);
    SIGNAL signal_out_2 : UNSIGNED(n_output_bits - 1 DOWNTO 0); 
    SIGNAL diff_logic : STD_LOGIC_VECTOR(n_output_bits - 1 DOWNTO 0);

    SIGNAL reset_after_start : STD_LOGIC;
    SIGNAL wr_en_reg : STD_LOGIC_VECTOR(1 DOWNTO 0);

    COMPONENT channel IS
        GENERIC (
            carry4_count : INTEGER := 32;
            n_output_bits : INTEGER := 8
        );
        PORT (
            clk : IN STD_LOGIC;
            signal_in : IN STD_LOGIC;
            starting : IN STD_LOGIC;
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


BEGIN

    signal_in(0) <= signal_in_1;
    signal_in(1) <= signal_in_2;

    -- send reset signal after start to all components
    handle_start_inst : handle_start
    PORT MAP(
        clk => clk,
        starting => reset_after_start
    );

    -- instantiate 2 channels
    channels : FOR i IN 0 TO 1 GENERATE
    BEGIN
        channel_inst : channel
        PORT MAP(
            clk => clk,
            signal_in => signal_in(i),
            starting => reset_after_start,
            wr_en => wr_en_reg(i),
            signal_out => signal_out_vector((8 * (i+1)) - 1 DOWNTO (8 * i) )
        );
    END GENERATE channels;

    -- calculate difference between 2 signals
    signal_out_1 <= unsigned(signal_out_vector(7 DOWNTO 0));
    signal_out_2 <= unsigned(signal_out_vector(15 DOWNTO 8));
    diff <= signal_out_1 - signal_out_2;
    diff_logic <= std_logic_vector(diff);

    -- send binary output to UART
    uart_inst : uart
    PORT MAP(
        clk => clk,
        rst => reset_after_start,
        we => wr_en_reg(1),
        din => diff_logic,
        tx => serial_out
    );

    diff_out <= diff_logic;

END ARCHITECTURE rtl;