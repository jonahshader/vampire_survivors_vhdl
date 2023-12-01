library ieee;
use ieee.std_logic_1164.all;
use work.gpu_codes.all;
use work.custom_types.all;

-- gpu is the top level entity for the gpu. it takes in commands and outputs pixels.
-- only processes one command at a time. must wait for done to go high before issuing another command.
-- the gpu has four renderers: rect, circle, line, and sprite. here is how to use them:

-- rect:
--   cmd_type = rect
--   pos = top left corner of rectangle
--   size = width and height of rectangle
--   color = color of rectangle
--   enum = unused (TODO: maybe use for different rectangle types?)

-- circle:
--   cmd_type = circle
--   pos = center of circle
--   size.x = radius of circle
--   size.y = unused
--   color = color of circle
--   enum = unused (TODO: maybe use for different circle types?)

-- line:
--   cmd_type = line
--   pos = start of line
--   size = end of line
--   color = color of line
--   enum = unused (TODO: maybe use for different line types?)

-- sprite:
--   cmd_type = sprite
--   pos = top left corner of sprite
--   size = unused (TODO: maybe use for sprite resizing?)
--   color = unused (TODO: maybe use for sprite tint?)
--   enum = sprite number

entity gpu is
  port(
    -- gpu only runs one command at a time. wait for done to go high before issuing another command.
    clk : in std_logic;
    reset : in std_logic;
    cmd_type : in gpu_code_t;
    pos : in frame_coord_t;
    size : in frame_coord_t; -- for circle, use x for radius, y for unused
    color : in color_t;
    enum : in std_logic_vector(11 downto 0);
    go : in std_logic;
    pixel_out : out pixel_t;
    pixel_valid : out std_logic;
    done : out std_logic
  );
end entity gpu;

architecture gpu of gpu is
  type state_t is (idle, cmd_to_renderer, running);
  signal state : state_t;
  signal cmd_type_reg : gpu_code_t;
  signal pos_reg : frame_pos_t;
begin

end gpu;