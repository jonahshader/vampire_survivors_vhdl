library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.custom_types.all;
use ieee.math_real.log2;
use ieee.math_real.ceil;

entity enemy_update_rewrite is
  generic (
    ENEMY_COUNT : integer := 128;
    SPAWN_PERIOD : integer := 40
  );
  port (
    clk : in std_logic;
    reset : in std_logic;
    swapped : in std_logic;

    -- from player
    player_x : in unsigned(9 downto 0);
    player_y : in unsigned(9 downto 0);

    -- for updating
    enemy_in : in enemy_t;
    enemy_index : in unsigned(integer(ceil(log2(real(ENEMY_COUNT)))) - 1 downto 0);
    go : in std_logic;
    enemy_out : out enemy_t;
    done : out std_logic := '0'
  );
end enemy_update_rewrite;

architecture enemy_update_rewrite of enemy_update_rewrite is
  -- going from idle to update will read the enemy_in
  -- going from update to idle will write the enemy_out

  signal enemy_reg : enemy_t;
  signal enemy_index_reg : unsigned(integer(ceil(log2(real(ENEMY_COUNT)))) - 1 downto 0);
  signal spawn_index : unsigned(integer(ceil(log2(real(ENEMY_COUNT)))) - 1 downto 0) := (others => '0');
  signal spawn_timer : unsigned(15 downto 0) := (others => '0');
  signal spawn_queued : std_logic := '0';

  signal x_rand, y_rand, cardinal_rand : std_logic_vector(15 downto 0);

  type state_t is (idle, update);
  signal state : state_t := idle;

begin

  enemy_out <= enemy_reg;

  state_proc : process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        state <= idle;
        spawn_index <= (others => '0');
        spawn_timer <= (others => '0');
      else
        -- update spawn timer stuff
        if swapped = '1' then
          if spawn_timer = SPAWN_PERIOD - 1 then
            spawn_queued <= '1';
            spawn_timer <= (others => '0');
          else
            spawn_timer <= spawn_timer + to_unsigned(1, spawn_timer'length);
          end if;
        end if;

        -- update state stuff
        case state is
          when idle =>
            done <= '0';
            if go = '1' then
              state <= update;
              enemy_reg <= enemy_in;
              enemy_index_reg <= enemy_index;
            end if;
          when update =>
          done <= '1';
            if spawn_queued = '1' and enemy_reg.valid = '0' and spawn_index = enemy_index_reg then
              -- spawn the enemy (make it valid)
              enemy_reg.valid <= '1';
              spawn_queued <= '0';

              -- determine the spawn location
              case cardinal_rand(1 downto 0) is
                when "00" => -- north
                  -- x is random 8 bit
                  -- y is 0
                  enemy_reg.pos.x <= to_unsigned(0, enemy_reg.pos.x'length);
                  enemy_reg.pos.x(7 downto 0) <= unsigned(x_rand(7 downto 0));
                  enemy_reg.pos.y <= to_unsigned(0, enemy_reg.pos.y'length);
                when "01" => -- south
                  -- x is random 8 bit
                  -- y is 160
                  enemy_reg.pos.x <= to_unsigned(0, enemy_reg.pos.x'length);
                  enemy_reg.pos.x(7 downto 0) <= unsigned(x_rand(7 downto 0));
                  enemy_reg.pos.y <= to_unsigned(160, enemy_reg.pos.y'length);
                when "10" => -- east
                  -- x is 320
                  -- y is random 7 bit
                  enemy_reg.pos.x <= to_unsigned(320, enemy_reg.pos.x'length);
                  enemy_reg.pos.y <= to_unsigned(0, enemy_reg.pos.y'length);
                  enemy_reg.pos.y(6 downto 0) <= unsigned(y_rand(6 downto 0));
                when "11" => -- west
                  -- x is 0
                  -- y is random 7 bit
                  enemy_reg.pos.x <= to_unsigned(0, enemy_reg.pos.x'length);
                  enemy_reg.pos.y <= to_unsigned(0, enemy_reg.pos.y'length);
                  enemy_reg.pos.y(6 downto 0) <= unsigned(y_rand(6 downto 0));
                when others =>
                  null;
              end case;
            else -- player is already valid
              -- update the position based on player pos instead of velocity
              if enemy_reg.pos.x < player_x then
                enemy_reg.pos.x <= enemy_reg.pos.x + enemy_reg.vel.x;
              elsif enemy_reg.pos.x > player_x then
                enemy_reg.pos.x <= enemy_reg.pos.x - enemy_reg.vel.x;
              end if;

              if enemy_reg.pos.y < player_y then
                enemy_reg.pos.y <= enemy_reg.pos.y + enemy_reg.vel.y;
              elsif enemy_reg.pos.y > player_y then
                enemy_reg.pos.y <= enemy_reg.pos.y - enemy_reg.vel.y;
              end if;
            end if;
          when others =>
            null;
        end case;
      end if;
    end if;
  end process;


  -- create some rng
  rng1 : entity work.RandomNumberGenerator
  generic map (
    seed => "0011111000010101"
  )
  port map (
    clk => clk,
    rst => reset,
    rand_out => x_rand
  );

  rng2 : entity work.RandomNumberGenerator
  generic map(
    seed => "1011110100001101"
  )
  port map (
    clk => clk,
    rst => reset,
    rand_out => y_rand
  );

  rng3 : entity work.RandomNumberGenerator
  generic map(
    seed => "0000111100010001"
  )
  port map (
    clk => clk,
    rst => reset,
    rand_out => cardinal_rand
  );

end enemy_update_rewrite;