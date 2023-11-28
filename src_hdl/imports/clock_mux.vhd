-- glitch free clock mux
-- original design from https://vlsitutorials.com/glitch-free-clock-mux/

library ieee;
use ieee.std_logic_1164.all;

entity clock_mux is
  port (
    clk1 : in std_logic;
    clk2 : in std_logic;
    sel : in std_logic; -- 0 = clk1, 1 = clk2
    clk_out : out std_logic
  );
end clock_mux;

architecture clock_mux of clock_mux is
  signal i_and1, i_and2, o_and1, o_and2 : std_logic;
  signal sync1_metastable, sync2_metastable, sync1_stable, sync2_stable : std_logic := '0';
begin
  i_and1 <= (not sel) and (not sync2_stable);
  i_and2 <= sel and (not sync1_stable);
  o_and1 <= clk1 and sync1_stable;
  o_and2 <= clk2 and sync2_stable;
  clk_out <= o_and1 or o_and2;

  sync1_proc : process(clk1)
  begin
    if falling_edge(clk1) then
      sync1_metastable <= i_and1;
      sync1_stable <= sync1_metastable;
    end if;
  end process;

  sync2_proc : process(clk2)
  begin
    if falling_edge(clk2) then
      sync2_metastable <= i_and2;
      sync2_stable <= sync2_metastable;
    end if;
  end process;

end clock_mux;