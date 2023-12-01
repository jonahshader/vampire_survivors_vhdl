-- Control Logic for Sprite Movement with Key Mapping
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Control_Logic is
    Port (
        clk : in STD_LOGIC;
        key_code : in STD_LOGIC_VECTOR(7 downto 0);
        move_up : out STD_LOGIC;
        move_down : out STD_LOGIC;
        move_left : out STD_LOGIC;
        move_right : out STD_LOGIC
    );
end Control_Logic;

architecture Behavioral of Control_Logic is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            -- Reset movement signals
            move_up <= '0';
            move_down <= '0';
            move_left <= '0';
            move_right <= '0';

            -- Decode key press and set movement signals
            case key_code is
                when "00011101" =>  -- W
                    move_up <= '1';
                when "00011100" =>  -- A
                    move_left <= '1';
                when "00011011" =>  -- S
                    move_down <= '1';
                when "00100011" =>  -- D
                    move_right <= '1';
                when others =>
                    -- No action for other keys
                    -- If we add space bar or others, can add those here.
            end case;
        end if;
    end process;
end Behavioral;
