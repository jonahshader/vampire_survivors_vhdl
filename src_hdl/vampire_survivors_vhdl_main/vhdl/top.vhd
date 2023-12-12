library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.custom_types.all;
use ieee.fixed_pkg.all;

entity top is
  Port ( 
    CLK100MHZ : in std_logic;
    CPU_RESETN : in std_logic;
    SW : in std_logic_vector(15 downto 0);
    LED : out std_logic_vector(15 downto 0);
    BTNC : in std_logic;
    BTNU : in std_logic;
    BTND : in std_logic;
    BTNL : in std_logic;
    BTNR : in std_logic;
    VGA_R : out std_logic_vector(3 downto 0);
    VGA_G : out std_logic_vector(3 downto 0);
    VGA_B : out std_logic_vector(3 downto 0);
    VGA_HS : out std_logic;
    VGA_VS : out std_logic;
    PS2_CLK : out std_logic;
    PS2_DATA : out std_logic
  );
end top;

architecture Behavioral of top is
  signal clr : std_logic;
  signal pos : screen_coord_t;
  signal color, color_out : color_t;
  signal vga_mode : std_logic;
  signal vga_width, vga_height : unsigned(10 downto 0);
  signal vga_hs_temp, vga_vs_temp : std_logic;
  
  signal vga_clk1, vga_clk2 : std_logic;

  signal pixel : pixel_t;
  signal pixel_valid : std_logic := '0';
  signal swapped : std_logic;

  -- gamestate sig
  signal item_out : std_logic_vector(2 downto 0);
  signal itemx_out : std_logic_vector(7 downto 0);
  signal itemy_out : std_logic_vector(6 downto 0);

  signal player_x : std_logic_vector(9 downto 0);
  signal player_y : std_logic_vector(9 downto 0);
  signal flipped : std_logic;
  signal player_hp : std_logic_vector(7 downto 0);

  signal whip : std_logic_vector(3 downto 0);
  signal garlic : std_logic_vector(3 downto 0);
  signal mage : std_logic_vector(3 downto 0);
  signal armour : std_logic_vector(3 downto 0);
  signal gloves : std_logic_vector(3 downto 0);
  signal wings : std_logic_vector(3 downto 0);

  signal enem_ready_to_start_rendering : std_logic;
  signal enem_request_next_enemy : std_logic;
  signal enem_enemy_to_render : enemy_t;
  signal enem_enemy_valid : std_logic;
  signal enem_render_done : std_logic;

  component vga_clocks
  port
    (-- Clock in ports
    -- Clock out ports
    clk_out1          : out    std_logic;
    clk_out2          : out    std_logic;
    clk_in1           : in     std_logic
    );
  end component;

begin
  clr <= not CPU_RESETN;
  vga_mode <= SW(0);
  vga_hs <= vga_hs_temp;
  vga_vs <= vga_vs_temp;

  VGA_R <= std_logic_vector(color_out.r);
  VGA_G <= std_logic_vector(color_out.g);
  VGA_B <= std_logic_vector(color_out.b);

  gamestate_inst : entity work.gamestate
  port map(
    mclk => CLK100MHZ,
    clr => clr,
    PS2C => PS2_CLK,
    PS2D => PS2_DATA,
    BTNU => BTNU,
    BTND => BTND,
    BTNL => BTNL,
    BTNR => BTNR,
    BTNC => BTNC,
    swapped => swapped,
    item_out => item_out,
    itemx_out => itemx_out,
    itemy_out => itemy_out,
    player_x => player_x,
    player_y => player_y,
    flipped => flipped,
    player_hp => player_hp,
    whip => whip,
    garlic => garlic,
    mage => mage,
    armour => armour,
    gloves => gloves,
    wings => wings,
    
    ready_to_start_rendering => enem_ready_to_start_rendering,
    request_next_enemy => enem_request_next_enemy,
    enemy_to_render => enem_enemy_to_render,
    enemy_valid => enem_enemy_valid,
    render_done => enem_render_done
  );

  render_game_inst : entity work.render_game
  port map(
    clk => CLK100MHZ,
    reset => clr,
    go => swapped,
    item_in => item_out,
    itemx_in => itemx_out,
    itemy_in => itemy_out,
    player_x => player_x,
    player_y => player_y,
    player_hp => player_hp,
    player_flip => '0',

    whip => (others => '0'),
    garlic => (others => '0'),
    mage => (others => '0'),
    armour => (others => '0'),
    gloves => (others => '0'),
    wings => (others => '0'),

    enem_ready_to_start_rendering => enem_ready_to_start_rendering,
    enem_request_next_enemy => enem_request_next_enemy,
    enem_enemy_to_render => enem_enemy_to_render,
    enem_enemy_valid => enem_enemy_valid,
    enem_render_done => enem_render_done,

    pixel_out => pixel,
    pixel_valid => pixel_valid
  );

  screen_inst : entity work.screen
  port map(
    mclk => CLK100MHZ,
    vga_clk1 => vga_clk1,
    vga_clk2 => vga_clk2,
    vga_mode => vga_mode,
    clear => clr,
    pixel => pixel,
    pixel_valid => pixel_valid,
    hsync => vga_hs_temp,
    vsync => vga_vs_temp,
    color => color_out,
    swapped => swapped
  );
      
  vga_clocks1 : vga_clocks
  port map(
    clk_out1 => vga_clk1,
    clk_out2 => vga_clk2,
    clk_in1 => CLK100MHZ
  );

end Behavioral;
