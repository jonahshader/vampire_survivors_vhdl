library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.gpu_codes.all;
use work.custom_types.all;
use ieee.math_real.ceil;
use ieee.math_real.log2;

entity render_player is
  generic(
    HEALTH_MAX : integer := 256;
    HEALTH_RENDER_SCALE_POW : integer := 4;
    ARMOR_RENDER_SCALE_POW : integer := 4;
    BAR_THICKNESS : integer := 4;
    BAR_SPACING : integer := 1;
    PLAYER_WIDTH : integer := 24;
    PLAYER_HEIGHT : integer := 24
  );
  port(
    clk : in std_logic;
    reset : in std_logic;
    go : in std_logic;

    -- from gamestate
    player_x : in std_logic_vector(9 downto 0);
    player_y : in std_logic_vector(9 downto 0);
    player_hp : in std_logic_vector(7 downto 0);
    player_flip : in std_logic;
    -- to gpu
    gpu_instruction : out gpu_instruction_t;
    gpu_go : out std_logic;
    gpu_done : in std_logic;

    done : out std_logic
  );
end entity render_player;

architecture rtl of render_player is
  constant BAR_MAX_WIDTH : integer := integer(HEALTH_MAX / 2**HEALTH_RENDER_SCALE_POW);
  constant BAR_HALF_MAX_WIDTH : integer := integer(BAR_MAX_WIDTH / 2);
  constant PLAYER_WIDTH_HALF : integer := integer(PLAYER_WIDTH / 2);
  constant PLAYER_HEIGHT_HALF : integer := integer(PLAYER_HEIGHT / 2);

  signal gpu_instruction_reg : gpu_instruction_t := (
    renderer => rect,
    pos => default_translation,
    size => default_frame_coord,
    color => default_color,
    enum => (others => '0')
  );

  signal gpu_go_reg : std_logic := '0';
  signal done_reg : std_logic := '0';

  type state_t is (idle, r_player, r_health_bottom, r_health_top);
  signal state_reg : state_t := idle;

begin
  gpu_instruction <= gpu_instruction_reg;
  gpu_go <= gpu_go_reg;
  done <= done_reg;

  render_proc : process(clk)
    variable player_pos_signed : translation_t;
    variable player_hp_bottom_scaled : frame_coord_t;
    variable player_hp_top_scaled : frame_coord_t;
  begin
    player_pos_signed.x := signed(player_x);
    player_pos_signed.y := signed(player_y);

    -- subtract half size
    player_pos_signed.x := player_pos_signed.x - to_signed(PLAYER_WIDTH_HALF, player_pos_signed.x'length);
    player_pos_signed.y := player_pos_signed.y - to_signed(PLAYER_HEIGHT_HALF, player_pos_signed.y'length);

    player_hp_bottom_scaled := (
      x => to_unsigned(BAR_MAX_WIDTH, player_hp_bottom_scaled.x'length),
      y => to_unsigned(BAR_THICKNESS, player_hp_bottom_scaled.y'length)
    );

    player_hp_top_scaled := (
      x => unsigned('0' & player_hp),
      y => to_unsigned(BAR_THICKNESS, player_hp_top_scaled.y'length)
    );

    -- scale the health bar
    player_hp_top_scaled.x := shift_right(player_hp_top_scaled.x, HEALTH_RENDER_SCALE_POW);


    if rising_edge(clk) then
      if reset = '1' then
        state_reg <= idle;
        gpu_instruction_reg <= (
          renderer => rect,
          pos => default_translation,
          size => default_frame_coord,
          color => default_color,
          enum => (others => '0')
        );
        gpu_go_reg <= '0';
        done_reg <= '0';
      else
        gpu_go_reg <= '0';
        case state_reg is
          when idle =>
            done_reg <= '0';
            if go = '1' then
              -- render the player
              state_reg <= r_player;
              gpu_instruction_reg <= (
                renderer => rect,
                pos => player_pos_signed,
                size => (x => to_unsigned(PLAYER_WIDTH, gpu_instruction.size.x'length), y => to_unsigned(PLAYER_HEIGHT, gpu_instruction.size.y'length)),
                color => (r => to_unsigned(255, 4), g => to_unsigned(255, 4), b => to_unsigned(255, 4)),
                enum => (others => '0')
              );
              gpu_go_reg <= '1';

            end if;
          when r_player =>
            if gpu_done = '1' then
              state_reg <= r_health_bottom;
              -- render the bottom of the health bar black
              -- should be centered above the player, with BAR_SPACING pixels between
              -- since player is rendered centered, we just need to offset x by -(BAR_HALF_MAX_WIDTH)
              -- y is offset by -(PLAYER_HEIGHT_HALF + BAR_THICKNESS + BAR_SPACING)
              gpu_instruction_reg <= (
                renderer => rect,
                pos => (
                  x => signed(player_x) - to_signed(BAR_HALF_MAX_WIDTH, player_pos_signed.x'length),
                  y => signed(player_y) - to_signed(PLAYER_HEIGHT_HALF + BAR_THICKNESS + BAR_SPACING, player_pos_signed.y'length)
                ),
                size => player_hp_bottom_scaled,
                color => (r => to_unsigned(0, 4), g => to_unsigned(0, 4), b => to_unsigned(0, 4)),
                enum => (others => '0')
              );
              gpu_go_reg <= '1';
            end if;
          when r_health_bottom =>
            -- wait for health bottom to finish rendering
            if gpu_done = '1' then
              state_reg <= r_health_top;
              -- render the top of the health bar red
              -- basically the same as the bottom, but with a different color (and different size)
              gpu_instruction_reg <= (
                renderer => rect,
                pos => (
                  x => signed(player_x) - to_signed(BAR_HALF_MAX_WIDTH, player_pos_signed.x'length),
                  y => signed(player_y) - to_signed(PLAYER_HEIGHT_HALF + BAR_THICKNESS + BAR_SPACING, player_pos_signed.y'length)
                ),
                size => player_hp_top_scaled,
                color => (r => to_unsigned(255, 4), g => to_unsigned(0, 4), b => to_unsigned(0, 4)),
                enum => (others => '0')
              );
              gpu_go_reg <= '1';
            end if;

          when r_health_top =>
            -- wait for health top to finish rendering
            if gpu_done = '1' then
              state_reg <= idle;
              done_reg <= '1';
            end if;
          when others => null;
        end case;
      end if;
    end if;
  end process;
  

end architecture;