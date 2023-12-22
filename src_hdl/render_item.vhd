library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.gpu_codes.all;
use work.custom_types.all;
use ieee.math_real.ceil;
use ieee.math_real.log2;

entity render_item is
  port
  (
    clk   : in std_logic;
    reset : in std_logic;
    go    : in std_logic;

    -- from gamestate
    item_out  : in std_logic_vector(2 downto 0);
    itemx_out : in unsigned(7 downto 0);
    itemy_out : in unsigned(6 downto 0);
    -- to gpu
    gpu_instruction : out gpu_instruction_t;
    gpu_go          : out std_logic;
    gpu_done        : in std_logic;

    done : out std_logic

  );
end render_item;

architecture render_item of render_item is
  signal gpu_instruction_reg : gpu_instruction_t := (
  renderer => rect,
  pos      => default_translation,
  size     => default_frame_coord,
  color    => default_color,
  enum => (others => '0')
  );

  signal gpu_go_reg : std_logic := '0';
  signal done_reg   : std_logic := '0';

  type state_t is (idle, render);
  signal state_reg : state_t := idle;

begin
  gpu_instruction <= gpu_instruction_reg;
  gpu_go          <= gpu_go_reg;
  done            <= done_reg;

  state_proc : process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        state_reg           <= idle;
        gpu_instruction_reg <= (
          renderer => rect,
          pos      => default_translation,
          size     => default_frame_coord,
          color    => default_color,
          enum => (others => '0')
          );
        gpu_go_reg <= '0';
        done_reg   <= '0';
      else
        gpu_go_reg <= '0';
        case state_reg is
          when idle =>
            done_reg <= '0';
            if go = '1' then
              -- render the item
              -- TODO: pick sprite base on item_out
              state_reg           <= render;
              gpu_instruction_reg <= (
                renderer => circle,
                pos => (x => signed(resize(itemx_out, gpu_instruction_reg.pos.x'length)), y => signed(resize(itemy_out, gpu_instruction_reg.pos.y'length))),
                size => (x => to_unsigned(8, gpu_instruction.size.x'length), y => to_unsigned(8, gpu_instruction.size.y'length)),
                color => (r => to_unsigned(12, 4), g => to_unsigned(12, 4), b => to_unsigned(12, 4)),
                enum => (others => '0')
                );
              gpu_go_reg <= '1';
            end if;
          when render =>
            if gpu_done = '1' then
              state_reg <= idle;
              done_reg  <= '1';
            end if;
          when others => null;
        end case;
      end if;
    end if;

  end process;

end render_item;