library ieee;
use ieee.std_logic_1164.all;

entity input_sync is
  generic (
    CONTROLLERS : positive := 1
  );
  port (
    clk : in std_logic;
    left_in : in std_logic_vector(CONTROLLERS-1 downto 0);
    right_in : in std_logic_vector(CONTROLLERS-1 downto 0);
    up_in : in std_logic_vector(CONTROLLERS-1 downto 0);
    down_in : in std_logic_vector(CONTROLLERS-1 downto 0);
    select_in : in std_logic_vector(CONTROLLERS-1 downto 0);
    left_out : out std_logic;
    right_out : out std_logic;
    up_out : out std_logic;
    down_out : out std_logic;
    select_out : out std_logic
  );
end entity input_sync;

architecture input_sync of input_sync is
begin
  -- combines all inputs by counting the desired inputs.
  -- opposing inputs cancel each other out.
  proc : process(clk)
    variable left_right : integer; -- negative is left, positive is right
    variable up_down : integer; -- negative is down, positive is up
  begin
    if rising_edge(clk) then
      -- set defaults
      left_out <= '0';
      right_out <= '0';
      up_out <= '0';
      down_out <= '0';
      select_out <= '0';

      left_right := 0;
      up_down := 0;
      
      -- loop through all controllers and count the inputs
      for i in 0 to CONTROLLERS-1 loop
        if left_in(i) = '1' then
          -- left is negative, so decrement
          left_right := left_right - 1;
        end if;
        if right_in(i) = '1' then
          -- right is positive, so increment
          left_right := left_right + 1;
        end if;
        if up_in(i) = '1' then
          -- up is positive, so increment
          up_down := up_down + 1;
        end if;
        if down_in(i) = '1' then
          -- down is negative, so decrement
          up_down := up_down - 1;
        end if;
        -- any select will trigger a select
        if select_in(i) = '1' then
          select_out <= '1';
        end if;
      end loop;
      
      -- determine which direction is the most desired
      if left_right < 0 then
        left_out <= '1';
      elsif left_right > 0 then
        right_out <= '1';
      end if;

      if up_down < 0 then
        down_out <= '1';
      elsif up_down > 0 then
        up_out <= '1';
      end if;
    end if;
  end process;
end input_sync;