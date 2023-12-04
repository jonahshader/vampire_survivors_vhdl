library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RandomNumberGenerator is
    Port ( 
        clk : in STD_LOGIC;  -- Clock input
        rst : in STD_LOGIC;  -- Reset input
        rand_out_16 : out STD_LOGIC_VECTOR(15 downto 0)  -- 16-bit random output
    );
end RandomNumberGenerator;

architecture Behavioral of RandomNumberGenerator is
    signal lfsr_reg : STD_LOGIC_VECTOR(15 downto 0) := x"0000"; 
begin
    process(clk, rst)
    begin
        if rst = '1' then
            lfsr_reg <= x"0000";  -- Reset the LFSR
        elsif rising_edge(clk) then
            lfsr_reg(15) <= lfsr_reg(15) xor lfsr_reg(14);
            lfsr_reg(14) <= lfsr_reg(14) xor lfsr_reg(13);
            lfsr_reg(13) <= lfsr_reg(13) xor lfsr_reg(12);
            lfsr_reg(12) <= lfsr_reg(12) xor lfsr_reg(11);
            lfsr_reg(11) <= lfsr_reg(11) xor lfsr_reg(10);
            lfsr_reg(10) <= lfsr_reg(10) xor lfsr_reg(9);
            lfsr_reg(9) <= lfsr_reg(9) xor lfsr_reg(8);
            lfsr_reg(8) <= lfsr_reg(8) xor lfsr_reg(7);
            lfsr_reg(7) <= lfsr_reg(7) xor lfsr_reg(6);
            lfsr_reg(6) <= lfsr_reg(6) xor lfsr_reg(5);
            lfsr_reg(5) <= lfsr_reg(5) xor lfsr_reg(4);
            lfsr_reg(4) <= lfsr_reg(4) xor lfsr_reg(3);
            lfsr_reg(3) <= lfsr_reg(3) xor lfsr_reg(2);
            lfsr_reg(2) <= lfsr_reg(2) xor lfsr_reg(1);
            lfsr_reg(1) <= lfsr_reg(1) xor lfsr_reg(0);
            lfsr_reg(0) <= lfsr_reg(15);
        end if;
    end process;

    -- Output the random number
    rand_out_16 <= lfsr_reg;
end Behavioral;