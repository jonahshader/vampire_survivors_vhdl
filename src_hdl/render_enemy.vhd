library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.gpu_codes.all;
use work.custom_types.all;
use ieee.math_real.ceil;
use ieee.math_real.log2;

entity render_enemy is
  port(
    clk : in std_logic;
    reset : in std_logic;
    go : in std_logic;
    enemy : in enemy_t;

    enemy_to_render : in enemy_t;

    -- to gpu
    gpu_instruction : out gpu_instruction_t;
    gpu_go : out std_logic := '0'; -- tells gpu to start
    gpu_done : in std_logic; -- tells us that gpu is done

    done : out std_logic := '0' -- tells render_enemies that we are done
  );
end entity render_enemy;

architecture render_enemy of render_enemy is
  type state_t is (idle, render);
  signal state : state_t := idle;
begin

  state_proc : process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        state <= idle;
        gpu_go <= '0';
        done <= '0';
      else
        case state is
          when idle =>
            done <= '0';
            if go = '1' then
              state <= render;
              gpu_go <= '1';
              gpu_instruction <= (
                renderer => circle,
                pos => (x => signed(resize(enemy_to_render.pos.x, gpu_instruction.pos.x'length)), y => signed(resize(enemy_to_render.pos.y, gpu_instruction.pos.y'length))),
                size => (x => to_unsigned(10, gpu_instruction.size.x'length), y => to_unsigned(10, gpu_instruction.size.y'length)),
                color => (r => to_unsigned(12, 4), g => to_unsigned(12, 4), b => to_unsigned(0, 4)),
                enum => (others => '0')
              );
            end if;
          when render =>
          when others => null;
        end case;
      end if;
    end if;
  end process;

end render_enemy;