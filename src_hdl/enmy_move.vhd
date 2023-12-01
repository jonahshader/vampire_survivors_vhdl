library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Enemy_Logic is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        sprite_x : in INTEGER range 0 to 639;
        sprite_y : in INTEGER range 0 to 479;
        rand_x : in INTEGER range 0 to 639;
        rand_y : in INTEGER range 0 to 479;
        enemy_x : out INTEGER range 0 to 639;
        enemy_y : out INTEGER range 0 to 479
    );
end Enemy_Logic;

architecture Behavioral of Enemy_Logic is
    signal x_pos : INTEGER range 0 to 639;
    signal y_pos : INTEGER range 0 to 479;
    constant speed : INTEGER := 1; -- Speed of enemy movement
begin
    process(clk, reset)
    begin
        if reset = '1' then
            -- Set enemy position to random initial position
            x_pos <= rand_x;
            y_pos <= rand_y;
        elsif rising_edge(clk) then
            -- Move enemy towards the sprite
            if x_pos < sprite_x then
                x_pos <= x_pos + speed;
            elsif x_pos > sprite_x then
                x_pos <= x_pos - speed;
            end if;

            if y_pos < sprite_y then
                y_pos <= y_pos + speed;
            elsif y_pos > sprite_y then
                y_pos <= y_pos - speed;
            end if;
        end if;
    end process;

    -- Output the current enemy position
    enemy_x <= x_pos;
    enemy_y <= y_pos;
end Behavioral;
