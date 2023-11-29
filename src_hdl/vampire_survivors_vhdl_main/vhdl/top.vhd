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
  signal line_task_counter : unsigned(9 downto 0);
  signal frame_counter : unsigned(8 downto 0);
  
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

  LED(15 downto 9) <= std_logic_vector(line_task_counter(6 downto 0));
  LED(8 downto 0) <= std_logic_vector(frame_counter);

  -- temp process for plotting a line to the screen
  -- the idea is to increment the frame counter when a new frame starts.
  -- then, also when the frame starts, iterate through the line_task_counter until it reaches 2*height, then stop.
  -- when the line_task_counter is even, plot a pixel at (frame_counter, line_task_counter/2)
  -- when the line_task_counter is odd, blank out the previous pixel at (frame_counter, (line_task_counter-1)/2)
  line_proc : process(CLK100MHZ)
    variable line_y : unsigned(8 downto 0);
  begin
    line_y := line_task_counter(9 downto 1);
    if rising_edge(CLK100MHZ) then
      if clr = '1' then
        line_task_counter <= (others => '0');
        frame_counter <= (others => '0');
      else
        if swapped = '1' then
          if frame_counter = 319 then
            frame_counter <= (others => '0');
          else
            frame_counter <= frame_counter + 1;
          end if;
          line_task_counter <= (others => '0');
        else
          if line_task_counter < 360 then
            line_task_counter <= line_task_counter + 1;
          end if;
        end if;

        if line_task_counter < 360 then
          if line_task_counter(0) = '0' then
            -- write pixel at (frame_counter, line_counter)
            pixel_valid <= '1';
            pixel.color.r <= to_unsigned(15, 4);
            pixel.color.g <= to_unsigned(15, 4);
            pixel.color.b <= to_unsigned(15, 4);
            pixel.coord.x <= frame_counter;
            pixel.coord.y <= line_y;
  
          else
            -- blank out the previous pixel
            pixel_valid <= '1';
            pixel.color.r <= to_unsigned(0, 4);
            pixel.color.g <= to_unsigned(0, 4);
            pixel.color.b <= to_unsigned(0, 4);
            pixel.coord.x <= frame_counter - 2;
            pixel.coord.y <= line_y;
          end if;
        else
          -- stop writing pixels
          pixel_valid <= '0';
        end if;

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

end Behavioral;
