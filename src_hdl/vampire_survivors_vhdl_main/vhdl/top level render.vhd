library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.custom_types.all;

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
    VGA_VS : out std_logic
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

  signal gpu_instruction : gpu_instruction_t;
  signal gpu_go : std_logic;
  signal gpu_done : std_logic;
  signal lvl_done : std_logic;
  signal lvl_done_delay : std_logic := '0';
  signal lvl_done_edge_count : unsigned(15 downto 0) := (others => '0');


  signal pixel : pixel_t;
  signal pixel_valid : std_logic := '0';
  signal swapped : std_logic;

  -- inputs from controller(s)
  signal left_inputs, right_inputs, up_inputs, down_inputs, select_inputs : std_logic_vector(0 downto 0);
  -- combined/synced inputs
  signal left, right, up, down, select_s : std_logic;
  
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

  left_inputs(0) <= BTNL;
  right_inputs(0) <= BTNR;
  up_inputs(0) <= BTNU;
  down_inputs(0) <= BTND;
  select_inputs(0) <= BTNC;

  -- visualize lvl_done_edge_count
  LED <= std_logic_vector(lvl_done_edge_count(15 downto 0));

  gpu_inst : entity work.gpu
  port map(
    clk => CLK100MHZ,
    reset => clr,
    instruction => gpu_instruction,
    go => gpu_go,
    done => gpu_done,
    pixel_out => pixel,
    pixel_valid => pixel_valid
  );

  render_level1_inst : entity work.render_level1
  port map(
    clk => CLK100MHZ,
    reset => clr,
    go => swapped,
    gpu_instruction => gpu_instruction,
    gpu_go => gpu_go,
    gpu_done => gpu_done,
    done => lvl_done -- TODO: currently don't care but use this to chain rendering
  );

  render_lvl_debug_proc : process(CLK100MHZ)
  begin
    if rising_edge(CLK100MHZ) then
      lvl_done_delay <= lvl_done;
      if lvl_done_delay = '0' and lvl_done = '1' then
        lvl_done_edge_count <= lvl_done_edge_count + 1;
      end if;
    end if;
  end process;


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

  input_sync_inst : entity work.input_sync
  port map(
    clk => CLK100MHZ,
    left_in => left_inputs,
    right_in => right_inputs,
    up_in => up_inputs,
    down_in => down_inputs,
    select_in => select_inputs,
    left_out => left,
    right_out => right,
    up_out => up,
    down_out => down,
    select_out => select_s
  );

end Behavioral;
