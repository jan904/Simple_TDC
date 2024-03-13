library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity channel is
    generic (
        carry4_count : integer := 4;
        n_output_bits : integer := 8
    );
    port (
        clk : in std_logic;
        signal_in : in std_logic;
        signal_out : out std_logic_vector(n_output_bits-1 downto 0)
    );
end entity channel;


architecture rtl of channel is

    signal n_ones: std_logic_vector(carry4_count*4-1 downto 0);

    component delay_line is
        generic (
            stages : positive
        );
        port (
            trigger : in std_logic;
            clock : in std_logic;
            output : out std_logic_vector(stages-1 downto 0)
        );
    end component delay_line;

    component encoder is
        generic (
            n_bits_bin : positive;
            n_bits_therm : positive
        );

        port (
            clk : in std_logic;
            thermometer : in std_logic_vector((n_bits_therm-1) downto 0);
            count_o : out std_logic_vector(n_bits_bin-1 downto 0) 
        );
    end component encoder;

begin

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
            n_bits_bin => n_output_bits,
            n_bits_therm => 4*carry4_count 
        )
        port map (
            clk => clk,
            thermometer => n_ones,
            count_o => signal_out
        );

end architecture rtl;

