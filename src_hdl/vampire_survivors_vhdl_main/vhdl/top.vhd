library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.custom_types.all;

entity top is
  Port ( 
    CLK100MHZ : in std_logic;
    CPU_RESETN : in std_logic;
    SW : in std_logic_vector(15 downto 0);
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
  signal is_edge : boolean;
  signal vga_width, vga_height : unsigned(10 downto 0);
  signal vga_hs_temp, vga_vs_temp : std_logic;
  
  signal vga_clk1, vga_clk2 : std_logic;
  
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
  is_edge <= pos.x < 64 or pos.x >= vga_width - 64 or pos.y < 64 or pos.y >= vga_height - 64;

  vga_hs <= vga_hs_temp;
  vga_vs <= vga_vs_temp;

  VGA_R <= std_logic_vector(color_out.r);
  VGA_G <= std_logic_vector(color_out.g);
  VGA_B <= std_logic_vector(color_out.b);

  color_proc : process(pos)
  begin
    color.r <= (others => '1') when is_edge else (others => '0');
    if vga_hs_temp = '1' then
      color.g <= (others => '1');
    else
      color.g <= pos.x(6 downto 3);
    end if;
    if vga_vs_temp = '1' then
      color.b <= (others => '1');
    else
      color.b <= pos.y(6 downto 3);
    end if;
  end process;

  multi_vga_inst : entity work.multi_vga
    port map(
      clear => clr,
      color_in => color,
      mode => vga_mode,
      clk1 => vga_clk1,
      clk2 => vga_clk2,
      color_out => color_out,
      pos => pos,
      hsync => vga_hs_temp,
      vsync => vga_vs_temp,
      valid => open,
      vga_width => vga_width,
      vga_height => vga_height,
      last_pixel => open
    );
      
  vga_clocks1 : vga_clocks
  port map(
    clk_out1 => vga_clk1,
    clk_out2 => vga_clk2,
    clk_in1 => CLK100MHZ
  );

end Behavioral;
