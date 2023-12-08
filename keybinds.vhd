library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_ARITH.ALL;

entity keybinds is
   port (
      clk190 : in STD_LOGIC;
      clr : in STD_LOGIC;
      keyval2 : in STD_LOGIC_VECTOR(7 downto 0);
      --flipping the sprite with left and right
      flip : out std_logic;
      --c1,r1 position of character
      c1 : out std_logic_vector (9 downto 0);
      r1 : out std_logic_vector (9 downto 0);
      --testing leds
      ld : out std_logic_vector (3 downto 0);
      -- from player_stat, movement speed
      mvm_spd : in STD_LOGIC_VECTOR(3 downto 0)  -- Input for movement speed
   );
end keybinds;

architecture keybinds of keybinds is
   -- movement keys
   constant W_key : std_logic_vector(7 downto 0) := X"1D";
   constant A_key : std_logic_vector(7 downto 0) := X"1C";
   constant S_key : std_logic_vector(7 downto 0) := X"1B";
   constant D_key : std_logic_vector(7 downto 0) := X"23";
   -- action keys
   constant ESC_key : std_logic_vector(7 downto 0) := X"76"; -- Pause Game
   constant SPC_key : std_logic_vector(7 downto 0) := X"29"; -- Select menu
   
   -- for character movement side
   constant c1s : integer := 23;
   constant r1s : integer := 250;
   
   -- testing lds for movement can be removed after.
   signal selected_led : std_logic_vector(3 downto 0) := "0000";

begin
   process(clk190, clr)
      variable c1v, r1v : std_logic_vector(9 downto 0);
      variable calc : std_logic_vector(1 downto 0);

   begin
      if clr = '1' then
         c1v := conv_std_logic_vector(c1s, 10);
         r1v := conv_std_logic_vector(r1s, 10);
         calc := "00";
         flip <= '0';
      elsif clk190'event and clk190 = '1' then
         if keyval2 = W_key then
            r1v := r1v - mvm_spd; -- Move up using mvm_spd
            selected_led <= "0001";
         end if;
         if keyval2 = S_key then
            selected_led <= "0010";
            r1v := r1v + mvm_spd; -- Move down using mvm_spd
         end if;
         if keyval2 = A_key then
            selected_led <= "0100";
            c1v := c1v - mvm_spd; -- Move left using mvm_spd
            flip <= '0'; -- flipping sprite left and right
         end if;
         if keyval2 = D_key then
            selected_led <= "1000";
            c1v := c1v + mvm_spd; -- Move right using mvm_spd
            flip <= '1'; -- flipping sprite left and right
         end if;
      end if;
      c1 <= c1v;
      r1 <= r1v;
      ld <= selected_led;
   end process;
end keybinds;
