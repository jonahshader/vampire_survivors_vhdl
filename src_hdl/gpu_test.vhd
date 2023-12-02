library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.gpu_codes.all;
use work.custom_types.all;

entity gpu_test is
  port(
    clk : in std_logic;
    reset : in std_logic;
    go : in std_logic;
    pixel_out : out pixel_t;
    pixel_valid : out std_logic
  );
end entity gpu_test;

architecture gpu_test of gpu_test is
  type gpu_instruction_t is record
    renderer : gpu_renderer_t;
    pos : translation_t;
    size : frame_coord_t;
    color : color_t;
    enum : std_logic_vector(11 downto 0);
  end record;

  -- type gpu_instruction_array_t is array (0 to 5) of gpu_instruction_t;
  -- dont use hard-coded size
  type gpu_instruction_array_t is array (natural range <>) of gpu_instruction_t;

  constant rom : gpu_instruction_array_t := (
    (renderer => rect, pos => default_translation, size => (to_unsigned(320, 9), to_unsigned(180, 9)), color => default_color, enum => (others => '0')),
    (renderer => rect, pos => (to_signed(80, 10), to_signed(120, 10)), size => (to_unsigned(24, 9), to_unsigned(40, 9)), color => (to_unsigned(15, 4), to_unsigned(15, 4), to_unsigned(0, 4)), enum => (others => '0')),
    (renderer => rect, pos => (to_signed(90, 10), to_signed(10, 10)), size => (to_unsigned(32, 9), to_unsigned(32, 9)), color => (to_unsigned(15, 4), to_unsigned(7, 4), to_unsigned(0, 4)), enum => (others => '0')),
    (renderer => circle, pos => (to_signed(200, 10), to_signed(90, 10)), size => (to_unsigned(32, 9), to_unsigned(0, 9)), color => (to_unsigned(15, 4), to_unsigned(0, 4), to_unsigned(15, 4)), enum => (others => '0')),
    (renderer => line, pos => (to_signed(200, 10), to_signed(90, 10)), size => (to_unsigned(32, 9), to_unsigned(48, 9)), color => (to_unsigned(0, 4), to_unsigned(15, 4), to_unsigned(0, 4)), enum => (others => '0')),
    (renderer => circle, pos => (to_signed(150, 10), to_signed(70, 10)), size => (to_unsigned(8, 9), to_unsigned(0, 9)), color => (to_unsigned(5, 4), to_unsigned(5, 4), to_unsigned(15, 4)), enum => (others => '0'))
  );

  signal rom_addr : unsigned(3 downto 0) := (others => '0');

  signal gpu_renderer : gpu_renderer_t := rect;
  signal gpu_pos : translation_t := default_translation;
  signal gpu_size : frame_coord_t := default_frame_coord;
  signal gpu_color : color_t := default_color;
  signal gpu_enum : std_logic_vector(11 downto 0) := (others => '0');
  signal gpu_go : std_logic := '0';
  signal gpu_done : std_logic := '0';

begin

  gpu_test_proc : process(clk)
    variable addr : integer := 0;
  begin
    if rising_edge(clk) then
      if reset = '1' then
        rom_addr <= (others => '0');
        gpu_renderer <= rect;
        gpu_pos <= default_translation;
        gpu_size <= (to_unsigned(320, 9), to_unsigned(180, 9));
      else
        if go = '1' then
          gpu_renderer <= rom(0).renderer;
          gpu_pos <= rom(0).pos;
          gpu_size <= rom(0).size;
          gpu_color <= rom(0).color;
          gpu_enum <= rom(0).enum;

          rom_addr <= to_unsigned(1, rom_addr'length);
          gpu_go <= '1';

        elsif gpu_done = '1' and rom_addr <= 5 then -- 3

          addr := to_integer(unsigned(rom_addr));
          -- assign new instruction to gpu regs
          gpu_renderer <= rom(addr).renderer;
          gpu_pos <= rom(addr).pos;
          gpu_size <= rom(addr).size;
          gpu_color <= rom(addr).color;
          gpu_enum <= rom(addr).enum;

          rom_addr <= rom_addr + 1;
          gpu_go <= '1';

        else
          gpu_go <= '0';
        end if;

      end if;
    end if;
  end process;

  gpu_inst : entity work.gpu
  port map(
    clk => clk,
    reset => reset,
    renderer => gpu_renderer,
    pos => gpu_pos,
    size => gpu_size,
    color => gpu_color,
    enum => gpu_enum,
    go => gpu_go,
    pixel_out => pixel_out,
    pixel_valid => pixel_valid,
    done => gpu_done
  );

  

end gpu_test;