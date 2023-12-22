library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.custom_types.all;

entity multi_vga is
  port
  (
    clear          : in std_logic;
    color_in       : in color_t;
    mode           : in std_logic; -- 0 = 1280x720, 1 = 1280x960
    clk1           : in std_logic;
    clk2           : in std_logic;
    color_out      : out color_t;
    pos            : out screen_coord_t;
    pos_look_ahead : out screen_coord_t;
    hsync          : out std_logic;
    vsync          : out std_logic;
    valid          : out std_logic;
    vga_width      : out screen_pos_t;
    vga_height     : out screen_pos_t;
    last_pixel     : out std_logic;
    pixel_clock    : out std_logic
  );
end multi_vga;

architecture Behavioral of multi_vga is
  type color_array is array (0 to 1) of color_t;
  type position_array is array (0 to 1) of unsigned(10 downto 0);
  type screen_coord_array is array (0 to 1) of screen_coord_t;

  signal mode_last_vec   : std_logic_vector(1 downto 0) := "00";
  signal mode_last_2_vec : std_logic_vector(1 downto 0) := "00";

  signal color_out_vec      : color_array;
  signal pos_vec            : screen_coord_array;
  signal pos_look_ahead_vec : screen_coord_array;
  signal hsync_vec          : std_logic_vector(1 downto 0);
  signal vsync_vec          : std_logic_vector(1 downto 0);
  signal vga_width_vec      : position_array;
  signal vga_height_vec     : position_array;
  signal last_pixel_vec     : std_logic_vector(1 downto 0);
  signal global_clear       : std_logic;
  signal clear_vec          : std_logic_vector(1 downto 0);

begin
  color_out <= color_out_vec(0) when mode = '0' else
    color_out_vec(1);
  pos <= pos_vec(0) when mode = '0' else
    pos_vec(1);
  pos_look_ahead <= pos_look_ahead_vec(0) when mode = '0' else
    pos_look_ahead_vec(1);
  hsync <= hsync_vec(0) when mode = '0' else
    hsync_vec(1);
  vsync <= vsync_vec(0) when mode = '0' else
    vsync_vec(1);
  vga_width <= vga_width_vec(0) when mode = '0' else
    vga_width_vec(1);
  vga_height <= vga_height_vec(0) when mode = '0' else
    vga_height_vec(1);
  last_pixel <= last_pixel_vec(0) when mode = '0' else
    last_pixel_vec(1);

  clock_mux_inst : entity work.clock_mux
    port map
    (
      clk1    => clk1,
      clk2    => clk2,
      sel     => mode,
      clk_out => pixel_clock
    );

  mode_last_1_proc : process (clk1)
  begin
    if rising_edge(clk1) then
      mode_last_2_vec(0) <= mode_last_vec(0);
      mode_last_vec(0)   <= mode;
      clear_vec(0)       <= clear or (mode_last_2_vec(0) xor mode_last_vec(0));
    end if;
  end process;

  mode_last_2_proc : process (clk2)
  begin
    if rising_edge(clk2) then
      mode_last_2_vec(1) <= mode_last_vec(1);
      mode_last_vec(1)   <= mode;
      clear_vec(1)       <= clear or (mode_last_2_vec(1) xor mode_last_vec(1));
    end if;
  end process;

  vga1 : entity work.vga
    generic
    map(
    h_visible       => 1280,
    v_visible       => 720,
    h_whole_line    => 1650,
    v_whole_line    => 750,
    h_front_porch   => 110,
    v_front_porch   => 5,
    h_sync_pulse    => 40,
    v_sync_pulse    => 5,
    h_sync_positive => false, -- was true
    v_sync_positive => true
    )
    port
    map(
    clk_pixel      => clk1,
    clear          => clear_vec(0),
    color_in       => color_in,
    color_out      => color_out_vec(0),
    pos            => pos_vec(0),
    pos_look_ahead => pos_look_ahead_vec(0),
    hsync          => hsync_vec(0),
    vsync          => vsync_vec(0),
    last_pixel     => last_pixel_vec(0),
    vga_width      => vga_width_vec(0),
    vga_height     => vga_height_vec(0)
    );

  vga2 : entity work.vga
    generic
    map(
    h_visible       => 1280, -- 1280
    v_visible       => 960, -- 960
    h_whole_line    => 1696, -- 1712
    v_whole_line    => 996, --994
    h_front_porch   => 80, --80
    v_front_porch   => 3, --1
    h_sync_pulse    => 128, --136
    v_sync_pulse    => 4, --3
    h_sync_positive => false, -- false
    v_sync_positive => true -- true
    )
    port
    map(
    clk_pixel      => clk2,
    clear          => clear_vec(1),
    color_in       => color_in,
    color_out      => color_out_vec(1),
    pos            => pos_vec(1),
    pos_look_ahead => pos_look_ahead_vec(1),
    hsync          => hsync_vec(1),
    vsync          => vsync_vec(1),
    last_pixel     => last_pixel_vec(1),
    vga_width      => vga_width_vec(1),
    vga_height     => vga_height_vec(1)
    );
end Behavioral;