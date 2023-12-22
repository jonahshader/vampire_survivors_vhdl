library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.gpu_codes.all;
use work.custom_types.all;

entity gpu_test is
  port
  (
    clk         : in std_logic;
    reset       : in std_logic;
    go          : in std_logic;
    pixel_out   : out pixel_t;
    pixel_valid : out std_logic
  );
end entity gpu_test;

architecture gpu_test of gpu_test is
  type gpu_instruction_array_t is array (natural range <>) of gpu_instruction_t;

  constant rom : gpu_instruction_array_t := (
  (renderer => rect, pos => default_translation, size => (to_unsigned(320, 9), to_unsigned(180, 9)), color => default_color, enum => (others => '0')),
  (renderer => rect, pos => (to_signed(80, 10), to_signed(120, 10)), size => (to_unsigned(24, 9), to_unsigned(40, 9)), color => (to_unsigned(15, 4), to_unsigned(15, 4), to_unsigned(0, 4)), enum => (others => '0')),
  (renderer => rect, pos => (to_signed(90, 10), to_signed(10, 10)), size => (to_unsigned(32, 9), to_unsigned(32, 9)), color => (to_unsigned(15, 4), to_unsigned(7, 4), to_unsigned(0, 4)), enum => (others => '0')),
  (renderer => circle, pos => (to_signed(200, 10), to_signed(90, 10)), size => (to_unsigned(32, 9), to_unsigned(0, 9)), color => (to_unsigned(15, 4), to_unsigned(0, 4), to_unsigned(15, 4)), enum => (others => '0')),
  (renderer => line, pos => (to_signed(200, 10), to_signed(90, 10)), size => (to_unsigned(32, 9), to_unsigned(48, 9)), color => (to_unsigned(0, 4), to_unsigned(15, 4), to_unsigned(0, 4)), enum => (others => '0')),
  (renderer => circle, pos => (to_signed(150, 10), to_signed(70, 10)), size => (to_unsigned(8, 9), to_unsigned(0, 9)), color => (to_unsigned(5, 4), to_unsigned(5, 4), to_unsigned(15, 4)), enum => (others => '0')),
  (renderer => tile, pos => (to_signed(155, 10), to_signed(75, 10)), size => (to_unsigned(8, 9), to_unsigned(0, 9)), color => (to_unsigned(5, 4), to_unsigned(5, 4), to_unsigned(15, 4)), enum => (0 => '1', others => '0')),
  (renderer => tile, pos => (to_signed(155 + 16, 10), to_signed(75, 10)), size => (to_unsigned(8, 9), to_unsigned(0, 9)), color => (to_unsigned(5, 4), to_unsigned(5, 4), to_unsigned(15, 4)), enum => (others => '0'))
  );

  signal rom_addr : unsigned(3 downto 0) := (others => '0');

  signal gpu_instruction : gpu_instruction_t := default_gpu_instruction;
  signal gpu_go          : std_logic         := '0';
  signal gpu_done        : std_logic         := '0';

begin

  gpu_test_proc : process (clk)
    variable addr : integer := 0;
  begin
    if rising_edge(clk) then
      if reset = '1' then
        rom_addr        <= (others => '0');
        gpu_instruction <= default_gpu_instruction;
        gpu_go          <= '0';
      else
        if go = '1' then
          gpu_instruction <= rom(0);

          rom_addr <= to_unsigned(1, rom_addr'length);
          gpu_go   <= '1';

        elsif gpu_done = '1' and rom_addr < rom'length then

          addr := to_integer(unsigned(rom_addr));
          -- assign new instruction to gpu regs
          gpu_instruction <= rom(addr);

          rom_addr <= rom_addr + 1;
          gpu_go   <= '1';

        else
          gpu_go <= '0';
        end if;

      end if;
    end if;
  end process;

  gpu_inst : entity work.gpu
    port map
    (
      clk         => clk,
      reset       => reset,
      instruction => gpu_instruction,
      go          => gpu_go,
      pixel_out   => pixel_out,
      pixel_valid => pixel_valid,
      done        => gpu_done
    );

end gpu_test;