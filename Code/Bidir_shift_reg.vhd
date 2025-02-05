LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Bidir_shift_reg IS PORT (
  CLK : IN STD_LOGIC := '0';
  RESET_n : IN STD_LOGIC := '0';
  CLK_EN : IN STD_LOGIC := '0';
  LEFT0_RIGHT1 : IN STD_LOGIC := '0';
  REG_BITS : IN STD_LOGIC_VECTOR(3 DOWNTO 0)
);
END ENTITY;

ARCHITECTURE one OF Bidir_shift_reg IS
  SIGNAL sreg : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN
  PROCESS (CLK, RESET_n) IS
  BEGIN
    IF (RESET_n = '0') THEN
      sreg <= '0000';
    ELSIF (rising_edge(CLK) AND (CLK_EN = '1')) THEN
      IF (LEFT0_RIGHT1 = '1') THEN
        sreg(3 DOWNTO 0) <= '1' & sreg(3 DOWNTO 1);
      ELSIF (UP1_DOWN0 = '0') THEN
        sreg(3 DOWNTO 0) <= sreg(2 DOWNTO 0) & '0';
      END IF;
    END IF;
  END PROCESS;

  REG_BITS <= sreg;

END;