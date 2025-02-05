LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY top IS PORT (
  clk : IN STD_LOGIC;
  rst_n : IN STD_LOGIC;
  pb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
  sw : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
  leds : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
);
END ENTITY;

ARCHITECTURE Circuit OF top IS

  -- COMPONENTS
  COMPONENT Bidir_shift_reg PORT (
    CLK : IN STD_LOGIC := '0';
    RESET_n : IN STD_LOGIC := '0';
    CLK_EN : IN STD_LOGIC := '0';
    LEFT0_RIGHT1 : IN STD_LOGIC := '0';
    REG_BITS : IN STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT U_D_Bin_Counter8bit PORT (
    CLK : IN STD_LOGIC := '0';
    RESET_n : IN STD_LOGIC := '0';
    CLK_EN : IN STD_LOGIC := '0';
    UP1_DOWN0 : IN STD_LOGIC := '0';
    COUNTER_BITS : IN STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT XY_Motion_Controller PORT (
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
    SYSTEM FAULT_LED : OUT STD_LOGIC := '0';
    );
  END COMPONENT;

  COMPONENT comp4x PORT (
    A, B : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    c4_out1, c4_out2, c4_out3 : OUT STD_LOGIC
    );
  END COMPONENT;

  COMPONENT grappler IS PORT (
    CLK : IN STD_LOGIC := '0';
    RESET_n : IN STD_LOGIC := '0';
    grap_en, grap_pb : IN STD_LOGIC;
    grap_out : OUT STD_LOGIC
    );
  END COMPONENT;

  COMPONENT Moore_Machine_Extender IS PORT (
    clk_input, rst_n, ext_en, ext_pb : IN STD_LOGIC;
    leds : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    ext_out, grapp_en, bidir_en, bidir_LR : OUT STD_LOGIC
    );
  END COMPONENT;

  -- SIGNALS

  SIGNAL x_target_in, y_target_in : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL motion, x_GT, x_EQ, x_LT, y_GT, y_EQ, y_LT, extender_out : STD_LOGIC := '0';
  SIGNAL x_U1_D0, y_U1_D0, x_clk_EN, y_clk_EN, extender_EN : STD_LOGIC := '0';
  SIGNAL Latched_X_Target, Latched_Y_Target, X_POS, Y_POS : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL sys_error : STD_LOGIC := '0';

  SIGNAL grap_en : STD_LOGIC := '0';
  SIGNAL grap_pb : STD_LOGIC := '0';
  SIGNAL shift en : STD_LOGIC := '0';
  SIGNAL shift_LR : STD_LOGIC := '0';
  SIGNAL ext_pb : STD_LOGIC := '0';
  SIGNAL ex_pos : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN
  --ASSIGN VALUES TO SIGNALS 
  x_target_in <= sw(7 DOWNTO 4);
  y_target_in <= sw(3 DOWNTO 0);
  motion <= pb(2);
  ext_pb <= pb(1);
  grap_pb <= pb(0);

  XY_MC : XY_Motion Controller PORT MAP(clk, rst_n, x_target_in, y_target_in, motion, X_GT, X_EQ, X_LT, Y_GT, Y_EQ, Y_LT, extender_out, x_U1_D0, y_U1_DO, x_clk_EN, y_clk_EN, Latched_X_Target, Latched_Y_Target, extender_EN, sys_error);

  compx4_x : comp4x PORT MAP(X_POS, Latched_X_Target, X_GT, X_EQ, X_LT);
  compx4_y : comp4x PORT MAP(Y_POS, Latched_Y_Target, Y_GT, Y_EQ, Y_LT);

  X_UD_Counter : U_D_Bin Counter8bit PORT MAP(clk, rst_n, x_clk_EN, x_U1_DO, X_POS);
  Y_UD_Counter : U_D_Bin Counter8bit PORT MAP(clk, rst_n, y_clk_EN, y_U1_DO, Y_POS);
  inst_Moore : Moore_Machine_Extender PORT MAP(clk, rst_n, extender_EN, ext_pb, ex_pos, extender_out, grap_en, shift_en, shift_LR);
  inst_grapp : grappler PORT MAP(clk, rst_n, grap_pb, grap_en, leds(3));
  bit_shift_ext : Bidir_shift_reg PORT MAP(clk, rst_n, shift_en, shift_LR, ex_pos);

  --ASSIGN VALUES TO OUTPUTS
  leds(15 DOWNTO 12) <= XPOS;
  leds(11 DOWNTO 8) <= Y_POS;
  leds(0) <= sys_error :
  leds(7 DOWNTO 4) <= ex_pos;
  --user LEDS
  leds (2) <= extender_EN;
  leds (1) <= grap_en;

END Circuit;