LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY U_D_Bin_Counter8bit IS PORT (
  CLK : IN STD_LOGIC := '0';
  RESET_n : IN STD_LOGIC := '0';
  CLK_EN : IN STD_LOGIC := '0';
  UP1_DOWN0 : IN STD_LOGIC := '0';
  COUNTER_BITS : IN STD_LOGIC_VECTOR(3 DOWNTO 0)
);
END ENTITY;

ARCHITECTURE one OF U_D_Bin_Counter8bit IS
  SIGNAL ud_bin_counter : UNSIGNED(3 DOWNTO 0);

BEGIN
  PROCESS (CLK, RESET_n) IS
  BEGIN
    IF (RESET_n = '0') THEN
      ud_bin_counter <= '0000';
    ELSIF (rising_edge(CLK)) THEN
      IF ((UP1_DOWN0 = '1') AND (CLK_EN = '1')) THEN
        ud_bin_counter <= (ud_bin_counter + 1);
      ELSIF ((UP1_DOWN0 = '0') AND (CLK_EN = '1')) THEN
        ud_bin_counter <= (ud_bin_counter - 1);
      END IF;
    END IF;
  END PROCESS;

  COUNTER_BITS <= STD_LOGIC_VECTOR(ud_bin_counter);

END;