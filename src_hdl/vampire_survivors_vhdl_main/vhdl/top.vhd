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


  signal pixel : pixel_t;
  signal pixel_valid : std_logic := '0';
  signal swapped : std_logic;
  signal line_counter : unsigned(8 downto 0);
  signal frame_counter : unsigned(8 downto 0);

  signal rect_pixel_out : pixel_t := default_pixel;
  signal rect_pixel_valid : std_logic := '0';
  signal rect_done : std_logic := '0';
  signal draw_line : std_logic := '0';
  
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

  LED(15 downto 9) <= std_logic_vector(line_counter(6 downto 0));
  LED(8 downto 0) <= std_logic_vector(frame_counter);

  line_proc : process(CLK100MHZ)
  begin
    if rising_edge(CLK100MHZ) then
      if clr = '1' then
        line_counter <= (others => '0');
        frame_counter <= (others => '0');
      else
        if rect_done = '1' then
          draw_line <= '1';
        end if;

        if swapped = '1' then
          if frame_counter = 319 then
            frame_counter <= (others => '0');
          else
            frame_counter <= frame_counter + 1;
          end if;
        end if;

        if draw_line = '1' then
          if line_counter = 179 then
            line_counter <= (others => '0');
            draw_line <= '0';
            pixel_valid <= '0';
          else
            line_counter <= line_counter + 1;
            pixel_valid <= '1';
            pixel.color.r <= to_unsigned(15, 4);
            pixel.color.g <= to_unsigned(15, 4);
            pixel.color.b <= to_unsigned(15, 4);
            pixel.coord.x <= frame_counter;
            pixel.coord.y <= line_counter;
          end if;
        else
          -- write rect pixels
          pixel_valid <= rect_pixel_valid;
          pixel <= rect_pixel_out;
        end if;
      end if;
    end if;
  end process;

  rect_renderer_inst : entity work.rect_renderer
  port map(
    clk => CLK100MHZ,
    reset => clr,
    go => swapped,
    -- size is 320x180
    size => (x => to_unsigned(320, 9), y => to_unsigned(180, 9)),
    -- color is black
    color => (r => to_unsigned(0, 4), g => to_unsigned(15, 4), b => to_unsigned(0, 4)),
    pixel_out => rect_pixel_out,
    pixel_valid => rect_pixel_valid,
    done => rect_done
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
