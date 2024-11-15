LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY top IS
    GENERIC (
        carry4_count : INTEGER := 72;
        n_output_bits : INTEGER := 9;
        coarse_bits : INTEGER := 8
    );
    PORT (
        clk : IN STD_LOGIC;
        signal_in : IN STD_LOGIC;
        signal_out : OUT STD_LOGIC_VECTOR(n_output_bits - 1 DOWNTO 0);
        serial_out : OUT STD_LOGIC;
        serial_out_2 : OUT STD_LOGIC;
        serial_out_3 : OUT STD_LOGIC;
        serial_out_4 : OUT STD_LOGIC
    );
END ENTITY top;

ARCHITECTURE rtl of top IS

    COMPONENT channel IS
        GENERIC (
            carry4_count : INTEGER := 72;
            n_output_bits : INTEGER := 9
        );
        PORT (
            clk : IN STD_LOGIC;
            signal_in : IN STD_LOGIC;
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

BEGIN

    channel_inst_1 : channel
    GENERIC MAP (
        carry4_count => carry4_count,
        n_output_bits => n_output_bits
    )
    PORT MAP (
        clk => clk,
        signal_in => signal_in,
        signal_out => signal_out,
        serial_out => serial_out
    );

    channel_inst_2 : channel
    GENERIC MAP (
        carry4_count => carry4_count,
        n_output_bits => n_output_bits
    )
    PORT MAP (
        clk => clk,
        signal_in => signal_in,
        signal_out => open,
        serial_out => serial_out_2
    );

    channel_inst_3 : channel
    GENERIC MAP (
        carry4_count => carry4_count,
        n_output_bits => n_output_bits
    )
    PORT MAP (
        clk => clk,
        signal_in => signal_in,
        signal_out => open,
        serial_out => serial_out_3
    );

    channel_inst_4 : channel
    GENERIC MAP (
        carry4_count => carry4_count,
        n_output_bits => n_output_bits
    )
    PORT MAP (
        clk => clk,
        signal_in => signal_in,
        signal_out => open,
        serial_out => serial_out_4
    );

END rtl;