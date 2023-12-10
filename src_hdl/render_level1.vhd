library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.gpu_codes.all;
use work.custom_types.all;
use work.level_pkg.all;


entity render_level1 is
  port(
    clk : in std_logic;
    reset : in std_logic;
    go : in std_logic;
    gpu_instruction : out gpu_instruction_t;
    gpu_go : out std_logic;
    gpu_done : in std_logic;
    done : out std_logic
  );
end entity render_level1;

architecture render_level1 of render_level1 is
  signal gpu_instruction_reg : gpu_instruction_t := (
    renderer => tile,
    pos => default_translation,
    size => default_frame_coord,
    color => default_color,
    enum => (others => '0')
  );

  signal gpu_go_reg : std_logic := '0';
  signal done_reg : std_logic := '0';

  signal level_rom_addr : unsigned(15 downto 0) := (others => '0');

  type state_t is (idle, render);
  signal state_reg : state_t := idle;
begin

  gpu_instruction <= gpu_instruction_reg;
  gpu_go <= gpu_go_reg;
  done <= done_reg;

  render_proc : process(clk)
    variable addr : integer := 0;
  begin
    if rising_edge(clk) then
      if reset = '1' then
        gpu_instruction_reg <= (
          renderer => tile,
          pos => default_translation,
          size => default_frame_coord,
          color => default_color,
          enum => (others => '0')
        );
        gpu_go_reg <= '0';
        done_reg <= '0';
        level_rom_addr <= (others => '0');
        state_reg <= idle;
      else
        case state_reg is
          when idle =>
            done_reg <= '0';
            if go = '1' then
              state_reg <= render;

              -- assign first instruction to gpu regs
              gpu_instruction_reg.renderer <= tile;
              gpu_instruction_reg.pos.x <= signed(shift_left(resize(tile_render_rom(0).tile_x, gpu_instruction_reg.pos.x'length), 4)); -- TODO: don't hardcode log2(TILE_WIDTH_PX)
              gpu_instruction_reg.pos.y <= signed(shift_left(resize(tile_render_rom(0).tile_y, gpu_instruction_reg.pos.y'length), 4)); -- TODO: don't hardcode log2(TILE_HEIGHT_PX)
              gpu_instruction_reg.enum(tile_render_rom(0).tile_id'length-1 downto 0) <= std_logic_vector(tile_render_rom(0).tile_id);
              gpu_instruction_reg.enum(gpu_instruction_reg.enum'length-1 downto tile_render_rom(0).tile_id'length) <= (others => '0');
              -- start gpu
              gpu_go_reg <= '1';
              level_rom_addr <= to_unsigned(1, level_rom_addr'length);
            end if;

          when render =>
            if gpu_done = '1' then
              if level_rom_addr < tile_render_rom'length then
                addr := to_integer(unsigned(level_rom_addr));
                gpu_instruction_reg.pos.x <= signed(shift_left(resize(tile_render_rom(addr).tile_x, gpu_instruction_reg.pos.x'length), 4)); -- TODO: don't hardcode log2(TILE_WIDTH_PX)
                gpu_instruction_reg.pos.y <= signed(shift_left(resize(tile_render_rom(addr).tile_y, gpu_instruction_reg.pos.y'length), 4)); -- TODO: don't hardcode log2(TILE_HEIGHT_PX)
                gpu_instruction_reg.enum(tile_render_rom(0).tile_id'length-1 downto 0) <= std_logic_vector(tile_render_rom(addr).tile_id);
                gpu_instruction_reg.enum(gpu_instruction_reg.enum'length-1 downto tile_render_rom(0).tile_id'length) <= (others => '0');
      
                -- increment address
                level_rom_addr <= level_rom_addr + 1;
      
                -- start gpu
                gpu_go_reg <= '1';
              else
                -- gpu is done and we are out of instructions, so we are done
                done_reg <= '1';
                state_reg <= idle;
                gpu_go_reg <= '0';
              end if;
            else
              gpu_go_reg <= '0';
            end if;

          when others => null;
        end case;
      end if;
    end if;
  end process;

end render_level1;