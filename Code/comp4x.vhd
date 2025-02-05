LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
LIBRARY work;

-- 4 bit comparator

ENTITY comp4x IS
  PORT (
    A, B : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    c4_out1, c4_out2, c4_out3 : OUT STD_LOGIC
  );

END comp4x;

ARCHITECTURE comp4x_logic OF comp4x IS

  COMPONENT compx1
    PORT (
      A, B : IN STD_LOGIC;
      compx1_out1, compx1_out2, compx1_out3 : OUT STD_LOGIC
    );
  END COMPONENT;

  SIGNAL x : STD_LOGIC_VECTOR(12 DOWNTO 1);

BEGIN

  -- run 4 instances of 1 bit comparators (1 for each bit)
  compx1_3 : compx1 PORT MAP(A(3), B(3), x(1), x(2), x(3));
  compx1_2 : compx1 PORT MAP(A(2), B(2), x(4), x(5), x(6));
  compx1_1 : compx1 PORT MAP(A(1), B(1), x(7), x(8), x(9));
  compx1_0 : compx1 PORT MAP(A(0), B(0), x(10), x(11), x(12));

  -- A<B
  c4_out1 <= x(1) OR (x(2) AND x(4)) OR (x(2) AND x(5) AND x(7)) OR (x(2) AND x(5) AND x(8) AND x(10));

  -- A = B
  c4_out2 <= x(2) AND x(5) AND x(8) AND x(11);

  -- A > B
  c4_out3 <= x(3) OR (x(2) AND x(6)) OR (x(2) AND x(5) AND x(9)) OR (x(2) AND x(5) AND x(8) AND x(12));

END comp4x_logic;