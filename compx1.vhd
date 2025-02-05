library ieee;
use ieee.std_logic_1164.all;
library work;

entity compx1 is
  port(
    A, B :in std_logic;
    compx1_out1, compx1_out2, compx1_out3 : out std_logic
  );
end compx1;

architecture compx_logic of compx1 is
  
begin
  -- derived from truth tables
  compx1_out1 <= (NOT A) AND B;
  compx1_out2 <= A XNOR B;
  compx1_out3 <= A AND (NOT B);

end architecture compx_logic;