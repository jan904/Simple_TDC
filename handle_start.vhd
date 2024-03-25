LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY handle_start IS
    PORT (
        clk : IN STD_LOGIC;
        starting : OUT STD_LOGIC
    );
END ENTITY handle_start;

ARCHITECTURE fsm_arch OF handle_start IS
    TYPE state_type IS (reset_state, running_state);
    SIGNAL current_state, next_state : state_type;

    SIGNAL starting_reg : STD_LOGIC;

BEGIN
    PROCESS(clk)
    BEGIN
        IF rising_edge(clk) THEN
            current_state <= next_state;
            starting <= starting_reg;
        END IF;
    END PROCESS;

    PROCESS (next_state, starting_reg, current_state)
    BEGIN
        CASE current_state IS
            WHEN reset_state =>
                starting_reg <= '1';
                next_state <= running_state;
            WHEN running_state =>
                starting_reg <= '0';
                next_state <= running_state;
            WHEN OTHERS =>
                next_state <= reset_state;
        END CASE;
    END PROCESS;
END ARCHITECTURE fsm_arch;