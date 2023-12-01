library ieee;
use ieee.std_logic_1164.all;

package gpu_codes is
  subtype gpu_code_t is std_logic_vector(2 downto 0); -- max of 8 codes
  constant rect :     gpu_code_t := "000";
  constant circle :   gpu_code_t := "001";
  constant line :     gpu_code_t := "010";
  constant sprite :   gpu_code_t := "011";
end gpu_codes;