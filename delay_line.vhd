library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity delay_line is
    generic (
        stages : integer
    );
    port (
        trigger : in std_logic;
        clock : in std_logic;
        output : out std_logic_vector(stages-1 downto 0)
    );
end delay_line;


architecture rtl of delay_line is

    signal unreg : std_logic_vector(stages-1 downto 0);
    signal Cin : std_logic := '0';

    component carry4
        port (
            a, b : in std_logic_vector(3 downto 0);
            Cin : in std_logic;
            trigger : in std_logic;
            Cout_vector : out std_logic_vector(3 downto 0)
        );
    end component;

    component fdr
        port (
            clk: in std_logic;
            t: in std_logic;
            q: out std_logic
        );
    end component;

begin
    carry_delay_line: for i in 0 to stages/4 - 1 generate
        first_carry4: if i = 0 generate
        begin
            delayblock: carry4
                port map (
                    trigger => trigger,
                    a => "0000",
                    b => "1111",
                    Cin => '0',
                    Cout_vector => unreg(3 downto 0)
                );
        end generate first_carry4;

        next_carry4: if i > 0 generate
        begin
            delayblock: carry4
                port map (
                    trigger => '0',
                    a => "0000",
                    b => "1111",
                    Cin => unreg((4*i)-1),
                    Cout_vector => unreg((4*(i+1))-1 downto (4*i))
                );
        end generate next_carry4;
    end generate;

    latch: for i in 0 to stages-1 generate
    begin
        ff: fdr
            port map (
                clk => clock,
                t => unreg(i),
                q => output(i)
            );
    end generate latch;
    
end architecture rtl;
      