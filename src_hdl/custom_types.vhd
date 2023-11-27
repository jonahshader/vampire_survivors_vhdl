library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.fixed_pkg.all;
use ieee.math_real.log2;
use ieee.math_real.ceil;

package custom_types is
  subtype color_component_t is unsigned(3 downto 0);
  type color_t is record
    r : color_component_t;
    g : color_component_t;
    b : color_component_t;
  end record;

   -- used for addressing framebuffer. encompasses 320x180
  subtype frame_pos_t is unsigned(8 downto 0);
  type frame_coord_t is record
    x : frame_pos_t;
    y : frame_pos_t;
  end record;

  type pixel_t is record
    color : color_t;
    coord : frame_coord_t;
  end record;

  -- TODO: verify that this is enough bits
  subtype world_pos_t is sfixed(11 downto -6); -- 6 bits of fractional part, 12 bits of integer part. 18 bits total
  type world_coord_t is record
    x : world_pos_t;
    y : world_pos_t;
  end record;


  -- function prototypes
  function ceil_log2(x : integer) return integer;


end package custom_types;

package body custom_types is
  -- function implementations
  function ceil_log2(x : integer) return integer is
  begin
    return integer(ceil(log2(real(x))));
  end function ceil_log2;

end package body custom_types;