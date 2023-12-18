-- modified version of prom.vhd
-- hopefully this is inferred as something besides bram. although i guess its fine if it is.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.log2;
use ieee.math_real.ceil;
use std.textio.all;

entity prom is
  generic (
    WIDTH     : natural := 36;   -- RAMB18: 18x1024, 9x2048, 4x4608, 2x9216, 1x18432
    DEPTH     : natural := 1024; -- RAMB36: 36x1024, 18x2048, 9x4096, 4x9216, 2x18432, 1x36864
    INIT_FILE : string  := ""    -- Optional file with BRAM initialization values
  );
  port (
    -- Port B - Read only
    clk_b  : in    std_logic;
    en_b   : in    boolean;
    addr_b : in    unsigned(integer(ceil(log2(real(DEPTH)))) - 1 downto 0);
    dout_b : out   std_logic_vector(WIDTH - 1 downto 0) := (others => '0')
  );
end entity prom;

architecture rtl of prom is

  type ram_type is array (0 to DEPTH - 1) of std_logic_vector(WIDTH - 1 downto 0);

  -- TODO: If file doesn't exist leave RAM at all zeros.
  impure function read_ram_init_file (file_name : in string) return ram_type is

    file     f_init      : text;
    variable open_status : file_open_status;
    variable ram_line    : line;
    variable val         : bit_vector(WIDTH - 1 downto 0);
    variable good        : boolean;
    variable ram         : ram_type := (others => (others => '0'));

  begin
    if file_name /= "" then
      file_open(open_status, f_init, file_name, READ_MODE);

      if open_status = OPEN_OK then
        for i in ram_type'range loop
          exit when endfile(f_init);
          readline(f_init, ram_line);
          read(ram_line, val, good);
          if good then -- TODO: Even with non-numbers this reports 'good' and just gives 0
            ram(i) := to_stdlogicvector(val);
          end if;
        end loop;
        file_close(f_init);
      else
      -- TODO: How to output compile-time error?
        report "Couldn't open RAM init file " & file_name & ", will default to all 0's." severity warning;
      end if;
    end if;

    return ram;
  end function;

  signal bram : ram_type := read_ram_init_file(INIT_FILE);

begin
  
  port_b : process (clk_b) is
  begin
    if rising_edge(clk_b) then
      if en_b then
        dout_b <= bram(to_integer(addr_b));
      end if;
    end if;
  end process port_b;

end architecture rtl;
