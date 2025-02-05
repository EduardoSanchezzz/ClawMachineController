library ieee;
use ieee.std_logic_1164.all;
library work;

-- 4 bit comparator

entity comp4x is 
  port(
    A, B : in std_logic_vector(3 downto 0);
    c4_out1, c4_out2, c4_out3 : out std_logic
  );

end comp4x;

architecture comp4x_logic of comp4x is
  
  component compx1
  port(
    A, B :in std_logic;
    compx1_out1, compx1_out2, compx1_out3 : out std_logic
  );
  end component;

  signal x: std_logic_vector(12 downto 1);

begin
  
  -- run 4 instances of 1 bit comparators (1 for each bit)
  compx1_3 : compx1 port map (A(3), B(3), x(1), x(2), x(3));
  compx1_2 : compx1 port map (A(2), B(2), x(4), x(5), x(6));
  compx1_1 : compx1 port map (A(1), B(1), x(7), x(8), x(9));
  compx1_0 : compx1 port map (A(0), B(0), x(10), x(11), x(12));

  -- A<B
  c4_out1 <= x(1) OR (x(2) AND x(4)) OR (x(2) AND x(5) AND x(7)) OR (x(2) AND x(5) AND x(8) AND x(10));

  -- A = B
  c4_out2 <= x(2) AND x(5) AND x(8) AND x(11);

  -- A > B
  c4_out3 <= x(3) OR (x(2) AND x(6)) OR (x(2) AND x(5) AND x(9)) OR (x(2) AND x(5) AND x(8) AND x(12));

end comp4x_logic;