library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity inv_mng is
    port (
        clk190 : in STD_LOGIC; -- mclk
        -- character c1 and r1 (x,y)
        c1 : in STD_LOGIC_VECTOR(9 downto 0);
        r1 : in STD_LOGIC_VECTOR(9 downto 0);
        -- randomly generated item (x,y) need to add the random generator here
        x : in STD_LOGIC_VECTOR(9 downto 0);
        y : in STD_LOGIC_VECTOR(9 downto 0);
        -- randomly generated item
        item_out : in STD_LOGIC_VECTOR(2 downto 0); -- Update with Han's random generator
        
        -- registers to hold items and their level
        whip : out STD_LOGIC_VECTOR(3 downto 0);  -- Outputs for Whip
        garlic : out STD_LOGIC_VECTOR(3 downto 0);  -- Outputs for Garlic
        mage : out STD_LOGIC_VECTOR(3 downto 0);  -- Outputs for Mage
        armour : out STD_LOGIC_VECTOR(3 downto 0);  -- Outputs for Armour
        gloves : out STD_LOGIC_VECTOR(3 downto 0);  -- Outputs for Gloves
        wings : out STD_LOGIC_VECTOR(3 downto 0)  -- Outputs for Wings
    );
end inv_mng;

architecture inv_mng of inv_mng is
    signal whip_temp : STD_LOGIC_VECTOR(3 downto 0) := "0000";  -- Initialize to 4-bit "0000"
    signal garlic_temp : STD_LOGIC_VECTOR(3 downto 0) := "0000";  -- Initialize to 4-bit "0000"
    signal mage_temp : STD_LOGIC_VECTOR(3 downto 0) := "0000";  -- Initialize to 4-bit "0000"
    signal armour_temp : STD_LOGIC_VECTOR(3 downto 0) := "0000";  -- Initialize to 4-bit "0000"
    signal gloves_temp : STD_LOGIC_VECTOR(3 downto 0) := "0000";  -- Initialize to 4-bit "0000"
    signal wings_temp : STD_LOGIC_VECTOR(3 downto 0) := "0000";  -- Initialize to 4-bit "0000"
    
    -- Define binary constants for item levels
    constant ITEM_LEVEL_MAX : STD_LOGIC_VECTOR(3 downto 0) := "1010"; -- Binary 10
    
begin
    process(clk190) -- Add clk190 to sensitivity list
    begin
        if rising_edge(clk190) then -- Process on the rising edge of clk190
            -- Initialize all registers to '0000' (no items)
            whip <= "0000";
            garlic <= "0000";
            mage <= "0000";
            armour <= "0000";
            gloves <= "0000";
            wings <= "0000";

            -- Check if the current position matches x and y

            -- Definition of items
                -- 000 - No Item
                -- 001 - Whip (basic attack)
                -- 010 - Garlic (radius shield)
                -- 011 - Mage (will determine later)
                -- 100 - Armour (armour %)
                -- 101 - Gloves (attack speed)
                -- 111 - Wings (movement speed)

            if (c1 = x and r1 = y) then -- rectangle collider
                case item_out is
                    when "001" =>   --  whip
                        if (whip_temp < ITEM_LEVEL_MAX) then
                            whip_temp <= whip_temp + 1;
                        end if;
                    when "010" =>   -- 010 is Garlic
                        if (garlic_temp < ITEM_LEVEL_MAX) then
                            garlic_temp <= garlic_temp + 1;
                        end if;
                    when "011" =>   -- Mage
                        if (mage_temp < ITEM_LEVEL_MAX) then
                            mage_temp <= mage_temp + 1;
                        end if;
                    when "100" =>   -- Armour
                        if (armour_temp < ITEM_LEVEL_MAX) then
                            armour_temp <= armour_temp + 1;
                        end if;
                    when "101" =>   -- Gloves
                        if (gloves_temp < ITEM_LEVEL_MAX) then
                            gloves_temp <= gloves_temp + 1;
                        end if;
                    when "111" =>   -- Wings
                        if (wings_temp < ITEM_LEVEL_MAX) then
                            wings_temp <= wings_temp + 1;
                        end if;
                    
                    when others =>
                        null; -- No other items
                end case;
            end if;
        end if;
    end process;
    
    -- Assign the temporary signals to outputs
    whip <= whip_temp;
    garlic <= garlic_temp;
    mage <= mage_temp;
    armour <= armour_temp;
    gloves <= gloves_temp;
    wings <= wings_temp;
end inv_mng;
