library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.custom_types.all;
use IEEE.std_logic_unsigned.ALL;



entity Enemy_update_ctrl is
    Port (enmey_to_update: in enemy;
          clr:in std_logic;
          clk: in std_logic;
          attack: in std_logic;
          spawn_sig: in std_logic;
          charactor_cord:in world_coord_t;
          valid_to_mux: out std_logic;
          update_ready:out std_logic
         );
end Enemy_update_ctrl;

architecture Behavioral of Enemy_update_ctrl is
signal read_enemy:enemy;
signal valid_sig,dead_sig:std_logic;
type state_type is (start_read, valid_det, time_to_spawn, hp0,en_update,done_update);
signal current_state, next_state: state_type;


begin

read_enemy <= enmey_to_update;
valid_sig<= read_enemy.enemy_valid; ----- Get Valid_sig --------------

--------- live or dead ---------------
Liveordead:process(read_enemy)
begin 
    if read_enemy.enemy_hp = "00" then 
       dead_sig <= '1';
    else 
       dead_sig <= '0';
    end if;
end process;


----------------Enemy Update State Machine ----------------

synch: process(clk, clr)
begin    
    if clr = '1' then
      current_state <= start_read;
    elsif (clk'event and clk = '1') then
      current_state <= next_state;
    end if;
end process synch;
 
C1: process(current_state)
begin  
    case current_state is    
    when start_read =>						
        next_state <= valid_det;		  	
    when valid_det =>			
      if valid_sig = '0' then  		
        next_state <= time_to_spawn;		  	
      else					
        next_state <= hp0;		
      end if;
    when time_to_spawn =>				
      if spawn_sig = '0' then  		
        next_state <= done_update;		  	
      else					
        next_state <= hp0;	
      end if;
    when hp0 =>			
      if dead_sig = '0' then  		
        next_state <= en_update;		  	
      else					
        next_state <= done_update;	
      end if;	
    when en_update =>
       next_state <= done_update;
    when done_update =>
       next_state <= start_read;
    when others => null;	
    end case; 
end process C1;

C2: process(current_state)
begin  
    case current_state is 
    when start_read => 
         update_ready <= '0';
    when done_update =>         
         update_ready <= '1';
    when others => null;	
    end case; 
end process C2;


end Behavioral;