library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.gamestate_comps.all;

entity gamestate is
    port (
        mclk : in STD_LOGIC;
        clr : in STD_LOGIC;
        -- gamestate takes in keyboard inputs
        PS2C : in STD_LOGIC;
        PS2D : in STD_LOGIC;
        
        -- item gen, read by the GPU (based on the output, renders a different item)
        item_out : out STD_LOGIC_VECTOR (2 downto 0);
        -- item x and y

        --  character movement (needs to go to renderer)
        c1 : out std_logic_vector (9 downto 0);
        r1 : out std_logic_vector (9 downto 0);
        flip : out std_logic;
        -- type sprite (constant)
        
        -- inventory management, outputs what item we will render and with what level (if needed)
        whip : out STD_LOGIC_VECTOR(3 downto 0);  -- Outputs for Whip
        garlic : out STD_LOGIC_VECTOR(3 downto 0);  -- Outputs for Garlic
        mage : out STD_LOGIC_VECTOR(3 downto 0);  -- Outputs for Mage
        armour : out STD_LOGIC_VECTOR(3 downto 0);  -- Outputs for Armour
        gloves : out STD_LOGIC_VECTOR(3 downto 0);  -- Outputs for Gloves
        wings : out STD_LOGIC_VECTOR(3 downto 0);  -- Outputs for Wings
        
        -- hp out from player_stat
        hp : out STD_LOGIC_VECTOR(7 downto 0)

    );
end gamestate;

architecture gamestate_architecture of gamestate is
    signal clk190, clk40: std_logic;
    
    -- keyboard
    signal keyval1, keyval2, keyval3: std_logic_vector(7 downto 0);
    
    -- keybinds
    signal mvm_spd : std_logic_vector(3 downto 0);
   
    --player_stat
    signal armr_perc : STD_LOGIC_VECTOR(3 downto 0); 
    signal attk_spd : STD_LOGIC_VECTOR(3 downto 0); 
    
begin
    -- OK, can use the global clkdiv, since we'll have one for screen and all.
    U1: clkdiv
        port map (
            mclk => mclk,
            clr => clr,
            clk190 => clk190,
            clk40 => clk40
        );
    -- OK, stays within gamestate
    U2: keyboard_ctrl
        port map (
            clk40 => clk40,
            clr => clr,
            PS2C => PS2C,
            PS2D => PS2D,
            keyval1 => keyval1,
            keyval2 => keyval2,
            keyval3 => keyval3
        );
    -- OK, stays within gamestate
    U3: keybinds
        port map (
            clk190 => clk190,
            clr => clr,
            keyval2 => keyval2,
            flip => flip,
            c1 => c1,
            r1 => r1,
            --ld => ld, was using this to test output for keybinds.
            mvm_spd => mvm_spd 
        );
    -- U4: random number generator
    
    -- within gamestate, will report out to GPU to render the different items
    U5: item_gen
        port map (
            clk190 => clk190,
            clr => clr,
            item_out => item_out
        );
    
    U6: inv_mng
        port map (
            clk190 => clk190,
            c1 => c1,
            r1 => r1,
            -- need to get the other random number generator, this is for the item to be checked if player is at the same x,y
            x => -- connect to enemy x signal,
            y => -- connect to enemy y signal,
            --item out
            item_out => item_out,
            --items and level
            whip => whip,
            garlic => garlic,
            mage => mage,
            armour => armour,
            gloves => gloves,
            wings => wings
        );
    
    U7: player_stat
        port map (
            clk190 => clk190,
            armour => armour,
            gloves => gloves,
            wings => wings,
            -- enemy x1, y1
            x1 => -- Connect x1 signal,
            y1 => -- Connect y1 signal,
            -- player x,y (c1,r1)
            c1 => c1,
            r1 => r1,
            
            -- from player stat this goes into other logics (does not need to go out of gamestate)
            attk_spd => attk_spd,
            mvm_spd => mvm_spd,
            armr_perc => armr_perc,
            -- hp will be outputted out of game state to display
            hp => hp
        );
    
    U8: enem_gen
        port map (
            clk190 => clk190,
            c1 => c1,
            r1 => r1,
            x => -- Connect x signal,
            y => -- Connect y signal,
            x1 => x1,
            y1 => y1
        );
    
    U8: auto_atk
        port map (
            clk190 => clk190,
            c1 => c1,
            r1 => r1,
            attk_spd => attk_spd,
            whip => whip,
            garlic => garlic,
            mage => mage,
            radius_garlic => radius_garlic,
            linear_whip => linear_whip
        );
    
end gamestate_architecture;
