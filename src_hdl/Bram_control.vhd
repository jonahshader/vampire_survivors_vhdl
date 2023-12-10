----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2023/12/09 16:33:44
-- Design Name: 
-- Module Name: Bram_control - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
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
use IEEE.std_logic_unsigned.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Bram_control is
    Port ( clk : in STD_LOGIC;
           clr : in STD_LOGIC;
           enemy_load,enemy_update: in enemy;
           wr_addr : out STD_LOGIC_VECTOR (6 downto 0);
           we_a : out STD_LOGIC;
           rd_addr : out STD_LOGIC_VECTOR (6 downto 0);
           en_b : out STD_LOGIC;
           enemy_to_bram: out enemy
           ); 
end Bram_control;

architecture Behavioral of Bram_control is
signal wr_sel: std_logic;
signal wr,rd:std_logic_vector(6 downto 0);
signal load_done,update_ready:std_logic;
begin

load_done <='0';
we_a <= '1';
en_b <='0';
wr_sel <= '1'; 
wr_addr <= "1111111";
rd_addr <= "0000000";

--- enemy to bram mux 
enemy_to_bram <= enemy_load when wr_sel = '1' else enemy_update;

Write_process: process(clk,clr,load_done)
  begin 
      if clr ='1'then 
          wr <= "1111111";
          we_a <= '0';
          elsif clk'event and clk ='1'then
             we_a <='1';
             if load_done ='0'then --- load or update
                wr <= wr +1;
                if wr = "01100100" then ---- load until 100 enemy loaded
                    wr <= "1111111";
                    wr_sel <= '0';
                    load_done <='1';
                end if; 
             else  --- when load is complete, wr_addr = rd_addr
                 wr <= rd;
             end if;              
          end if;        
          wr_addr <= wr;
end process;

Read_procss:process(load_done,clk,update_ready)
begin 
        if load_done = '0'then   
           rd <= "1111111";
           en_b<='0';
           elsif clk'event and clk = '1' then
               if update_ready = '1'then 
                  en_b<='1';
                  rd <= rd + 1;
                 if rd = "01100100" then 
                 rd <="1111111";
                 end if;
                end if;
         end if;
         rd_addr <= rd;
end process;
end Behavioral;
