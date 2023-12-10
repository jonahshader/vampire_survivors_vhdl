----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2023/12/03 19:32:06
-- Design Name: 
-- Module Name: RandomNumberGenerator - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RandomNumberGenerator is
    Port ( 
        clk : in STD_LOGIC;  -- Clock input
        rst : in STD_LOGIC;  -- Reset input
        rand_out : out STD_LOGIC_VECTOR(15 downto 0)  -- 4-bit random output
    );
end RandomNumberGenerator;

architecture Behavioral of RandomNumberGenerator is
signal lfsr_reg : STD_LOGIC_VECTOR(15 downto 0);


begin 
process(clk, rst)
variable tmp,tmp2,tmp3:std_logic :='0';
    begin
    
        if rst = '1' then
            lfsr_reg <= x"0100";  -- Reset the LFSR
        elsif rising_edge(clk) then

            lfsr_reg <= lfsr_reg(14 downto 0)&tmp3;
            -- XOR the taps to generate the feedback
--            lfsr_reg(3) <= lfsr_reg(3) xor lfsr_reg(2);
--            lfsr_reg(2) <= lfsr_reg(2) xor lfsr_reg(1);
--            lfsr_reg(1) <= lfsr_reg(1) xor lfsr_reg(0);
--            -- Shift right
--            lfsr_reg(0) <= lfsr_reg(3) and lfsr_reg(0);
        end if;
                tmp :=lfsr_reg(15) xor lfsr_reg(13);
                tmp2 := tmp xor lfsr_reg(11);
                tmp3:= tmp2 xor lfsr_reg(10);
    end process;

    -- Output the random number
    rand_out <= lfsr_reg;

end Behavioral;
