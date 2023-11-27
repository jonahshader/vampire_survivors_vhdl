-- from https://vhdlguru.blogspot.com/2020/12/synthesizable-clocked-square-root.html
--Synthesisable Design for Finding Square root of a number.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity square_root is
    generic(N : integer := 32);
    port (
        clk : in std_logic;     --Clock
        rst : in std_logic;     --Asynchronous active high reset.
        input : in unsigned(N-1 downto 0);  --this is the number for which we want to find square root.
        done : out std_logic;   --This signal goes high when output is ready
        sq_root : out unsigned(N/2-1 downto 0)  --square root of 'input'
    );
end square_root;

architecture Behav of square_root is

begin

    SQROOT_PROC : process(clk,rst)
        variable a : unsigned(N-1 downto 0);  --original input.
        variable left,right,r : unsigned(N/2+1 downto 0):=(others => '0');  --input to adder/sub.r-remainder.
        variable q : unsigned(N/2-1 downto 0) := (others => '0');  --result.
        variable i : integer := 0;  --index of the loop. 
    begin
        if(rst = '1') then  --reset the variables.
            done <= '0';
            sq_root <= (others => '0');
            i := 0;
            a := (others => '0');
            left := (others => '0');
            right := (others => '0');
            r := (others => '0');
            q := (others => '0');
        elsif(rising_edge(clk)) then
            --Before we start the first clock cycle get the 'input' to the variable 'a'.
            if(i = 0) then  
                a := input;
                done <= '0';    --reset 'done' signal.
                i := i+1;   --increment the loop index.
            elsif(i < N/2) then --keep incrementing the loop index.
                i := i+1;  
            end if;
            --These statements below are derived from the block diagram.
            right := q & r(N/2+1) & '1';
            left := r(N/2-1 downto 0) & a(N-1 downto N-2);
            a := a(N-3 downto 0) & "00";  --shifting left by 2 bit.
            if ( r(N/2+1) = '1') then   --add or subtract as per this bit.
                r := left + right;
            else
                r := left - right;
            end if;
            q := q(N/2-2 downto 0) & (not r(N/2+1));
            if(i = N/2) then    --This means the max value of loop index has reached. 
                done <= '1';    --make 'done' high because output is ready.
                i := 0; --reset loop index for beginning the next cycle.
                sq_root <= q;   --assign 'q' to the output port.
                --reset other signals for using in the next cycle.
                left := (others => '0');
                right := (others => '0');
                r := (others => '0');
                q := (others => '0');
            end if;
        end if;    
    end process;

end architecture;