library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity auto_atk is
  port
  (
    clk : in std_logic; -- Clock input
    -- position of the player is needed to establish x,y from where the whip will be generated or radius
    player_y : in std_logic_vector(9 downto 0); -- Player's x position
    player_x : in std_logic_vector(9 downto 0); -- Player's y position
    -- attack speed is how fast the attacks go out
    attk_spd : in std_logic_vector(3 downto 0); -- Player's attack speed
    -- these are inputs from inventory registers, they will have the level to determine size and type of attack
    whip   : in std_logic_vector(3 downto 0); -- Whip level
    garlic : in std_logic_vector(3 downto 0); -- Garlic level
    mage   : in std_logic_vector(3 downto 0); -- Mage level, need to figure out what type of attack style with mage.

    -- these will be outputs to the GPU to render different things.
    radius_garlic : out std_logic_vector(9 downto 0) := (others => '0'); -- Garlic radius
    rect_whip     : out std_logic_vector(9 downto 0); -- Linear line for Whip

    -- damage
    damage : out std_logic_vector (3 downto 0)
  );
end auto_atk;

architecture auto_atk_architecture of auto_atk is
  -- Declare signals or variables here if needed

begin
  -- Implement the attack calculations based on inputs and clock signal
  process (clk)
  begin
    if rising_edge(clk) then
      -- Calculate attack effects here
      radius_garlic(8 downto 5) <= garlic; -- what inputs do we need to send to the GPU to render a circle

      -- Example: Calculate Whip linear line based on whip level
      rect_whip <= (others => '0'); -- Placeholder for Whip calculation
      -- this will be a linear attack bi direction
      -- maybe lvl 5+ whip can have 2 whips from c1, r1 forward direciton and backward dirciton

      -- Use attk_spd, c1, r1, whip, garlic, and mage inputs as needed
    end if;
  end process;
end auto_atk_architecture;