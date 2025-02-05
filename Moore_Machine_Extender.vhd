LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Moore_Machine_Extender IS PORT (
  clk_input, rst_n, ext_en, ext_pb : IN STD_LOGIC;
  leds : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
  ext_out, grapp_en, bidir_en, bidir_LR : OUT;
);
END ENTITY;

ARCHITECTURE SM OF Moore_Machine_Extender IS
  TYPE STATE_NAMES IS (retracted, extending, fully_ext, retracting, pb_PRESSED);

  SIGNAL current state, next_state : STATE_NAMES;

BEGIN
  --State Machine:

  -- REGISTER LOGIC PROCESS:
  Register_Section : PROCESS (clk_input, rst_n)
  BEGIN
    IF (rst_n = '0') THEN
      current state <= retracted;
    ELSIF (rising_edge(clk_input)) THEN
      current state <= next_state;
    END IF;
  END PROCESS;

  -- TRANSITION LOGIC PROCESS

  Transition_Section : PROCESS (ext_pb, ext_en, current_state, leds)
  BEGIN
    CASE current_state IS
      WHEN retracted =>
        IF ((ext_en = 1') AND (ext_pb = '1')) THEN
          next_state <= pb_PRESSED;
        ELSE
          next_state <= retracted;
        END IF;
      WHEN extending =>
        IF (ext_en = '1') AND (leds = '1110') THEN
          next_state <= fully_ext;
        ELSE
          next_state <= extending;
        END IF;
      WHEN fully ext => .
        IF (ext_pb = '1') THEN
          next_state <= pb_PRESSED;
        ELSE
          next_state <= fully_ext;
        END IF;
      WHEN retracting =>
        IF (ext_en = '1') AND (leds = "1000") THEN
          next_state <= retracted;
        ELSE
          next_state <= retracting;
        END IF;
      WHEN pb_PRESSED =>
        IF ((ext_pb = '0') AND (leds = "0000") AND (ext_en = '1')) THEN
          NEXT state <= extending;
        ELSIF ((ext_pb = '0') AND (leds = "1111")) THEN
          next_state <= retracting;
        ELSE
          next_state <= pb_PRESSED;
        END IF;
      WHEN OTHERS =>
        next_state <= retracted;
    END CASE;
  END PROCESS;
  -- DECODER SECTION PROCESS (Moore Form) 
  Decoder_Section : PROCESS (current_state)
  BEGIN
    CASE current_state IS
      WHEN retracted =>
        ext_out <= '0';
        grapp_en <= '0';
        bidir_en <= '0';
        bidir_LR <= '0';
      WHEN extending =>
        ext_out <= '1';
        grapp_en <= '0';
        bidir_en <= '1';
        bidir_LR <= '1';

      WHEN fully_ext =>
        ext_out <= '1';
        grapp_en <= '1';
        bidir_en <= '0';
        bidir_LR <= '0';
      WHEN retracting =>
        ext_out <= '1';
        grapp_en <= '0';
        bidir_en <= '1';
        bidir_LR <= '0';

      WHEN pb_PRESSED =>
        ext_out <= '1';
        grapp_en <= '0';
        bidir_en <= '0';
        bidir_LR <= '0';
      WHEN OTHERS =>
        ext_out <= '0';
        grapp_en <= '0';
        bidir_en <= '0';
        bidir_LR <= '0';
    END CASE;
  END PROCESS;
END ARCHITECTURE SM;