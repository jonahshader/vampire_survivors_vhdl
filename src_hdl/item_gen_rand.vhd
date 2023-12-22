library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;

-- Definition of items
-- 000 - No Item
-- 001 - Whip (basic attack)
-- 010 - Garlic (radius shield)
-- 011 - Mage (will determine later)
-- 100 - Armour (armour %)
-- 101 - Gloves (attack speed)
-- 111 - Wings (movement speed)

entity item_gen_rand is
  port
  (
    clk       : in std_logic; -- Clock input
    clr       : in std_logic; -- Reset input
    swapped   : in std_logic; -- from screen
    item_out  : out std_logic_vector(2 downto 0) := "000"; -- 3-bit random output
    itemx_out : out std_logic_vector(7 downto 0) := "00000000"; -- 8-bit random output (0 to 255)
    itemy_out : out std_logic_vector(6 downto 0) := "0000000" -- 7-bit random output (0 to 127)
  );
end item_gen_rand;

architecture Behavioral of item_gen_rand is
  constant spawn_interval : integer := 900; -- 15 seconds

  signal spawn_timer : std_logic_vector(9 downto 0) := (others => '0');

  -- connects to the rng
  signal random_xy   : std_logic_vector(15 downto 0);
  signal random_item : std_logic_vector(15 downto 0);

begin
  counter_proc : process (clk)
  begin
    if rising_edge(clk) and swapped = '1' then
      -- if this fails, import numeric_std
      if spawn_timer = std_logic_vector(to_unsigned(spawn_interval - 1, spawn_timer'length)) then
        -- if spawn_timer = std_logic_vector(spawn_interval - 1) then
        spawn_timer <= (others => '0');
        -- select random item
        item_out  <= random_item(2 downto 0);
        itemx_out <= random_xy(15 downto 8); -- 8 bits
        itemy_out <= random_xy(7 downto 1); -- only 7 bits
      else
        spawn_timer <= spawn_timer + 1;
      end if;
    end if;
  end process;

  -- Instantiate the Random Number Generator for item pos
  rng1 : entity work.RandomNumberGenerator
    generic
    map (
    seed => "0010001000110000" -- 16-bit seed
    )
    port map
    (
      clk      => clk,
      rst      => clr,
      rand_out => random_xy
    );

  -- Instantiate the Random Number Generator for item type
  rng2 : entity work.RandomNumberGenerator
    generic
    map (
    seed => "0101111000011111" -- 16-bit seed
    )
    port
    map (
    clk      => clk,
    rst      => clr,
    rand_out => random_item
    );

end Behavioral;