-- used for keyboard, but the remaining will use mclk
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_unsigned.all;
entity clkdiv is
  port
  (
    mclk  : in std_logic;
    clr   : in std_logic;
    clk40 : out std_logic
  );
end clkdiv;
architecture clkdiv of clkdiv is
  signal q : std_logic_vector(23 downto 0);
begin
  -- clock divider
  process (mclk, clr)
  begin
    if clr = '1' then
      q <= X"000000";
    elsif mclk'event and mclk = '1' then
      q <= q + 1;
    end if;
  end process;
  clk40 <= q(21); -- 48 Hz
end clkdiv;