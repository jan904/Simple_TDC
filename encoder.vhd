-- Thermometer to binary encoder
--
-- Inputs:
--   thermometer: Thermometer code to be encoded
--   clk : Clock signal
--
-- Outputs:
--   count_bin: Binary encoded thermometer code   

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY encoder IS
    GENERIC (
        n_bits_bin : POSITIVE;
        n_bits_therm : POSITIVE
    );
    PORT (
        clk : IN STD_LOGIC;
        thermometer : IN STD_LOGIC_VECTOR((n_bits_therm - 1) DOWNTO 0);
        count_bin : OUT STD_LOGIC_VECTOR((n_bits_bin - 1) DOWNTO 0)
    );
END ENTITY encoder;


--ARCHITECTURE rtl OF encoder IS
--BEGIN

    --PROCESS (clk)
        -- Variable to store the count
    --    VARIABLE count : unsigned(n_bits_bin - 1 DOWNTO 0); --:= (OTHERS => '0');
    --BEGIN
        -- Simply loop over the thermometer code and count the number of '1's
    --    IF rising_edge(clk) THEN
            -- Reset the count after each clock cycle
    --        count := (OTHERS => '0');
    --        FOR i IN 0 TO n_bits_therm - 1 LOOP
    --            IF thermometer(i) = '1' THEN
    --                count := count + 1;
    --            END IF;
    --        END LOOP;
            -- Assign the count to the output
    --        count_bin <= STD_LOGIC_VECTOR(count);
    --    END IF;
    --END PROCESS;

--END ARCHITECTURE rtl;


ARCHITECTURE staged OF encoder IS

    SIGNAL signal_1_1 : STD_LOGIC_VECTOR(n_bits_therm/4 - 1 DOWNTO 0);
    SIGNAL signal_1_2 : STD_LOGIC_VECTOR(n_bits_therm/4 - 1 DOWNTO 0);
    SIGNAL signal_1_3 : STD_LOGIC_VECTOR(n_bits_therm/4 - 1 DOWNTO 0);
    SIGNAL signal_1_4 : STD_LOGIC_VECTOR(n_bits_therm/4 - 1 DOWNTO 0);

    type stage_array_0 is array (0 to 3) of STD_LOGIC_VECTOR(n_bits_therm/4 - 1 DOWNTO 0);
    signal stage_0 : stage_array_0;

    type stage_array_1 is array (0 to 3) of unsigned(n_bits_bin - 1 DOWNTO 0);
    signal sum_1 : stage_array_1;

    type stage_array_2 is array (0 to 1) of unsigned(n_bits_bin - 1 DOWNTO 0);
    signal sum_2 : stage_array_2;

BEGIN

    signal_1_1 <= thermometer(71 DOWNTO 0);
    signal_1_2 <= thermometer(143 DOWNTO 72);
    signal_1_3 <= thermometer(215 DOWNTO 144);
    signal_1_4 <= thermometer(287 DOWNTO 216);
    stage_0 <= (signal_1_1, signal_1_2, signal_1_3, signal_1_4);


    first_stage : FOR i IN 0 TO 3 GENERATE

        PROCESS (clk)
            VARIABLE count : unsigned(n_bits_bin - 1 DOWNTO 0);
        BEGIN
            
            IF rising_edge(clk) THEN
                count := (OTHERS => '0');
                FOR j IN 0 TO 71 LOOP
                    IF stage_0(i)(j) = '1' THEN
                        count := count + 1;
                    END IF;
                END LOOP;
                sum_1(i) <= count;
            END IF;
        END PROCESS;
    END GENERATE;

    second_stage : FOR i IN 0 TO 1 GENERATE
        PROCESS (clk)
        BEGIN
            IF rising_edge(clk) THEN
                sum_2(i) <= sum_1(i * 2) + sum_1(i * 2 + 1);
            END IF;
        END PROCESS;
    END GENERATE;

    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            count_bin <= STD_LOGIC_VECTOR(sum_2(0) + sum_2(1));
        END IF;

    END PROCESS;

END ARCHITECTURE staged;