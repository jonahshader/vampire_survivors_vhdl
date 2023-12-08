library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity enem_gen is
   port (
      clk190 : in STD_LOGIC;
      -- player c1,r1 position (x,y)
      c1 : in STD_LOGIC_VECTOR(9 downto 0);
      r1 : in STD_LOGIC_VECTOR(9 downto 0);
      -- initial X and Y from the random number generator
      x : in STD_LOGIC_VECTOR(9 downto 0); -- Initial x position
      y : in STD_LOGIC_VECTOR(9 downto 0); -- Initial y position
      -- updating x1, y1 of enemy movement
      x1 : out STD_LOGIC_VECTOR(9 downto 0);
      y1 : out STD_LOGIC_VECTOR(9 downto 0)
   );
end enem_gen;

architecture enem_gen_architecture of enem_gen is
   -- Initialize enemy positions
   signal x1_temp, y1_temp : STD_LOGIC_VECTOR(9 downto 0);
   -- Set enemy movement speed (you can adjust this value)
   constant enem_mvm_spd : STD_LOGIC_VECTOR(9 downto 0) := "0000000010"; -- speed parameter that can be updated.

begin
   -- Initialize enemy positions with the provided x and y inputs
   x1_temp <= x;
   y1_temp <= y;

   process(clk190)
   begin
      if rising_edge(clk190) then
         -- Calculate new x1 and y1 positions
         if x1_temp < c1 then
            x1_temp <= x1_temp + enem_mvm_spd;
         elsif x1_temp > c1 then
            x1_temp <= x1_temp - enem_mvm_spd;
         end if;
         
         if y1_temp < r1 then
            y1_temp <= y1_temp + enem_mvm_spd;
         elsif y1_temp > r1 then
            y1_temp <= y1_temp - enem_mvm_spd;
         end if;
      end if;
   end process;

   -- Output updated enemy positions
   x1 <= x1_temp;
   y1 <= y1_temp;
end enem_gen_architecture;