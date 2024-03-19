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

    signal a_reset : std_logic;
    signal busy : std_logic;
    signal n_ones: std_logic_vector(carry4_count*4-1 downto 0);
    signal detect_edge : std_logic_vector(carry4_count*4-1 downto 0);
    signal bin_output : std_logic_vector(n_output_bits-1 downto 0);

    component delay_line is
        generic (
            stages : positive
        );
        port (
            reset : in std_logic;
            trigger : in std_logic;
            clock : in std_logic;
            signal_running : in std_logic;
            intermediate_signal : out std_logic_vector(stages-1 downto 0);
            therm_code : out std_logic_vector(stages-1 downto 0)
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

    component detect_signal is
        generic (
            stages : positive;
            n_output_bits : positive
        );
        port (
            clock : in std_logic;
            signal_in : in std_logic;
            interm_latch : in std_logic_vector(stages-1 downto 0);
            signal_out : in std_logic_vector(n_output_bits-1 downto 0);
            signal_running : out std_logic;
            reset : out std_logic
        );
    end component detect_signal;

begin

    delay_line_inst : delay_line
        generic map (
            stages => carry4_count*4
        )
        port map (
            reset => a_reset,
            signal_running => busy,
            trigger => signal_in,
            clock => clk,
            intermediate_signal => detect_edge,
            therm_code => n_ones
        );


    detect_signal_inst : detect_signal
        generic map (
            stages => carry4_count*4,
            n_output_bits => n_output_bits
        )
        port map (
            clock => clk,
            signal_in => signal_in,
            interm_latch => detect_edge,
            signal_out => bin_output,
            signal_running => busy,
            reset => a_reset
        );

    encoder_inst : encoder
        generic map (
            n_bits_bin => n_output_bits,
            n_bits_therm => 4*carry4_count 
        )
        port map (
            clk => clk,
            thermometer => n_ones,
            count_o => bin_output
        );
        signal_out <= bin_output;
end architecture rtl;

