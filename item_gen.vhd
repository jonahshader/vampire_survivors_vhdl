library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity item_gen is
    port (
        clk190 : in STD_LOGIC;
        clr : in STD_LOGIC;
        item_out : out STD_LOGIC_VECTOR(2 downto 0)
    );
end item_gen;

architecture Behavioral of item_gen is
    signal lfsr_reg : STD_LOGIC_VECTOR(2 downto 0) := "000";
begin
    process(clk190, clr)
    begin
        if clr = '1' then
            lfsr_reg <= "000";
        elsif rising_edge(clk190) then
            lfsr_reg(0) <= lfsr_reg(0) xor lfsr_reg(2);
            lfsr_reg(1) <= lfsr_reg(0);
            lfsr_reg(2) <= lfsr_reg(1);
        end if;
    end process;

    item_out <= lfsr_reg;
end Behavioral;