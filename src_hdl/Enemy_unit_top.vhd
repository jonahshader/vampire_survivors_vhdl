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

entity Enemy_unit_top is
  Port ( rand_in : in std_logic_vector(15 downto 0);
         clk:in std_logic;
         clr:in std_logic;
         attacked_sig: in std_logic;
         charactor_cord:in world_coord_t;
         enemy_to_gamestates: out enemy; 
         enemy_update_ready: out std_logic);
end Enemy_unit_top;

architecture Behavioral of Enemy_unit_top is
signal i_enemy_load,i_enemy_update,i_enemy_to_bram,i_enemy_to_update,i_updated_enemy: enemy;
signal i_rand_in:std_logic_vector(15 downto 0);
signal i_update_ready,i_spawn_sig,i_valid_to_mux:std_logic;
signal i_wr_addr,i_rd_addr:STD_LOGIC_VECTOR (6 downto 0);
signal i_we_a,i_en_b:std_logic;

begin
i_enemy_update <= i_updated_enemy when i_valid_to_mux = '1' else i_enemy_to_update; 
enemy_to_gamestates <= i_enemy_update;


Enemy_Generator : entity work.Enemy_Generator
    Port map ( clk => clk,
           rand_in => rand_in,
           enemy_load => i_enemy_load);

Bram_control:entity work.Bram_control
    Port map ( clk => clk,
           clr => clr,
           enemy_load => i_enemy_load,
           enemy_update => i_enemy_update,
           update_ready => i_update_ready,
           wr_addr => i_we_a,
           we_a => i_we_a,
           rd_addr => i_rd_addr,
           en_b => i_en_b,
           enemy_to_bram => i_enemy_to_bram)

Enemy_Bram : entity work.bram_sdp
  generic map (
    WIDTH => 85,
    DEPTH => 8500
    -- no init file
  )
  port map(
    -- system is writing pixels, so write port takes master clock
    clk_a => clk,
    we_a => i_we_a,
    addr_a => i_we_a,
    din_a => i_enemy_to_bram,
    -- vga is reading pixels, so read port takes pixel clock
    clk_b => clk,
    en_b => i_en_b,
    addr_b => i_rd_addr ,
    dout_b => i_enemy_to_update
  );

Enemy_udpate_ctrl:entity work.Enemy_update_ctrl
    Port map (enmey_to_update => i_enemy_to_update,
          clr => clr,
          clk => clk,
          spawn_sig=>i_spawn_sig,
          valid_to_mux=> i_valid_to_mux,
          update_ready=>i_update_ready
         );
 
 Enemy_update:entity work.Enemy_update_unit
      Port map (enmey_to_update=> i_enemy_to_update,
          clr=>clr,
          clk=>clk,
          charactor_cord=>charactor_cord,
          attacked_sig=>attacked_sig,
          valid_to_mux=>i_valid_to_mux,
          spawn_sig=>i_spawn_sig,
          enemy_update => i_updated_enemy
         );
  
         
end Behavioral;