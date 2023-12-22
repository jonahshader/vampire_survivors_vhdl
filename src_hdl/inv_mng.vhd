library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity inv_mng is
  port
  (
    clk : in std_logic; -- mclk
    clr : in std_logic; -- clr
    -- character position
    player_y : in std_logic_vector(9 downto 0); -- player coords
    player_x : in std_logic_vector(9 downto 0);
    -- item x,y
    itemx_out : in std_logic_vector(7 downto 0);
    itemy_out : in std_logic_vector(6 downto 0);
    item_out  : in std_logic_vector(2 downto 0); -- Update with Han's random generator

    -- registers to hold items and their level
    whip   : out std_logic_vector(3 downto 0); -- Outputs for Whip
    garlic : out std_logic_vector(3 downto 0); -- Outputs for Garlic
    mage   : out std_logic_vector(3 downto 0); -- Outputs for Mage
    armour : out std_logic_vector(3 downto 0); -- Outputs for Armour
    gloves : out std_logic_vector(3 downto 0); -- Outputs for Gloves
    wings  : out std_logic_vector(3 downto 0) -- Outputs for Wings
  );
end inv_mng;

architecture inv_mng of inv_mng is
  signal whip_reg   : std_logic_vector(3 downto 0) := "0000"; -- Initialize to 4-bit "0000"
  signal garlic_reg : std_logic_vector(3 downto 0) := "0000"; -- Initialize to 4-bit "0000"
  signal mage_reg   : std_logic_vector(3 downto 0) := "0000"; -- Initialize to 4-bit "0000"
  signal armour_reg : std_logic_vector(3 downto 0) := "0000"; -- Initialize to 4-bit "0000"
  signal gloves_reg : std_logic_vector(3 downto 0) := "0000"; -- Initialize to 4-bit "0000"
  signal wings_reg  : std_logic_vector(3 downto 0) := "0000"; -- Initialize to 4-bit "0000"

  -- Define binary constants for item levels
  constant ITEM_LEVEL_MAX : std_logic_vector(3 downto 0) := "1010"; -- Binary 10

begin
  process (clk) -- Add clk to sensitivity list
  begin
    if rising_edge(clk) then -- 
      -- Initialize all registers to '0000' (no items)
      if clr = '1' then
        whip_reg   <= "0000";
        garlic_reg <= "0000";
        mage_reg   <= "0000";
        armour_reg <= "0000";
        gloves_reg <= "0000";
        wings_reg  <= "0000";
      else
        -- Check if the current position matches x and y

        -- Definition of items
        -- 000 - No Item
        -- 001 - Whip (basic attack)
        -- 010 - Garlic (radius shield)
        -- 011 - Mage (will determine later)
        -- 100 - Armour (armour %)
        -- 101 - Gloves (attack speed)
        -- 111 - Wings (movement speed)

        if (player_x = itemx_out and player_y = itemy_out) then -- this needs to be changed into the rectanbgle collider
          case item_out is
            when "001" => --  Whip
              if (whip_reg < ITEM_LEVEL_MAX) then
                whip_reg <= whip_reg + 1;
              end if;
            when "010" => -- Garlic
              if (garlic_reg < ITEM_LEVEL_MAX) then
                garlic_reg <= garlic_reg + 1;
              end if;
            when "011" => -- Mage
              if (mage_reg < ITEM_LEVEL_MAX) then
                mage_reg <= mage_reg + 1;
              end if;
            when "100" => -- Armour
              if (armour_reg < ITEM_LEVEL_MAX) then
                armour_reg <= armour_reg + 1;
              end if;
            when "101" => -- Gloves
              if (gloves_reg < ITEM_LEVEL_MAX) then
                gloves_reg <= gloves_reg + 1;
              end if;
            when "111" => -- Wings
              if (wings_reg < ITEM_LEVEL_MAX) then
                wings_reg <= wings_reg + 1;
              end if;

            when others =>
              null; -- No other items
          end case;
        end if;
      end if;
    end if;
  end process;

  -- Assign the temporary signals to outputs
  whip   <= whip_reg;
  garlic <= garlic_reg;
  mage   <= mage_reg;
  armour <= armour_reg;
  gloves <= gloves_reg;
  wings  <= wings_reg;
end inv_mng;