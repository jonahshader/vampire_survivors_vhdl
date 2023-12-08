library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.gamestate_comps.all;

entity gamestate is
    port (
        mclk : in STD_LOGIC;
        clr : in STD_LOGIC;
        -- gamestate takes in keyboard inputs
        PS2C : in STD_LOGIC;
        PS2D : in STD_LOGIC
        
        --  character movement (needs to go to renderer)
        -- c1, r1,flip
        
        -- inventory management
        -- items output (so that they can be rendered.
        
        -- enemy location
        -- x1, y1 will show, need to add a flip to allow sprites to flip left and right
        
        -- autoattack
        -- need to output the attack styles to be rendered by the GPU
    );
end gamestate;

architecture gamestate_architecture of gamestate is
    -- Declare signals or variables here

begin
    U1: clkdiv
        port map (
            mclk => clk,
            clr => rst,
            clk190 => clk190,
            clk40 => clk40
        );
    
    U2: keyboard_ctrl
        port map (
            clk40 => clk40,
            clr => rst,
            PS2C => -- Connect PS2C signal,
            PS2D => -- Connect PS2D signal,
            keyval1 => keyval1,
            keyval2 => keyval2,
            keyval3 => keyval3
        );
    
    U3: keybinds
        port map (
            clk190 => clk190,
            clr => rst,
            keyval2 => keyval2,
            flip => flip,
            c1 => c1,
            r1 => r1,
            ld => ld,
            mvm_spd => -- 
        );
    -- U4: random number generator
    U5: item_gen
        port map (
            clk190 => clk190,
            clr => rst,
            item_out => item_out
        );
    
    U6: inv_mng
        port map (
            clk190 => clk190,
            c1 => c1,
            r1 => r1,
            x => -- Connect x signal,
            y => -- Connect y signal,
            item_out => item_out,
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
            x1 => -- Connect x1 signal,
            y1 => -- Connect y1 signal,
            c1 => c1,
            r1 => r1,
            attk_spd => attk_spd,
            mvm_spd => mvm_spd,
            armr_perc => armr_perc,
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