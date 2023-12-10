library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.custom_types.all;

entity rect_renderer is
  port(
    clk : in std_logic;
    reset : in std_logic;
    go : in std_logic;
    size : in frame_coord_t;
    color : in color_t;
    pixel_out : out pixel_t;
    pixel_valid : out std_logic;
    done : out std_logic
  );
end entity rect_renderer;

architecture rect_renderer of rect_renderer is
  signal size_reg : frame_coord_t := default_frame_coord;
  signal pixel_out_reg : pixel_t := default_pixel;
  signal pixel_valid_reg : std_logic := '0';
  signal done_reg : std_logic := '0';

  type state_t is (idle, draw_rect);
  signal state_reg : state_t := idle;
begin
  pixel_out <= pixel_out_reg;
  pixel_valid <= pixel_valid_reg;
  done <= done_reg;
  
  state_proc : process(clk) is
  begin
    if rising_edge(clk) then
      if reset = '1' then
        state_reg <= idle;
        done_reg <= '0';
        pixel_valid_reg <= '0';
        pixel_out_reg <= default_pixel;
      else
        case state_reg is
          when idle =>
            done_reg <= '0';
            -- hopefully go isn't held high. i think that will send duplicate pixels.
            -- might want to modify this to wait until go goes high then low before starting
            if go = '1' then
              state_reg <= draw_rect;
              -- grab the color and size
              pixel_out_reg.color <= color;
              size_reg <= size;
              -- start at 0,0
              pixel_out_reg.coord.x <= to_unsigned(0, pixel_out_reg.coord.x'length);
              pixel_out_reg.coord.y <= to_unsigned(0, pixel_out_reg.coord.y'length);
              -- pixels from now on are valid
              pixel_valid_reg <= '1';
            end if;
          when draw_rect =>
            -- navigate the rectangle
            if pixel_out_reg.coord.y = size_reg.y - 1 then
              if pixel_out_reg.coord.x = size_reg.x - 1 then
                -- we reached the end of the rectangle. go back to idle
                state_reg <= idle;
                done_reg <= '1';
                -- pixels from now on are invalid until we start again
                pixel_valid_reg <= '0';
              else
                -- we aren't done with the row yet, so increment x
                pixel_out_reg.coord.x <= pixel_out_reg.coord.x + 1;
              end if;
            else
              if pixel_out_reg.coord.x = size_reg.x - 1 then
                -- we finished the row, so go to the next row and reset x
                pixel_out_reg.coord.x <= to_unsigned(0, pixel_out_reg.coord.x'length);
                pixel_out_reg.coord.y <= pixel_out_reg.coord.y + 1;
              else
                -- we aren't done with the row yet, so increment x
                pixel_out_reg.coord.x <= pixel_out_reg.coord.x + 1;
              end if;
            end if;
          when others =>
            null;
        end case;
      end if;
    end if;
  end process;
  

end rect_renderer;