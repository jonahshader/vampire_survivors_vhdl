library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.custom_types.all;
use ieee.fixed_pkg.all;

entity top is
  port
  (
    mclk        : in std_logic;
    clr         : in std_logic;
    center      : in std_logic;
    up          : in std_logic;
    down        : in std_logic;
    left        : in std_logic;
    right       : in std_logic;
    start_frame : in std_logic;
    r           : out unsigned(3 downto 0);
    g           : out unsigned(3 downto 0);
    b           : out unsigned(3 downto 0);
    pixel_x     : out unsigned(8 downto 0);
    pixel_y     : out unsigned(8 downto 0);
    pixel_valid : out std_logic;
    frame_done  : out std_logic
  );
end top;

architecture Behavioral of top is
  -- gamestate sig
  signal item_out  : std_logic_vector(2 downto 0);
  signal itemx_out : std_logic_vector(7 downto 0);
  signal itemy_out : std_logic_vector(6 downto 0);

  signal player_x  : std_logic_vector(9 downto 0);
  signal player_y  : std_logic_vector(9 downto 0);
  signal flipped   : std_logic;
  signal player_hp : std_logic_vector(7 downto 0);

  signal whip   : std_logic_vector(3 downto 0);
  signal garlic : std_logic_vector(3 downto 0);
  signal mage   : std_logic_vector(3 downto 0);
  signal armour : std_logic_vector(3 downto 0);
  signal gloves : std_logic_vector(3 downto 0);
  signal wings  : std_logic_vector(3 downto 0);

  signal pixel : pixel_t;

begin
  r       <= pixel.color.r;
  g       <= pixel.color.g;
  b       <= pixel.color.b;
  pixel_x <= pixel.coord.x;
  pixel_y <= pixel.coord.y;

  gamestate_inst : entity work.gamestate
    port map
    (
      mclk      => mclk,
      clr       => clr,
      PS2C      => '0',
      PS2D      => '0',
      BTNU      => up,
      BTND      => down,
      BTNL      => left,
      BTNR      => right,
      BTNC      => center,
      swapped   => start_frame,
      item_out  => item_out,
      itemx_out => itemx_out,
      itemy_out => itemy_out,
      player_x  => player_x,
      player_y  => player_y,
      flipped   => flipped,
      player_hp => player_hp,
      whip      => whip,
      garlic    => garlic,
      mage      => mage,
      armour    => armour,
      gloves    => gloves,
      wings     => wings
    );

  render_game_inst : entity work.render_game
    port
    map(
    clk         => mclk,
    reset       => clr,
    go          => start_frame,
    item_in     => item_out,
    itemx_in    => itemx_out,
    itemy_in    => itemy_out,
    player_x    => player_x,
    player_y    => player_y,
    player_hp   => player_hp,
    player_flip => flipped,

    whip => (others => '0'),
    garlic => (others => '0'),
    mage => (others => '0'),
    armour => (others => '0'),
    gloves => (others => '0'),
    wings => (others => '0'),

    pixel_out   => pixel,
    pixel_valid => pixel_valid,
    done        => frame_done
    );

end Behavioral;