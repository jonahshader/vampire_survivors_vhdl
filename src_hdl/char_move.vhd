-- Sprite Movement Module with Defined Constants and Initial Position
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Sprite_Movement is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;   -- Added reset for position control
        move_up : in STD_LOGIC;
        move_down : in STD_LOGIC;
        move_left : in STD_LOGIC;
        move_right : in STD_LOGIC;
        sprite_x : out INTEGER range 0 to 639;  -- Screen width range
        sprite_y : out INTEGER range 0 to 479  -- Screen height range
    );
end Sprite_Movement;

architecture Behavioral of Sprite_Movement is
    -- Might need to update these based on screen size
    constant screen_width : INTEGER := 640;
    constant screen_height : INTEGER := 480;
    
    constant initial_x : INTEGER := screen_width / 2;  -- Middle of the screen
    constant initial_y : INTEGER := screen_height / 2; -- Middle of the screen
    
    signal x_pos : INTEGER range 0 to screen_width - 1 := initial_x;
    signal y_pos : INTEGER range 0 to screen_height - 1 := initial_y;
    constant speed : INTEGER := 1; -- Speed of sprite movement
    
begin
    process(clk, reset)
    begin
        if reset = '1' then
            -- Reset sprite position
            x_pos <= initial_x;
            y_pos <= initial_y;
            
        elsif rising_edge(clk) then
            -- Update sprite position based on movement signals
            if move_up = '1' and y_pos > 0 then -- If move up is true and we're within screen limit.
                y_pos <= y_pos - speed;
            elsif move_down = '1' and y_pos < screen_height - 1 then
                y_pos <= y_pos + speed;
            end if;

            if move_left = '1' and x_pos > 0 then
                x_pos <= x_pos - speed;
            elsif move_right = '1' and x_pos < screen_width - 1 then
                x_pos <= x_pos + speed;
            end if;
        end if;
    end process;

    -- Output the current position
    sprite_x <= x_pos;
    sprite_y <= y_pos;
end Behavioral;
