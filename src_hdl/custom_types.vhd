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

  -- used for addressing vga pixels. encompasses 1280x960
  subtype screen_pos_t is unsigned(10 downto 0);
  type screen_coord_t is record
    x : screen_pos_t;
    y : screen_pos_t;
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

  function vec_to_color(data_in : std_logic_vector(11 downto 0)) return color_t;
  function color_to_vec(data_in : color_t) return std_logic_vector;


end package custom_types;

package body custom_types is
  -- function implementations
  function ceil_log2(x : integer) return integer is
  begin
    return integer(ceil(log2(real(x))));
  end function ceil_log2;

  function vec_to_color(data_in : std_logic_vector(11 downto 0)) return color_t is
    variable result : color_t;
  begin
    result.r := color_component_t(data_in(3 downto 0));
    result.g := color_component_t(data_in(7 downto 4));
    result.b := color_component_t(data_in(11 downto 8));
    return result;
  end function vec_to_color;

  function color_to_vec(data_in : color_t) return std_logic_vector is
    variable result : std_logic_vector(11 downto 0);
  begin
    result(3 downto 0) := std_logic_vector(data_in.r);
    result(7 downto 4) := std_logic_vector(data_in.g);
    result(11 downto 8) := std_logic_vector(data_in.b);
    return result;
  end function color_to_vec;

end package body custom_types;