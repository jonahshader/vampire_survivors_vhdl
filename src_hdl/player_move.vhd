library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity player_move is
  port
  (
    clk : in std_logic;
    clr : in std_logic;

    swapped : in std_logic;

    left  : in std_logic;
    right : in std_logic;
    up    : in std_logic;
    down  : in std_logic;
    speed : in unsigned(3 downto 0);

    flipped  : out std_logic;
    player_x : out std_logic_vector(9 downto 0);
    player_y : out std_logic_vector(9 downto 0)
  );
end player_move;

architecture player_move of player_move is
  constant player_x_spawn : integer := 160; -- center position 320
  constant player_y_spawn : integer := 90; -- center position 180

  signal player_x_reg : unsigned(9 downto 0) := to_unsigned(player_x_spawn, 10);
  signal player_y_reg : unsigned(9 downto 0) := to_unsigned(player_y_spawn, 10);

begin
  move_proc : process (clk)
  begin
    if rising_edge(clk) then
      if clr = '1' then
        player_x_reg <= to_unsigned(player_x_spawn, 10);
        player_y_reg <= to_unsigned(player_y_spawn, 10);
      elsif swapped = '1' then
        if left = '1' then
          player_x_reg <= player_x_reg - speed;
          flipped      <= '1';
        elsif right = '1' then
          player_x_reg <= player_x_reg + speed;
          flipped      <= '0';
        end if;
        if up = '1' then
          player_y_reg <= player_y_reg - speed;
        elsif down = '1' then
          player_y_reg <= player_y_reg + speed;
        end if;
      end if;
    end if;
  end process;

  player_x <= std_logic_vector(player_x_reg);
  player_y <= std_logic_vector(player_y_reg);

end player_move;