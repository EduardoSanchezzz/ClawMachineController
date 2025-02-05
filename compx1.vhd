LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
LIBRARY work;

ENTITY compx1 IS
  PORT (
    A, B : IN STD_LOGIC;
    compx1_out1, compx1_out2, compx1_out3 : OUT STD_LOGIC
  );
END compx1;

ARCHITECTURE compx_logic OF compx1 IS

BEGIN
  -- derived from truth tables
  compx1_out1 <= (NOT A) AND B;
  compx1_out2 <= A XNOR B;
  compx1_out3 <= A AND (NOT B);

END ARCHITECTURE compx_logic;