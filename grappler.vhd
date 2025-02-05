LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY grappler IS PORT (
  CLK : IN STD_LOGIC := '0';
  RESET_n : IN STD_LOGIC := '0';
  grap_en, grap_pb : IN STD_LOGIC;
  grap_out : OUT STD_LOGIC
);
END ENTITY;

ARCHITECTURE grappler_logic OF grappler IS
  TYPE STATE_NAMES IS (grap_closed, pb_closed, grap_open, pb_open);

  SIGNAL current_state, next_state : STATE_NAMES;

BEGIN
  Register_Section : PROCESS (CLK, RESET_n) BEGIN
    IF (RESET_n = '0') THEN
      current state <= grap_closed;
    ELSIF (rising_edge(CLK)) THEN
      current state <= next_state;
    END IF;
  END PROCESS;

  -- TRANSITION LOGIC PROCESS
  Transition_Section : PROCESS (grap_en, grap_pb, current_state)
  BEGIN
    CASE current_state IS
      WHEN grap_closed =>
        IF ((grap_pb = '1') AND (grap_en = '1')) THEN
          next_state <= pb_closed;
        ELSE
          next_state <= grap_closed;
        END IF;
      WHEN pb_closed =>
        IF ((grap_pb = '0') AND (grap_en = '1')) THEN
          next_state <= grap_open;
        ELSE
          next_state <= pb_closed;
        END IF;
      WHEN grap_open =>
        IF ((grap_pb = '1') AND (grap_en = '1')) THEN
          next_state <= pb_open;
        ELSE
          next_state <= grap_open;
        END IF;

      WHEN pb_open =>
        IF ((grap_pb = '0') AND (grap_en = '1')) THEN
          next_state <= grap_closed;
        ELSE
          next_state <= pb_open;
        END IF;
      WHEN OTHERS =>
        next_state <= grap_closed;
    END CASE;
  END PROCESS;

  -- DECODER SECTION PROCESS (Moore Form) 
  Decoder_Section : PROCESS (current_state)
  BEGIN
    CASE current_state IS
      WHEN grap_closed =>
        grap_out <= '0';
      WHEN pb_closed =>
        grap_out <= '0';
      WHEN grap_open =>
        grap_out <= '1';
      WHEN pb_open =>
        grap_out <= '1';
      WHEN OTHERS =>
        grap_out <= '0';
    END CASE;
  END PROCESS;
END grappler_logic;