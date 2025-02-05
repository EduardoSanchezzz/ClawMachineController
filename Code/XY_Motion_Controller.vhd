LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY XY_Motion Controller IS PORT (
  CLK : IN STD_LOGIC := '0';
  RESET_n : IN STD_LOGIC := '0';
  X_Target_Input : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
  Y_Target_Input : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
  MOTION : IN STD_LOGIC := '0';
  XTARGET_GT, X_EQ, X_LT : IN STD_LOGIC := '0';
  YTARGET_GT, Y_EQ, Y_LT : IN STD_LOGIC : '0';
  EXTENDER_OUT : IN STD_LOGIC := '0';
  X_Up_Down, Y_Up_Down : OUT STD_LOGIC := '0';
  X_CLK_EN, Y_CLK_EN : OUT STD_LOGIC := '0';
  X_Target_Output : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
  Y_Target_Output : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
  EXTENDER_EN : OUT STD_LOGIC := '0';
  SYSTEM_FAULT_LED : OUT STD_LOGIC := '0';
);
END ENTITY;

ARCHITECTURE logic OF XY_Motion_Controller IS
  TYPE STATE_NAMES IS (NO_MVMT, COPY_TARGET, XY_MVMT, X_MVMT, Y_MVMT);
  SIGNAL current_state, next_state : STATE_NAMES;
BEGIN
  --State Machine:

  -- REGISTER LOGIC PROCESS:
  Register_Section : PROCESS (CLK, RESET_n)
  BEGIN
    IF (RESET_n = '0') THEN
      current_state <= NO_MVMT;
    ELSIF (rising_edge(CLK)) THEN
      current_state <= next_state;
    END IF;
  END PROCESS;
  --TRANSITION LOGIC PROCESS
  Transition_Section : PROCESS (current_state, MOTION, X_EQ, Y_EQ)
  BEGIN
    CASE current_state IS
      WHEN NO_MVMT =>
        IF (MOTION = '1') THEN
          next_state <= COPY_TARGET;
        ELSE
          next_state <= NO_MVMT;
        END IF;
      WHEN COPY_TARGET =>
        IF (MOTION = '0') THEN
          next_state <= XY_MVMT;
        ELSE
          next_state <= COPY_TARGET;
        END IF;
      WHEN XY_MVMT =>
        IF ((X_EQ = '1') AND (Y_EQ = '1')) THEN
          next_state <= NO_MVMT;
        ELSIF (X_EQ = '1') THEN
          next_state <= Y_MVMT;
        ELSIF (Y_EQ = '1') THEN
          next_state <= X_MVMT;
        ELSE
          next_state <= XY_MVMT;
        END IF;
      WHEN X_MVMT =>
        IF (X_EQ = '1') THEN
          next_state <= NO_MVMT;
        ELSE
          next_state <= X_MVMT;
        END IF;
      WHEN Y_MVMT =>
        IF (Y_EQ = '1') THEN
          next_state <= NO_MVMT;
        ELSE
          next_state <= Y_MVMT;
        END IF;

      WHEN OTHERS =>
        next_state <= NO_MVMT;
    END CASE;
  END PROCESS;

  -- DECODER SECTION PROCESS (MEALY Form)
  Decoder_Section : PROCESS (current_state, X_Target_Input, Y_Target_Input, XTARGET_GT, YTARGET_GT, EXTENDER_OUT, X_EQ, Y_EQ, MOTION)
    --variable for current targets
    VARIABLE current_xtarget : STD_LOGIC_VECTOR(3 DOWNTO 0);
    VARIABLE current_ytarget : STD_LOGIC_VECTOR(3 DOWNTO 0);
  BEGIN
    --ASSIGN TARGET INPUT TO VARIABLE IF EXTENDER IS NOT MOVING
    IF (current_state = COPY_TARGET) THEN
      current_xtarget := X_Target_Input;
      current_ytarget := Y_Target_Input;
      EXTENDER_EN <= '1';
    ELSE
      current_xtarget := current_xtarget;
      current_ytarget := current_ytarget;
      EXTENDER_EN <= '0';
    END IF;
    --EXTENDER ENABLED ONLY WHEN THERE IS NO MOVEMENT 
    IF (current_state = NO_MVMT) THEN
      EXTENDER_EN <= '1';
    ELSE
      EXTENDER_EN <= '0';
    END IF;
    --X CLOCK ENABLE OUTPUT
    IF ((current_state = XY_MVMT) OR (current_state = X_MVMT)) THEN
      X_CLK_EN <= NOT (EXTENDER_OUT OR X_EQ);

    ELSE
      X_CLK_EN <= '0';
    END IF;
    --Y CLOCK ENABLE OUTPUT
    IF ((current_state = XY_MVMT) OR (current_state = Y_MVMT)) THEN
      Y_CLK_EN <= NOT (EXTENDER_OUT OR Y_EQ);
    ELSE
      Y_CLK_EN <= '0';
    END IF;
    --SYSTEM FAULT ERROR OUTPUT
    IF ((EXTENDER_OUT = '1') AND (MOTION = '1')) THEN
      SYSTEM_FAULT_LED <= '1';
    ELSE
      SYSTEM_FAULT_LED <= '0';
    END IF;

    X_Up_Down <= XTARGET_GT;
    Y_Up_Down <= YTARGET_GT;
    X_Target_Output <= current_xtarget;
    Y_Target_Output <= current_ytarget;
  END PROCESS;
END ARCHITECTURE logic;