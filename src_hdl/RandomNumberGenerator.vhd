library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity RandomNumberGenerator is
  generic
  (
    seed : std_logic_vector(15 downto 0) := x"0100" -- Initial value of the LFSR
  );
  port
  (
    clk      : in std_logic; -- Clock input
    rst      : in std_logic; -- Reset input
    rand_out : out std_logic_vector(15 downto 0) -- 4-bit random output
  );
end RandomNumberGenerator;

architecture Behavioral of RandomNumberGenerator is
  signal lfsr_reg : std_logic_vector(15 downto 0) := seed; -- LFSR register

begin
  process (clk, rst)
    variable tmp, tmp2, tmp3 : std_logic := '0';
  begin
    if rst = '1' then
      lfsr_reg <= seed; -- Reset the LFSR
    elsif rising_edge(clk) then
      lfsr_reg <= lfsr_reg(14 downto 0) & tmp3;
    end if;
    tmp  := lfsr_reg(15) xor lfsr_reg(13);
    tmp2 := tmp xor lfsr_reg(11);
    tmp3 := tmp2 xor lfsr_reg(10);
  end process;

  rand_out <= lfsr_reg;

end Behavioral;