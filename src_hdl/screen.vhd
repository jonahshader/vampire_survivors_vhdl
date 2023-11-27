library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.custom_types.all;

entity screen is
  generic(
    WIDTH : positive := 320;
    HEIGHT : positive := 180
  );
  port(
    clk : in std_logic;
    reset : in std_logic;
    pixel : out pixel_t;
    hsync : out std_logic;
    vsync : out std_logic
  );
end entity screen;