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
        end if;
                tmp :=lfsr_reg(15) xor lfsr_reg(13);
                tmp2 := tmp xor lfsr_reg(11);
                tmp3:= tmp2 xor lfsr_reg(10);
    end process;

    -- Output the random number
    rand_out <= lfsr_reg;

end Behavioral;