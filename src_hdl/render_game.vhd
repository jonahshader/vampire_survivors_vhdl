library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.gpu_codes.all;
use work.custom_types.all;

entity render_game is
  port(
    clk : in std_logic;
    reset : in std_logic;
    go : in std_logic;

    -- gamestate to render
    item_in : in std_logic_vector(2 downto 0);
    itemx_in : in std_logic_vector(7 downto 0);
    itemy_in : in std_logic_vector(6 downto 0);
    player_x : in std_logic_vector(9 downto 0);
    player_y : in std_logic_vector(9 downto 0);
    player_hp : in std_logic_vector(7 downto 0);
    player_flip : in std_logic;

    whip : in std_logic_vector(3 downto 0);
    garlic : in std_logic_vector(3 downto 0);
    mage : in std_logic_vector(3 downto 0);
    armour : in std_logic_vector(3 downto 0);
    gloves : in std_logic_vector(3 downto 0);
    wings : in std_logic_vector(3 downto 0);
    
    enem_ready_to_start_rendering : in std_logic;
    enem_request_next_enemy : out std_logic;
    enem_enemy_to_render : in enemy_t;
    enem_enemy_valid : in std_logic;
    enem_render_done : in std_logic;

    -- to screen
    pixel_out : out pixel_t;
    pixel_valid : out std_logic
  );
end entity render_game;

architecture rtl of render_game is
  signal go_delayed : std_logic := '0';
  signal start : std_logic := '0';
  signal gpu_instruction : gpu_instruction_t := default_gpu_instruction;
  signal gpu_go : std_logic := '0';
  signal gpu_done : std_logic;

  signal lvl1_go : std_logic := '0';
  signal lvl1_gpu_instruction : gpu_instruction_t;
  signal lvl1_gpu_go : std_logic;
  signal lvl1_done : std_logic;

  signal plr_go : std_logic := '0';
  signal plr_gpu_instruction : gpu_instruction_t;
  signal plr_gpu_go : std_logic;
  signal plr_done : std_logic;

  signal item_go : std_logic := '0';
  signal item_gpu_instruction : gpu_instruction_t;
  signal item_gpu_go : std_logic;
  signal item_done : std_logic;

  signal enem_go : std_logic := '0';
  signal enem_gpu_instruction : gpu_instruction_t;
  signal enem_gpu_go : std_logic;
  signal enem_done : std_logic;


  -- mux needs time to switch. this bit is used to give it that time
  signal render_go_delay : std_logic := '0';

  type render_step_state_t is (idle, render_map, render_player, render_item, render_enemies); -- TODO: add more
  signal state : render_step_state_t := idle;

begin

  -- edge detection
  start_proc : process(clk)
  begin
    if rising_edge(clk) then
      go_delayed <= go;
      if go = '1' and go_delayed = '0' then
        start <= '1';
      else
        start <= '0';
      end if;
    end if;
  end process;

  state_proc : process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        state <= idle;
      else
        -- defaults
        lvl1_go <= '0';
        plr_go <= '0';
        -- only proceed with new cmd if previous one is done
        case state is
          when idle =>
            null;
          when render_map =>
            if lvl1_done = '1' then
              state <= render_player;
              render_go_delay <= '0';
            elsif render_go_delay = '0' then
              render_go_delay <= '1';
              lvl1_go <= '1'; -- this should only go high for one clock cycle
            end if;
          when render_player =>
            if plr_done = '1' then
              state <= render_item;
              render_go_delay <= '0';
            elsif render_go_delay = '0' then
              render_go_delay <= '1';
              plr_go <= '1'; -- this should only go high for one clock cycle
            end if;
          when render_item =>
            if item_done = '1' then
              state <= render_enemies;
              render_go_delay <= '0';
            elsif render_go_delay = '0' then
              render_go_delay <= '1';
              item_go <= '1'; -- this should only go high for one clock cycle
            end if;
          when render_enemies =>
            if enem_done = '1' then
              state <= idle;
              render_go_delay <= '0';
            elsif render_go_delay = '0' then
              render_go_delay <= '1';
              enem_go <= '1'; -- this should only go high for one clock cycle
            end if;
          when others => null;
        end case;

        if start = '1' then
          state <= render_map;
          render_go_delay <= '0';
        end if;
      end if;
    end if;
  end process;

  -- this process determines who has control over the gpu based on the current state
  mux_proc : process(state, lvl1_gpu_instruction, lvl1_gpu_go, plr_gpu_instruction, plr_gpu_go)
  begin
    case state is
      when idle =>
        gpu_go <= '0';
        gpu_instruction <= default_gpu_instruction;
      when render_map =>
        gpu_go <= lvl1_gpu_go;
        gpu_instruction <= lvl1_gpu_instruction;
      when render_player =>
        gpu_go <= plr_gpu_go;
        gpu_instruction <= plr_gpu_instruction;
      when render_item =>
        gpu_go <= item_gpu_go;
        gpu_instruction <= item_gpu_instruction;
      when render_enemies =>
        gpu_go <= enem_gpu_go;
        gpu_instruction <= enem_gpu_instruction;
      when others => null;
    end case;
  end process;

  gpu_inst : entity work.gpu
  port map(
    clk => clk,
    reset => reset,
    instruction => gpu_instruction,
    go => gpu_go,
    done => gpu_done,
    pixel_out => pixel_out,
    pixel_valid => pixel_valid
  );

  render_level1_inst : entity work.render_level1
  port map(
    clk => clk,
    reset => reset,
    go => lvl1_go,
    gpu_instruction => lvl1_gpu_instruction,
    gpu_go => lvl1_gpu_go,
    gpu_done => gpu_done,
    done => lvl1_done
  );

  render_player_inst : entity work.render_player
  port map(
    clk => clk,
    reset => reset,
    go => plr_go,
    player_x => player_x,
    player_y => player_y,
    player_hp => player_hp,
    player_flip => player_flip,
    gpu_instruction => plr_gpu_instruction,
    gpu_go => plr_gpu_go,
    gpu_done => gpu_done,
    done => plr_done
  );

  render_item_inst : entity work.render_item
  port map(
    clk => clk,
    reset => reset,
    go => item_go,
    item_out => item_in,
    itemx_out => unsigned(itemx_in),
    itemy_out => unsigned(itemy_in),
    gpu_instruction => item_gpu_instruction,
    gpu_go => item_gpu_go,
    gpu_done => gpu_done,
    done => item_done
  );

  render_enemies_inst : entity work.render_enemies
  port map(
    clk => clk,
    reset => reset,
    go => enem_go,

    ready_to_start_rendering => enem_ready_to_start_rendering,
    request_next_enemy => enem_request_next_enemy,
    enemy_to_render => enem_enemy_to_render,
    enemy_valid => enem_enemy_valid,
    render_done => enem_render_done,

    gpu_instruction => enem_gpu_instruction,
    gpu_go => enem_gpu_go,
    gpu_done => gpu_done,
    done => enem_done
  );

  

end architecture;