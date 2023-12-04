library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Enemy_Generator is
    Port ( 
        clk: in std_logic;
        rand_in : in STD_LOGIC_VECTOR(15 downto 0)  -- 16-bit random input
    );
end Enemy_Generator;

architecture Behavioral of Enemy_Generator is 

signal enemy_type STD_LOGIC_VECTOR(1 downto 0);
signal enenmy_spawn_type STD_LOGIC_VECTOR(1 downto 0);
signal enemy_hp STD_LOGIC_VECTOR(2 dwonto 0);
singal enemy_spawn_cord STD_LOGIC_VECTOR(17 downto 0);
begin 


enemy_type <= rand_in(1 downto 0);
enemy_spawn_type <= rand_in(3 downto 2);
enemy_hp <= rand_in(6 downto 4);

process:(enenmy_spawn_type)
begin
  case enenmy_spawn_type

