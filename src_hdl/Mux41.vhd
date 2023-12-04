library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX41 is
    generic (N: integer);
    Port ( a_mux : in STD_LOGIC_Vector (N-1 downto 0);
           b_mux : in STD_LOGIC_Vector (N-1 downto 0);
           c_mux : in STD_LOGIC_Vector (N-1 downto 0);
           d_mux : in STD_LOGIC_Vector (N-1 downto 0);
           s_mux: in std_logic_vector(1 downto 0);
           zo_mux : out STD_LOGIC_Vector (N-1 downto 0));
end MUX41;

architecture Behavioral of MUX41 is 
begin
process (a_mux,b_mux,c_mux,d_mux,s_mux)
    begin
    case s_mux is 
         when "00" =>
               zo_mux <= a_mux;
         when "01" =>
               zo_mux <= b_mux;
         when "10" =>
               zo_mux <= c_mux;
         when "11" =>
               zo_mux <= d_mux;
         when others =>
               null;
    end case;
end process;
end Behavioral;