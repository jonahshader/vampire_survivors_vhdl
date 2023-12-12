library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.custom_types.all;
use ieee.math_real.log2;
use ieee.math_real.ceil;

entity enemy_state_rewrite is
  generic (
    ENEMY_COUNT : integer := 128
  );
  port (
    clk : in std_logic;
    reset : in std_logic;
    swapped : in std_logic; -- triggers computation

    -- from player
    player_x : in unsigned(9 downto 0);
    player_y : in unsigned(9 downto 0);

    -- render controls
    ready_to_start_rendering : out std_logic := '0';
    request_next_enemy : in std_logic;
    enemy_to_render : out enemy_t;
    enemy_valid : out std_logic;
    render_done : out std_logic -- goes high when last enemy is sent
  );
end enemy_state_rewrite;

architecture enemy_state_rewrite of enemy_state_rewrite is
  -- bram signals
  -- read ports
  signal we_a : boolean := false;
  signal enem_addr : unsigned(integer(ceil(log2(real(ENEMY_COUNT)))) - 1 downto 0) := (others => '0');
  signal din_a : std_logic_vector(ENEMY_BITS - 1 downto 0) := (others => '0');

  -- write ports
  signal dout_b : std_logic_vector(ENEMY_BITS - 1 downto 0) := (others => '0');
  
  type state_t is (idle, update_state, render_state);
  type memory_state_t is (idle, data_to_reg, send_data, wait_for_done, determine_new_addr);
  signal state : state_t := idle;
  signal mem_state : memory_state_t := idle;

  signal enemy_reg : enemy_t;
  signal updated_enemy : enemy_t;
  signal updated_enemy_valid : std_logic;
  signal enemy_valid_reg : std_logic := '0';

