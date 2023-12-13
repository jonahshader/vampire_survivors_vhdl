library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.gpu_codes.all;
use work.custom_types.all;
use ieee.math_real.ceil;
use ieee.math_real.log2;

entity render_enemies is
  port(
    clk : in std_logic;
    reset : in std_logic;
    go : in std_logic; -- from render_game. allows us to start
    
    -- from enemy_state_rewrite
    ready_to_start_rendering : in std_logic; -- from enemy_state_rewrite, also allows us to start
    request_next_enemy : out std_logic := '0'; -- tells enemy_state_rewrite to give us the next enemy
    enemy_to_render : in enemy_t;
    enemy_valid : in std_logic; -- tells us if the enemy is valid
    render_done : in std_logic; -- tells us if the last enemy was sent

    -- to gpu
    gpu_instruction : out gpu_instruction_t;
    gpu_go : out std_logic; -- tells gpu to start
    gpu_done : in std_logic; -- tells us that gpu is done

    done : out std_logic -- tells render_game that we are done
  );
end entity render_enemies;

architecture render_enemies of render_enemies is
  signal ready_to_start_renderering_delayed : std_logic := '0';
  signal ready : std_logic := '0';

  signal render_done_delayed : std_logic := '0';
  signal stop_rendering : std_logic := '0';

  signal go_delay : std_logic := '0';
  signal going : std_logic := '0';

  signal enemy_valid_delayed : std_logic := '0';
  signal enemy_render_queued : std_logic := '0';

  signal gpu_instruction_reg : gpu_instruction_t := (
    renderer => rect,
    pos => default_translation,
    size => default_frame_coord,
    color => default_color,
    enum => (others => '0')
  );

  signal gpu_go_reg : std_logic := '0';
  signal done_reg : std_logic := '0';

  type state_t is (idle, render_enemy, wait_for_gpu);
  signal state : state_t := idle;
begin
  gpu_instruction <= gpu_instruction_reg;
  gpu_go <= gpu_go_reg;
  done <= done_reg;

  state_proc : process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ready_to_start_renderering_delayed <= '0';
        ready <= '0';
        render_done_delayed <= '0';
        stop_rendering <= '0';
        state <= idle;
        go_delay <= '0';
        going <= '0';
        enemy_valid_delayed <= '0';
        enemy_render_queued <= '0';
        request_next_enemy <= '0';
      else
        -- ready edge detector
        ready_to_start_renderering_delayed <= ready_to_start_rendering;
        if ready_to_start_rendering = '1' and ready_to_start_renderering_delayed = '0' then
          ready <= '1';
        end if;

        -- stop_rendering edge detector
        render_done_delayed <= render_done;
        if render_done = '1' and render_done_delayed = '0' then
          stop_rendering <= '1';
        end if;

        -- go edge detector
        go_delay <= go;
        if go = '1' and go_delay = '0' then
          going <= '1';
        end if;

        -- enemy_valid edge detector
        enemy_valid_delayed <= enemy_valid;
        if enemy_valid = '1' and enemy_valid_delayed = '0' then
          enemy_render_queued <= '1';
        end if;

        case state is
          when idle =>
            done_reg <= '0';
            if ready = '1' and going = '1' then 
              state <= render_enemy;
              ready <= '0';
              going <= '0';
              request_next_enemy <= '1';
            end if;
          when render_enemy =>
            if enemy_render_queued = '1' then
              enemy_render_queued <= '0';
              request_next_enemy <= '0';
              -- make gpu call
              gpu_instruction_reg <= (
                renderer => circle,
                pos => (x => signed(resize(enemy_to_render.pos.x, gpu_instruction_reg.pos.x'length)), y => signed(resize(enemy_to_render.pos.y, gpu_instruction_reg.pos.y'length))),
                size => (x => to_unsigned(10, gpu_instruction.size.x'length), y => to_unsigned(10, gpu_instruction.size.y'length)),
                color => (r => to_unsigned(12, 4), g => to_unsigned(12, 4), b => to_unsigned(0, 4)),
                enum => (others => '0')
              );
              gpu_go_reg <= '1';
              state <= wait_for_gpu;
            end if;
          when wait_for_gpu =>
            gpu_go_reg <= '0';
            if gpu_done = '1' then
              if stop_rendering = '1' then
                state <= idle;
                done_reg <= '1';
                stop_rendering <= '0';
              else
                request_next_enemy <= '1'; -- keep this high until we get a new enemy
                state <= render_enemy;
              end if;
            end if;
          when others => null;
        end case;

      end if;
    end if;
  end process;

end render_enemies;