library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity gamestate is
    port ( 
        -- from screen
        mclk : in STD_LOGIC;
        clr : in STD_LOGIC;
        -- Keyboard Input
        PS2C : in STD_LOGIC;
        PS2D : in STD_LOGIC;
        -- Buttons
        BTNU : in STD_LOGIC;
        BTNR : in STD_LOGIC;
        BTND : in STD_LOGIC;
        BTNL : in STD_LOGIC;
        BTNC : in STD_LOGIC;
        -- Item Generator: Definition of items
                -- 000 - No Item
                -- 001 - Whip (basic attack)
                -- 010 - Garlic (radius shield)
                -- 011 - Mage (will determine later)
                -- 100 - Armour (armour %)
                -- 101 - Gloves (attack speed)
                -- 111 - Wings (movement speed)
        swapped : in std_logic; -- screen
        item_out : out STD_LOGIC_VECTOR(2 downto 0);
        itemx_out : out STD_LOGIC_VECTOR(7 downto 0);
        itemy_out : out STD_LOGIC_VECTOR(6 downto 0);

        --  character movement (needs to go to renderer)
        player_y : out std_logic_vector (9 downto 0);
        player_x : out std_logic_vector (9 downto 0); 
        flipped : out std_logic; 
        -- hp out from player_stat
        player_hp : out STD_LOGIC_VECTOR(7 downto 0);

        -- inventory management, outputs what item we will render and with what level (if needed)
        whip : out STD_LOGIC_VECTOR(3 downto 0);  -- Outputs for Whip
        garlic : out STD_LOGIC_VECTOR(3 downto 0);  -- Outputs for Garlic
        mage : out STD_LOGIC_VECTOR(3 downto 0);  -- Outputs for Mage
        armour : out STD_LOGIC_VECTOR(3 downto 0);  -- Outputs for Armour
        gloves : out STD_LOGIC_VECTOR(3 downto 0);  -- Outputs for Gloves
        wings : out STD_LOGIC_VECTOR(3 downto 0)  -- Outputs for Wings
        
        -- attacks from auto_atk.vhd, this will be for whip, mage, garlic attacks.
    );
end gamestate;

architecture gamestate_architecture of gamestate is
    signal clk40: std_logic;

    -- item x and y random generated numbers
    signal itemx, itemy : STD_LOGIC_VECTOR(15 downto 0);
    
    -- keyboard
    signal press_code, down_code, release_code: std_logic_vector(7 downto 0);
    
    -- keybinds
    signal mvm_spd : std_logic_vector(3 downto 0);
   
    --player_stat
    signal armr_perc : STD_LOGIC_VECTOR(3 downto 0); 
    signal attk_spd : STD_LOGIC_VECTOR(3 downto 0);

    -- TODO: do something with these
    signal radius_garlic : STD_LOGIC_VECTOR(9 downto 0);
    signal linear_whip : STD_LOGIC_VECTOR(9 downto 0);

    -- input sync stuff
    signal kb_left, kb_right, kb_up, kb_down, kb_enter : std_logic;
    signal left, right, up, down, enter : std_logic;
    signal left_vec, right_vec, up_vec, down_vec, enter_vec : std_logic_vector(1 downto 0);
    
begin

    -- input sync stuff
    left_vec(0) <= kb_left;
    right_vec(0) <= kb_right;
    up_vec(0) <= kb_up;
    down_vec(0) <= kb_down;
    enter_vec(0) <= kb_enter;

    left_vec(1) <= BTNL;
    right_vec(1) <= BTNR;
    up_vec(1) <= BTNU;
    down_vec(1) <= BTND;
    enter_vec(1) <= BTNC;

    -- OK
    U1: entity work.clkdiv
        port map (
            mclk => mclk,
            clr => clr,
            clk40 => clk40
        );
    -- OK
    U2: entity work.keyboard_ctrl
        port map (
            clk40 => clk40,
            clr => clr,
            PS2C => PS2C,
            PS2D => PS2D,
            press_code => press_code,
            down_code => down_code,
            release_code => release_code
        );
    -- OK
    U3: entity work.keybinds
        port map (
            clk => mclk,
            clr => clr,
            press_code => press_code,
            release_code => release_code,
            left => kb_left,
            right => kb_right,
            up => kb_up,
            down => kb_down,
            enter => kb_enter
        );
    U3a: entity work.player_move
        port map (
            clk => mclk,
            clr => clr,
            swapped => swapped,
            flipped => flipped,
            left => left,
            right => right,
            up => up,
            down => down,
            speed => to_unsigned(1,4), -- TODO: Connect speed signal,
            player_x => player_x,
            player_y => player_y
        );
    input_sync_inst : entity work.input_sync
        generic map(
            CONTROLLERS => 2
        )
        port map (
            clk => mclk,
            left_in => left_vec,
            right_in => right_vec,
            up_in => up_vec,
            down_in => down_vec,
            select_in => enter_vec,
            left_out => left,
            right_out => right,
            up_out => up,
            down_out => down,
            select_out => enter
        );
    -- OK, getting updated to output the item_out and x and y
    U5: entity work.item_gen_rand
        port map (
            clk => mclk,
            clr => clr,
            item_out => item_out,
            itemx_out => itemx_out,
            itemy_out => itemy_out,
            swapped => swapped
        );
    -- OK, expect for the rectangle collider
    U6: entity work.inv_mng
        port map (
            clk => mclk,
            clr => clr,
            player_y => player_y,
            player_x => player_x,
            -- from item_gen, the item_id and item x,y
            itemx_out => itemx_out,
            itemy_out => itemy_out,
            item_out => item_out,
            --item and the level
            whip => whip,
            garlic => garlic,
            mage => mage,
            armour => armour,
            gloves => gloves,
            wings => wings
        );
    -- Need enemy X and Y
    U7: entity work.player_stat
        port map (
            clk => mclk,
            armour => armour,
            gloves => gloves,
            wings => wings,
            -- enemy x1, y1
            x1 => (others => '0'), -- TODO: Connect x1 signal,
            y1 => (others => '0'), -- TODO: Connect y1 signal,
            -- player x,y (player_y,player_x)
            player_y => player_y,
            player_x => player_x,
            -- player stats
            attk_spd => attk_spd,
            mvm_spd => mvm_spd,
            armr_perc => armr_perc,
            -- hp, this is also where damage is calculated
            hp => player_hp
        );
    -- this needs to be updated with Han's code, 
    -- U8: entity work.enem_gen
    --     port map (
    --         clk => mclk,
    --         player_y => player_y,
    --         player_x => player_x,
    --         x => (others => '0'), -- TODO: Connect x signal,
    --         y => (others => '0'), -- TODO: Connect y signal,
    --         x1 => x1,
    --         y1 => y1
    --     );
    
    auto_atk_inst : entity work.auto_atk    -- this needs to be worked on
        port map (
            clk => mclk,
            player_y => player_y,
            player_x => player_x,
            attk_spd => attk_spd,
            whip => whip,
            garlic => garlic,
            mage => mage,
            radius_garlic => radius_garlic,
            rect_whip => linear_whip
        );
end gamestate_architecture;