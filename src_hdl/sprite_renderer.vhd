library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.custom_types.all;

entity sprite_renderer is
  port(
    clk : in std_logic;
    reset : in std_logic;
    go : in std_logic;
    sprite_index : in std_logic_vector(11 downto 0); -- matches gpu 'enum' input
    pixel_out : out pixel_t;
    pixel_valid : out std_logic;
    done : out std_logic
  );
end entity sprite_renderer;

architecture sprite_renderer of sprite_renderer is
begin
  -- TODO: implement. probably have one single sprite and a sprite_region_renderer.
  -- this will map the sprite_index to the specific region for that sprite, then
  -- pass that to the sprite_region_renderer.

  passthrough_proc : process(clk)
  begin
    if rising_edge(clk) then
      pixel_out <= default_pixel;
      pixel_valid <= '0';
      done <= '0';
    end if;
  end process;

end sprite_renderer;