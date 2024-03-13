library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity channel is
    generic (
        carry4_count : integer := 8
    );
    port (
        clk : in std_logic;
        signal_in : in std_logic;
        signal_out : out std_logic(carry4_count*4-1 downto 0)
    );
end entity channel;


architecture rtl of channel is

    component delay_line is
        generic (
            stages : integer
        );
        port (
            trigger : in std_logic;
            clock : in std_logic;
            output : out std_logic_vector(stages-1 downto 0)
        );
    end component delay_line;

    component encoder is
        generic (
            g_N : positive := 4;
            g_NIN : positive := 15
        );
        port (
            clk : in std_logic;
            thermometer : in std_logic_vector((g_NIN-1) downto 0);
            count_o : out std_logic_vector(g_N-1 downto 0) 
        );
    end component encoder;

begin

    signal n_ones: std_logic_vector(carry4_count*4-1 downto 0);

    delay_line_inst : delay_line
        generic map (
            stages => carry4_count*4
        )
        port map (
            trigger => signal_in,
            clock => clk,
            output => n_ones
        );

    encoder_inst : encoder
        generic map (
            g_N => carry4_count,
            g_NIN => carry4_count*4
        )
        port map (
            clk => clk,
            thermometer => n_ones,
            count_o => signal_out
        );

end architecture rtl;

