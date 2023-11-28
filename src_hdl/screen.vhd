library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.log2;
use ieee.math_real.ceil;
use work.custom_types.all;

entity screen is
  generic(
    WIDTH : positive := 320;
    HEIGHT : positive := 180;
    RENDER_SCALE : positive := 4 -- must be a power of 2
  );
  port(
    mclk : in std_logic;
    vga_clk1 : in std_logic;
    vga_clk2 : in std_logic;
    vga_mode : in std_logic;
    clear : in std_logic;
    pixel : in pixel_t; -- pixel, from GPU
    pixel_valid : in std_logic; -- when this is high, read/process pixel
    hsync : out std_logic;
    vsync : out std_logic;
    color : out color_t; -- to VGA
    swapped : out std_logic -- in mclk domain. this should trigger a new frame to start rendering.
  );
end entity screen;

architecture screen of screen is
  -- bits per pixel
  -- 18 is the minimum depth for a xilinx BRAM. we only need 12 in theory but the addtional 6 bits are free.
  constant PIXEL_BITS : positive := 18;
  constant COORD_SHIFT_AMNT : positive := positive(ceil(log2(real(RENDER_SCALE))));

  type addr_array is array (natural range <>) of unsigned(integer(ceil(log2(real(WIDTH * HEIGHT)))) - 1 downto 0);

  type data_array is array (natural range <>) of std_logic_vector(PIXEL_BITS-1 downto 0);

  signal writing_to_zero : std_logic := '1';
  signal pixel_read_color : color_t;
  signal pixel_pos : screen_coord_t;
  signal hsync_sig, vsync_sig : std_logic;
  signal pixel_clock : std_logic;
  signal vga_width, vga_height : screen_pos_t;
  signal swap : std_logic;

  signal we_write : boolean_vector(1 downto 0);
  signal addr_write : addr_array(0 to 1);
  signal din_write : data_array(0 to 1);

  signal en_read : boolean_vector(1 downto 0);
  signal addr_read : addr_array(0 to 1);
  signal dout_read : data_array(0 to 1);

  signal swap_delayed : std_logic := '0';
  signal swap_pulse_metastable : std_logic := '0';
  signal swap_pulse_stable : std_logic_vector(1 downto 0) := (others => '0');

begin

  -- make hsync, vsync registered so that they are delayed by 1 clock cycle.
  -- this is necessary because the reading from bram will take 1 clock cycle.
  -- TODO: might not be necessary. do some testing.
  delay_proc : process(pixel_clock)
  begin
    if rising_edge(pixel_clock) then
      hsync <= hsync_sig;
      vsync <= vsync_sig;
    end if;
  end process;

  swap_mclk_proc : process(mclk)
  begin
    if rising_edge(mclk) then
      -- need to lengthen the pulse since the pixel clock could be higher than mclk (but lower than 2x mclk)
      swap_pulse_metastable <= swap_delayed or swap;
      -- edge detector
      swap_pulse_stable(1) <= swap_pulse_metastable;
      swap_pulse_stable(0) <= swap_pulse_stable(1);
      swapped <= swap_pulse_stable(1) and not swap_pulse_stable(0);
    end if;
  end process;

  -- we want to swap when the last pixel is written to the screen.
  swap_proc : process(pixel_clock)
  begin
    if rising_edge(pixel_clock) and swap = '1' then
      writing_to_zero <= not writing_to_zero;
      swap_delayed <= swap;
    end if;
  end process;

  write_pixel_proc : process(mclk)
    variable addr_write_full : unsigned(pixel.coord.x'length + positive(ceil(log2(real(WIDTH)))) - 1 downto 0) := (others => '0');
  begin
    addr_write_full := pixel.coord.x + pixel.coord.y * WIDTH;
    if rising_edge(mclk) then
      if pixel_valid = '1' then
        -- write to the buffer that is not being read from
        if writing_to_zero = '1' then
          we_write(0) <= true;
          we_write(1) <= false; -- turn off writing to the other buffer
          addr_write(0) <= addr_write_full(addr_write(0)'length-1 downto 0);
          din_write(0)(11 downto 0) <= color_to_vec(pixel.color);
          din_write(0)(17 downto 12) <= (others => '1'); -- alpha or something. not sure yet
        else
          we_write(1) <= true;
          we_write(0) <= false; -- turn off writing to the other buffer
          addr_write(1) <= addr_write_full(addr_write(1)'length-1 downto 0);
          din_write(1)(11 downto 0) <= color_to_vec(pixel.color);
          din_write(1)(17 downto 12) <= (others => '1'); -- alpha or something. not sure yet
        end if;
      else
        -- disable writing to both buffers
        we_write <= (others => false);
      end if;
    end if;
  end process;

  read_pixel_proc : process(pixel_clock)
    variable addr_read_full : unsigned(21 downto 0) := (others => '0'); -- TODO: can't work out the math to get 21 bits
  begin
    addr_read_full := shift_right(pixel_pos.x, 2) + shift_right(pixel_pos.y, 2) * WIDTH;
    if rising_edge(pixel_clock) then
      -- writing to zero, so read from one
      if writing_to_zero = '1' then
        en_read(1) <= true;
        en_read(0) <= false;
        addr_read(1) <= addr_read_full(addr_read(1)'length-1 downto 0);
        pixel_read_color <= vec_to_color(dout_read(1)(11 downto 0));
      else
        en_read(0) <= true;
        en_read(1) <= false;
        addr_read(0) <= addr_read_full(addr_read(0)'length-1 downto 0);
        pixel_read_color <= vec_to_color(dout_read(0)(11 downto 0));
      end if;
    end if;
  end process;

  multi_vga_inst : entity work.multi_vga
  port map(
    clear => clear,
    color_in => pixel_read_color,
    mode => vga_mode,
    clk1 => vga_clk1,
    clk2 => vga_clk2,
    color_out => color,
    pos => open,
    pos_look_ahead => pixel_pos,
    hsync => hsync_sig,
    vsync => vsync_sig, -- TODO: need to delay hsync, vsync to line up with color
    valid => open,
    vga_width => vga_width,
    vga_height => vga_height,
    last_pixel => swap,
    pixel_clock => pixel_clock
  );

  -- BRAMs for double buffering
  buffer_zero : entity work.bram_sdp
  generic map (
    WIDTH => PIXEL_BITS,
    DEPTH => WIDTH * HEIGHT
    -- no init file
  )
  port map(
    -- system is writing pixels, so write port takes master clock
    clk_a => mclk,
    we_a => we_write(0),
    addr_a => addr_write(0),
    din_a => din_write(0),
    -- vga is reading pixels, so read port takes pixel clock
    clk_b => pixel_clock,
    en_b => en_read(0),
    addr_b => addr_read(0),
    dout_b => dout_read(0)
  );

  buffer_one : entity work.bram_sdp
  generic map (
    WIDTH => PIXEL_BITS,
    DEPTH => WIDTH * HEIGHT
    -- no init file
  )
  port map(
    -- system is writing pixels, so write port takes master clock
    clk_a => mclk,
    we_a => we_write(1),
    addr_a => addr_write(1),
    din_a => din_write(1),
    -- vga is reading pixels, so read port takes pixel clock
    clk_b => pixel_clock,
    en_b => en_read(1),
    addr_b => addr_read(1),
    dout_b => dout_read(1)
  );

end screen;