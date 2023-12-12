library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RandomNumberGenerator is
    generic (
        seed : STD_LOGIC_VECTOR(15 downto 0) := x"0100"  -- Initial value of the LFSR
    );
    Port ( 
        clk : in STD_LOGIC;  -- Clock input
        rst : in STD_LOGIC;  -- Reset input
        rand_out : out STD_LOGIC_VECTOR(15 downto 0)  -- 4-bit random output
    );
end RandomNumberGenerator;

architecture Behavioral of RandomNumberGenerator is
signal lfsr_reg : STD_LOGIC_VECTOR(15 downto 0) := seed;  -- LFSR register

begin 
process(clk, rst)
variable tmp,tmp2,tmp3:std_logic :='0';
    begin
        if rst = '1' then
            lfsr_reg <= seed;  -- Reset the LFSR
        elsif rising_edge(clk) then
            lfsr_reg <= lfsr_reg(14 downto 0)&tmp3;
        end if;
                tmp :=lfsr_reg(15) xor lfsr_reg(13);
                tmp2 := tmp xor lfsr_reg(11);
                tmp3:= tmp2 xor lfsr_reg(10);
    end process;
    
    rand_out <= lfsr_reg;

end Behavioral;
