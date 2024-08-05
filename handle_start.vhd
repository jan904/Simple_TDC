-- Handle start after starting the fpga
--
-- This module is used to send a signal for one clock cycle after the FPGA has
-- been started. This signal is used to initialize several modules.
-- Implemented using a state machine with two states: reset_state and
-- running_state. 
--
-- Inputs:
--   clk: clock signal
--
-- Outputs:
--   starting: signal that is high for one clock cycle after the FPGA has been started
 
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY handle_start IS
    PORT (
        clk : IN STD_LOGIC;
        starting : OUT STD_LOGIC
    );
END ENTITY handle_start;


ARCHITECTURE fsm_arch OF handle_start IS

    -- Define the states of the state machine
    TYPE state_type IS (reset_state, running_state);
    SIGNAL current_state, next_state : state_type;

    -- Output signal updated by the state machine
    SIGNAL starting_reg : STD_LOGIC;

    SIGNAL reset_counter, reset_counter_next : INTEGER RANGE 0 TO 50000;

BEGIN

    -- fsm core
    PROCESS(clk)
    BEGIN
        IF rising_edge(clk) THEN
            current_state <= next_state;
            starting <= starting_reg;
            reset_counter <= reset_counter_next;
        END IF;
    END PROCESS;

    -- fsm logic
    PROCESS (starting_reg, current_state, reset_counter)
    BEGIN

        reset_counter_next <= reset_counter;

        -- Go to reset_state after starting. Stay in reset_state for one cycle
        -- and send starting signal. Then go to running_state and stay there sending no signal.s
        CASE current_state IS
            WHEN reset_state =>
                starting_reg <= '1';
                reset_counter_next <= 0;
                next_state <= running_state;
            WHEN running_state =>
                IF reset_counter = 50000 THEN
                    starting_reg <= '0';
                    next_state <= reset_state;
                ELSE
                    reset_counter_next <= reset_counter + 1;
                    starting_reg <= '0';
                    next_state <= running_state;
                END IF;
            WHEN OTHERS =>
                next_state <= reset_state;
        END CASE;
    END PROCESS;
END ARCHITECTURE fsm_arch;