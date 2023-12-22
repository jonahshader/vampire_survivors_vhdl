-- binds keys from keyboard and adds functionality
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_ARITH.all;

entity keybinds is
  port
  (
    clk : in std_logic;
    clr : in std_logic;

    press_code   : in std_logic_vector(7 downto 0);
    release_code : in std_logic_vector(7 downto 0);

    left  : out std_logic;
    right : out std_logic;
    up    : out std_logic;
    down  : out std_logic;
    enter : out std_logic
  );
end keybinds;

architecture keybinds of keybinds is
  -- movement keys
  constant W_key : std_logic_vector(7 downto 0) := X"1D";
  constant A_key : std_logic_vector(7 downto 0) := X"1C";
  constant S_key : std_logic_vector(7 downto 0) := X"1B";
  constant D_key : std_logic_vector(7 downto 0) := X"23";

  -- action keys
  constant ESC_key : std_logic_vector(7 downto 0) := X"76"; -- Pause Game
  constant SPC_key : std_logic_vector(7 downto 0) := X"29"; -- Select menu

  signal w, a, s, d, space : std_logic := '0';

begin
  code_to_key : process (clk)
  begin
    if rising_edge(clk) then
      if clr = '1' then
        w <= '0';
        a <= '0';
        s <= '0';
        d <= '0';
      else
        case press_code is
          when W_key =>
            w <= '1';
          when A_key =>
            a <= '1';
          when S_key =>
            s <= '1';
          when D_key =>
            d <= '1';
          when SPC_key =>
            space <= '1';
          when others =>
            null;
        end case;
        case release_code is
          when W_key =>
            w <= '0';
          when A_key =>
            a <= '0';
          when S_key =>
            s <= '0';
          when D_key =>
            d <= '0';
          when SPC_key =>
            space <= '0';
          when others =>
            null;
        end case;
      end if;
    end if;
  end process;

  left  <= a;
  right <= d;
  up    <= w;
  down  <= s;
  enter <= space;
end keybinds;