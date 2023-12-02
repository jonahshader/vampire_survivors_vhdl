library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.fixed_pkg.all;
use ieee.math_real.log2;
use ieee.math_real.ceil;

package custom_types is
  subtype color_component_t is unsigned(3 downto 0);
  function default_color_component return color_component_t;
  type color_t is record
    r : color_component_t;
    g : color_component_t;
    b : color_component_t;
  end record;
  function default_color return color_t;

   -- used for addressing framebuffer. encompasses 320x180
  subtype frame_pos_t is unsigned(8 downto 0);
  function default_frame_pos return frame_pos_t;
  type frame_coord_t is record
    x : frame_pos_t;
    y : frame_pos_t;
  end record;
  function default_frame_coord return frame_coord_t;

  -- use in GPU for translating pixels.
  type translation_t is record
    -- we want one more bit for the sign
    x : signed(frame_pos_t'length downto 0);
    y : signed(frame_pos_t'length downto 0);
  end record;
  function default_translation return translation_t;

  -- used for addressing vga pixels. encompasses 1280x960
  subtype screen_pos_t is unsigned(10 downto 0);
  function default_screen_pos return screen_pos_t;
  type screen_coord_t is record
    x : screen_pos_t;
    y : screen_pos_t;
  end record;
  function default_screen_coord return screen_coord_t;

  type pixel_t is record
    color : color_t;
    coord : frame_coord_t;
  end record;
  function default_pixel return pixel_t;

  -- TODO: verify that this is enough bits
  subtype world_pos_t is sfixed(11 downto -6); -- 6 bits of fractional part, 12 bits of integer part. 18 bits total
  function default_world_pos return world_pos_t;
  type world_coord_t is record
    x : world_pos_t;
    y : world_pos_t;
  end record;
  function default_world_coord return world_coord_t;


  -- function prototypes
  function ceil_log2(x : integer) return integer;

  function vec_to_color(data_in : std_logic_vector(11 downto 0)) return color_t;
  function color_to_vec(data_in : color_t) return std_logic_vector;


end package custom_types;

package body custom_types is
  -- function implementations
  function default_color_component return color_component_t is
    variable default_value : color_component_t := (others => '0');
  begin
    return default_value;
  end function default_color_component;

  function default_color return color_t is
    variable default_value : color_t := (others => default_color_component);
  begin
    return default_value;
  end function default_color;

  function default_frame_pos return frame_pos_t is
    variable default_value : frame_pos_t := (others => '0');
  begin
    return default_value;
  end function default_frame_pos;

  function default_frame_coord return frame_coord_t is
    variable default_value : frame_coord_t := (others => default_frame_pos);
  begin
    return default_value;
  end function default_frame_coord;

  function default_translation return translation_t is
    variable default_value : translation_t := (x => to_signed(0, frame_pos_t'length + 1), y => to_signed(0, frame_pos_t'length + 1));
  begin
    return default_value;
  end function default_translation;

  function default_screen_pos return screen_pos_t is
    variable default_value : screen_pos_t := (others => '0');
  begin
    return default_value;
  end function default_screen_pos;

  function default_screen_coord return screen_coord_t is
    variable default_value : screen_coord_t := (others => default_screen_pos);
  begin
    return default_value;
  end function default_screen_coord;

  function default_pixel return pixel_t is
    variable default_value : pixel_t := (coord => default_frame_coord, color => default_color);
  begin
    return default_value;
  end function default_pixel;

  function default_world_pos return world_pos_t is
    -- not sure if I can do (others => '0') for sfixed
    variable default_value : world_pos_t := to_sfixed(0.0, 11, -6);
  begin
    return default_value;
  end function default_world_pos;

  function default_world_coord return world_coord_t is
    variable default_value : world_coord_t := (others => default_world_pos);
  begin
    return default_value;
  end function default_world_coord;


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