library IEEE;
use IEEE.STD_LOGIC_1164.all;

package gamestate_comps is

    -- Declaration of the clkdiv entity
    component clkdiv is
        port(
		 mclk : in STD_LOGIC;
		 clr : in STD_LOGIC;
		 clk190 : out STD_LOGIC;
		 clk40 : out STD_LOGIC
	     );
    end component;
    
    -- Keyboard Controller
    component keyboard_ctrl is
    port(
		 clk40 : in STD_LOGIC;
		 clr : in STD_LOGIC;
		 PS2C : in STD_LOGIC;
		 PS2D : in STD_LOGIC;
		 keyval1: out STD_LOGIC_VECTOR(7 downto 0);
		 keyval2: out STD_LOGIC_VECTOR(7 downto 0);
		 keyval3 : out STD_LOGIC_VECTOR(7 downto 0)
	     );
    end component;
    
    -- decalaration of keybinds and moves the character
    component keybinds is
    port(
        clk190 : in STD_LOGIC;
        clr : in STD_LOGIC;
        keyval2 : in STD_LOGIC_VECTOR(7 downto 0);
        flip : out std_logic;
        c1 : out std_logic_vector (9 downto 0);
        r1 : out std_logic_vector (9 downto 0);
        ld : out std_logic_vector (3 downto 0);
        mvm_spd : in STD_LOGIC_VECTOR(3 downto 0)  -- Input for movement speed
        );
    end component;
    
    -- item generator
    component item_gen is
    port (
        clk190 : in STD_LOGIC;
        clr : in STD_LOGIC;
        item_out : out STD_LOGIC_VECTOR(2 downto 0)
    );
    end component;
    
    -- inventory management
    component inv_mng is
    port (
        clk190 : in STD_LOGIC;
        c1 : in STD_LOGIC_VECTOR(9 downto 0);
        r1 : in STD_LOGIC_VECTOR(9 downto 0);
        x : in STD_LOGIC_VECTOR(9 downto 0);
        y : in STD_LOGIC_VECTOR(9 downto 0);
        item_out : in STD_LOGIC_VECTOR(2 downto 0);
        whip : out STD_LOGIC_VECTOR(3 downto 0);
        garlic : out STD_LOGIC_VECTOR(3 downto 0);
        mage : out STD_LOGIC_VECTOR(3 downto 0);
        armour : out STD_LOGIC_VECTOR(3 downto 0);
        gloves : out STD_LOGIC_VECTOR(3 downto 0);
        wings : out STD_LOGIC_VECTOR(3 downto 0) 
    );
    end component;
    
    -- player stats
    component player_stat is
    port (
        clk190 : in STD_LOGIC;
        armour : in STD_LOGIC_VECTOR(3 downto 0);
        gloves : in STD_LOGIC_VECTOR(3 downto 0);
        wings : in STD_LOGIC_VECTOR(3 downto 0);
        x1 : in STD_LOGIC_VECTOR(9 downto 0);
        y1 : in STD_LOGIC_VECTOR(9 downto 0);
        c1 : in STD_LOGIC_VECTOR(9 downto 0);
        r1 : in STD_LOGIC_VECTOR(9 downto 0);
        attk_spd : out STD_LOGIC_VECTOR(3 downto 0);
        mvm_spd : out STD_LOGIC_VECTOR(3 downto 0);
        armr_perc : out STD_LOGIC_VECTOR(3 downto 0);
        hp : out STD_LOGIC_VECTOR(7 downto 0)
    );
    end component;
    
    -- enemy generator
    component enem_gen is
    port (
      clk190 : in STD_LOGIC;
      c1 : in STD_LOGIC_VECTOR(9 downto 0);
      r1 : in STD_LOGIC_VECTOR(9 downto 0);
      x : in STD_LOGIC_VECTOR(9 downto 0);
      y : in STD_LOGIC_VECTOR(9 downto 0);
      x1 : out STD_LOGIC_VECTOR(9 downto 0);
      y1 : out STD_LOGIC_VECTOR(9 downto 0)
    );
    end component;
    
    -- auto attack
    component auto_atk is
    port (
      clk190 : in STD_LOGIC;
      c1 : in STD_LOGIC_VECTOR(9 downto 0);
      r1 : in STD_LOGIC_VECTOR(9 downto 0);
      attk_spd : in STD_LOGIC_VECTOR(3 downto 0);
      whip : in STD_LOGIC_VECTOR(3 downto 0);
      garlic : in STD_LOGIC_VECTOR(3 downto 0);
      mage : in STD_LOGIC_VECTOR(3 downto 0);
      radius_garlic : out STD_LOGIC_VECTOR(9 downto 0);
      linear_whip : out STD_LOGIC_VECTOR(9 downto 0)
    );
    end component;
end gamestate_comps;