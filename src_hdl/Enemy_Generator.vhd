----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2023/12/06 22:53:57
-- Design Name: 
-- Module Name: Enemy_Generator - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description:m-
 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.custom_types.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Enemy_Generator is
    Port ( rand_in : in STD_LOGIC_VECTOR (15 downto 0);
           clk: in std_logic;
           enemy_load : out enemy);
end Enemy_Generator;
 -
architecture Behavioral of Enemy_Generator is
signal w,e,s,n:world_coord_t;
signal sp_sel,hp_sel: std_logic_vector(1 downto 0);
signal enemy_valid:std_logic;
signal spawn_position: world_coord_t;
signal hp1,hp2,hp3,hp4: std_logic_vector(2 downto 0);
    
begin
w.x <= "000001111000.000000"; ---- spwaning from west side back pouch 
w.y <="000100010011.000000";
e.x <="001100011000.000000"; ---- spwaning from east side front pouch 
e.y<="000100010011.000000";
n.x<="000111010000.000000"; ---- spwaning from north side back pouch 
n.y<="001000001000.000000";
s.x<="000111010000.000000";---- spwaning from south side front pouch 
s.y<="000000011110.000000";
---- generator hp from 1 to 3
hp1<="001";
hp2<="010";
hp3<="011";
hp4<="100";

----- get rand number from rand generator
sp_sel <= rand_in(3 downto 2);
hp_sel<= rand_in(5 downto 4);
enemy_load.enemy_type <=  rand_in(1 downto 0);
enemy_load.enemy_hp<= rand_in(5 downto 4);
enemy_load.enemy_velocity.x<= "000000000100.000000"; -- initial velocity 
enemy_load.enemy_velocity.y<="000000000100.000000";
enemy_load.enemy_valid <= '0'; ---- Valid means appear on the screen 

hp_mux:process(hp1,hp2,hp3,hp4,hp_sel)
begin 
    case hp_sel is 
         when "00" => enemy_load.enemy_hp <= hp1;
         when "01" => enemy_load.enemy_hp <= hp2;
         when "10" => enemy_load.enemy_hp <= hp3;
         when "11" => enemy_load.enemy_hp <= hp4;
         when others => NULL;
     end case;
end process;

Spawn_mux: Process(w,e,s,n,sp_sel)
begin 
     case sp_sel is 
         when "00" => enemy_load.spawn_position <= w;
         when "01" => enemy_load.spawn_position <= e;
         when "10" => enemy_load.spawn_position <= s;
         when "11" => enemy_load.spawn_position <= n;
         when others => NULL;
     end case;
End Process;
end Behavioral;