begin
  enemy_to_render <= enemy_reg;
  enemy_valid <= enemy_valid_reg;


  state_proc : process(clk)
    variable bit_count : integer := 0;
  begin
    if rising_edge(clk) then
      if reset = '1' then
        state <= idle;
        mem_state <= idle;
        we_a <= false;
        enem_addr <= (others => '0');
        din_a <= (others => '0');
        dout_b <= (others => '0');
        ready_to_start_rendering <= '0';
      else
        case state is 
          when idle =>
            ready_to_start_rendering <= '0';
            render_done <= '0';
            if swapped = '1' then
              state <= update_state;
            end if;
          when update_state =>
            case mem_state is
              when idle =>
                mem_state <= send_data;
              when send_data =>
                mem_state <= wait_for_done;
                bit_count := 0;
                enemy_reg.kind <= dout_b(enemy_reg.kind'length - 1 downto 0);
                bit_count := bit_count + enemy_reg.kind'length;
                enemy_reg.pos.x <= unsigned(dout_b(enemy_reg.pos.x'length + bit_count - 1 downto bit_count));
                bit_count := bit_count + enemy_reg.pos.x'length;
                enemy_reg.pos.y <= unsigned(dout_b(enemy_reg.pos.y'length + bit_count - 1 downto bit_count));
                bit_count := bit_count + enemy_reg.pos.y'length;
                enemy_reg.vel.x <= unsigned(dout_b(enemy_reg.vel.x'length + bit_count - 1 downto bit_count));
                bit_count := bit_count + enemy_reg.vel.x'length;
                enemy_reg.vel.y <= unsigned(dout_b(enemy_reg.vel.y'length + bit_count - 1 downto bit_count));
                bit_count := bit_count + enemy_reg.vel.y'length;
                enemy_reg.hp <= unsigned(dout_b(enemy_reg.hp'length + bit_count - 1 downto bit_count));
                bit_count := bit_count + enemy_reg.hp'length;
                -- this is a std_logic
                enemy_reg.valid <= dout_b(bit_count);
                bit_count := bit_count + 1;

                enemy_valid_reg <= '1'; -- notify enemy_update that it can start updating

              when wait_for_done =>
                enemy_valid_reg <= '0';
                if updated_enemy_valid = '1' then
                  mem_state <= determine_new_addr;
                  bit_count := 0;
                  din_a(updated_enemy.kind'length - 1 downto 0) <= std_logic_vector(updated_enemy.kind);
                  bit_count := bit_count + updated_enemy.kind'length;
                  din_a(updated_enemy.pos.x'length + bit_count - 1 downto bit_count) <= std_logic_vector(updated_enemy.pos.x);
                  bit_count := bit_count + updated_enemy.pos.x'length;
                  din_a(updated_enemy.pos.y'length + bit_count - 1 downto bit_count) <= std_logic_vector(updated_enemy.pos.y);
                  bit_count := bit_count + updated_enemy.pos.y'length;
                  din_a(updated_enemy.vel.x'length + bit_count - 1 downto bit_count) <= std_logic_vector(updated_enemy.vel.x);
                  bit_count := bit_count + updated_enemy.vel.x'length;
                  din_a(updated_enemy.vel.y'length + bit_count - 1 downto bit_count) <= std_logic_vector(updated_enemy.vel.y);
                  bit_count := bit_count + updated_enemy.vel.y'length;
                  din_a(updated_enemy.hp'length + bit_count - 1 downto bit_count) <= std_logic_vector(updated_enemy.hp);
                  bit_count := bit_count + updated_enemy.hp'length;
                  din_a(bit_count) <= updated_enemy.valid;
                  bit_count := bit_count + 1;

                  we_a <= true; -- write to memory

                end if;
              when determine_new_addr =>
                we_a <= false;
                mem_state <= idle;

                if enem_addr = ENEMY_COUNT - 1 then
                  state <= render_state;
                  enem_addr <= (others => '0');
                else
                  enem_addr <= enem_addr + to_unsigned(1, enem_addr'length);
                end if;
              when others =>
                null;
            end case;
          when render_state =>
            case mem_state is
              when idle =>
                mem_state <= data_to_reg;
              when data_to_reg =>
                -- grab data
                mem_state <= wait_for_done;
                bit_count := 0;
                enemy_reg.kind <= dout_b(enemy_reg.kind'length - 1 downto 0);
                bit_count := bit_count + enemy_reg.kind'length;
                enemy_reg.pos.x <= unsigned(dout_b(enemy_reg.pos.x'length + bit_count - 1 downto bit_count));
                bit_count := bit_count + enemy_reg.pos.x'length;
                enemy_reg.pos.y <= unsigned(dout_b(enemy_reg.pos.y'length + bit_count - 1 downto bit_count));
                bit_count := bit_count + enemy_reg.pos.y'length;
                enemy_reg.vel.x <= unsigned(dout_b(enemy_reg.vel.x'length + bit_count - 1 downto bit_count));
                bit_count := bit_count + enemy_reg.vel.x'length;
                enemy_reg.vel.y <= unsigned(dout_b(enemy_reg.vel.y'length + bit_count - 1 downto bit_count));
                bit_count := bit_count + enemy_reg.vel.y'length;
                enemy_reg.hp <= unsigned(dout_b(enemy_reg.hp'length + bit_count - 1 downto bit_count));
                bit_count := bit_count + enemy_reg.hp'length;
                enemy_reg.valid <= dout_b(bit_count);
                bit_count := bit_count + 1;

                ready_to_start_rendering <= '1';
              when wait_for_done =>
                -- wait until the renderer requests the next enemy
                if request_next_enemy = '1' then
                  mem_state <= determine_new_addr;
                  enemy_valid_reg <= '1'; -- essentially the go signal for gpu
                end if;
              when determine_new_addr =>
                enemy_valid_reg <= '0';
                if enem_addr = ENEMY_COUNT - 1 then
                  state <= idle;
                  mem_state <= idle;
                  render_done <= '1';
                  enem_addr <= (others => '0');
                else
                  enem_addr <= enem_addr + to_unsigned(1, enem_addr'length);
                end if;
              when others =>
                null;
            end case;
          when others =>
            null;
        end case;
      end if;
    end if;
  end process;

  enemy_bram : entity work.bram_sdp
  generic map (
    WIDTH => ENEMY_BITS,
    DEPTH => ENEMY_COUNT
  )
  port map (
    clk_a => clk,
    we_a => we_a,
    addr_a => enem_addr,
    din_a => din_a,
    clk_b => clk,
    en_b => true, -- always read
    addr_b => enem_addr, -- same address
    dout_b => dout_b
  );

  enemy_update : entity work.enemy_update_rewrite
  generic map (
    ENEMY_COUNT => ENEMY_COUNT
  )
  port map(
    clk => clk,
    reset => reset,
    swapped => swapped,
    player_x => player_x,
    player_y => player_y,
    enemy_in => enemy_reg,
    enemy_index => enem_addr,
    go => enemy_valid_reg,
    enemy_out => updated_enemy,
    done => updated_enemy_valid
  );


end enemy_state_rewrite;