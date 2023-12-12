library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.custom_types.all;
use IEEE.std_logic_unsigned.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Enemy_update_unit is
    Port (enmey_to_update: in enemy;
          clr:in std_logic;
          clk: in std_logic;
          charactor_cord:in world_coord_t;
          attacked_sig: in std_logic;
          valid_to_mux: in std_logic;
          spawn_sig: out std_logic;
          enemy_update: out enemy
         );
end Enemy_update_unit;

architecture Behavioral of Enemy_update_unit is
signal spawn_count,spawn_order: std_logic_vector(6 downto 0);
signal spawn_clk:std_logic;
signal updated_enemy:enemy;

begin
updated_enemy <= enmey_to_update;

-------------------spawning signal  ----------------------
spawning_clk:process(clr,clk)
variable q: std_logic_vector (23 downto 0);
begin
       if clr = '1' then 
           q:=x"000000";
       elsif clk'event and clk = '1' then 
           q:=q+1;
       end if;
       spawn_clk <= q(21);
end process;

spawning_counter:process(spawn_clk)
variable q: std_logic_vector (6 downto 0);
begin 

		if clr = '1' then
			q := (others => '0');
		elsif spawn_clk'event and spawn_clk = '1' then
			q := q + 1;
		end if;					
		    spawn_count <= q;			 
end process;

spawning: process(spawn_count)
begin 
   if spawn_count > spawn_order then 
        updated_enemy.enemy_valid <= '1'; 
        spawn_sig <= '1';
   else 
        spawn_sig<='0';
   end if;
end process;

-------------------HP update  ----------------------
HPupdate:process(attacked_sig)
begin 
     if attacked_sig = '1' then 
        updated_enemy.enemy_hp <= updated_enemy.enemy_hp - 1;
     end if;
end process;

-------------------Position update  ----------------------

Position: process(attacked_sig,updated_enemy,charactor_cord)
begin 
     if updated_enemy.enemy_position.x > charactor_cord.x then
        if attacked_sig = '1' then 
              updated_enemy.enemy_position.x <= updated_enemy.enemy_position.x + updated_enemy.enemy_velocity.x;   -------- Knock Back ------
        else 
              updated_enemy.enemy_position.x <= updated_enemy.enemy_position.x - updated_enemy.enemy_velocity.x;   -------- Move towards player ------
        end if; 
     
     if updated_enemy.enemy_position.y > charactor_cord.y then
        if attacked_sig = '1' then 
              updated_enemy.enemy_position.x <= updated_enemy.enemy_position.y + updated_enemy.enemy_velocity.y;
        else 
              updated_enemy.enemy_position.x <= updated_enemy.enemy_position.y - updated_enemy.enemy_velocity.y;
        end if;   
     end if;   
end process; 

enemy_update<= updated_enemy;

end Behavioral;

