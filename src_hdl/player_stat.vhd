library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity player_stat is
    port (
        clk : in STD_LOGIC; -- Clock input
        --input from the inv_mng
        armour : in STD_LOGIC_VECTOR(3 downto 0);
        gloves : in STD_LOGIC_VECTOR(3 downto 0);
        wings : in STD_LOGIC_VECTOR(3 downto 0);
        --enemy x and y positions (will change with clk)
        x1 : in STD_LOGIC_VECTOR(9 downto 0);
        y1 : in STD_LOGIC_VECTOR(9 downto 0);
        --player c1 and r1 (calculated from 
        player_y : in STD_LOGIC_VECTOR(9 downto 0);
        player_x : in STD_LOGIC_VECTOR(9 downto 0);
        --item and modifers
        attk_spd : out STD_LOGIC_VECTOR(3 downto 0);
        mvm_spd : out STD_LOGIC_VECTOR(3 downto 0);
        armr_perc : out STD_LOGIC_VECTOR(3 downto 0); -- binary to decimal conversaion
        --hp
        hp : out STD_LOGIC_VECTOR(7 downto 0)
    );
end player_stat;

architecture player_stat of player_stat is
    signal damage : STD_LOGIC_VECTOR(7 downto 0) := "00000000"; -- Initialize damage as 0, can use this for general damage amount
    --modifiers for items
    constant armr_modifier : STD_LOGIC_VECTOR(3 downto 0) := "1010"; -- Binary 10
    constant attk_spd_modifier : STD_LOGIC_VECTOR(3 downto 0) := "0010"; -- Binary 2
    constant mvm_spd_modifier : STD_LOGIC_VECTOR(3 downto 0) := "0010"; -- Binary 2
    --temp calcs
    signal armr_perc_temp : STD_LOGIC_VECTOR(7 downto 0) := (others => '0'); -- Initialize armr_perc_temp as 0
    signal attk_spd_temp : STD_LOGIC_VECTOR(7 downto 0) := (others => '0'); -- Initialize attk_spd_temp as 0
    signal mvm_spd_temp : STD_LOGIC_VECTOR(7 downto 0) := (others => '0'); -- Initialize mvm_spd_temp as 0
    --hp
    signal hp_temp : STD_LOGIC_VECTOR(7 downto 0) := "01100100"; -- Initialize hp_temp as binary 100

begin
    process(clk) -- Add clk to sensitivity list
    begin
        if rising_edge(clk) then -- Process on the rising edge of clk
            -- armour adds armor percentage
            -- gloves add attack speed
            -- wings add movement speed
            -- TODO: this logic doesn't make sense...
            armr_perc_temp <= armour * armr_modifier;
            attk_spd_temp <= gloves * attk_spd_modifier;
            mvm_spd_temp <= wings * mvm_spd_modifier;

            -- Damage calculation (send this to automate attack)
            if x1 = player_x and y1 = player_y then -- rectangle collider
                if armour > "0000" then
                    armr_perc_temp <= armr_perc_temp - "0101"; -- Subtract 5 from armour, can change this after for damage amount
                else
                    hp_temp <= hp_temp - "00000101"; -- Subtract 5 from hp
                end if;
            end if;
        end if;
    end process;

    -- Output results
    armr_perc <= armr_perc_temp(3 downto 0);
    attk_spd <= attk_spd_temp(3 downto 0);
    mvm_spd <= mvm_spd_temp(3 downto 0);
    hp <= hp_temp;
end player_stat;
