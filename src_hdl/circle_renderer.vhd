library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.custom_types.all;

entity circle_renderer is
  port(
    clk : in std_logic;
    reset : in std_logic;
    go : in std_logic;
    radius : in frame_pos_t;
    color : in color_t;
    pixel_out : out pixel_t;
    pixel_valid : out std_logic;
    done : out std_logic
  );
  end entity circle_renderer;

  architecture circle_renderer of circle_renderer is
    signal rect_done : std_logic;
    signal rect_pixel_out : pixel_t;
    signal rect_pixel_valid : std_logic;

    signal done_reg : std_logic := '0';
    signal pixel_out_reg : pixel_t := default_pixel;
    signal pixel_valid_reg : std_logic := '0';
    
    signal diameter : frame_pos_t;
  begin
    -- this is just the rectangle renderer, but we "filter out" pixels that don't belong to the circle.

    done <= done_reg;
    pixel_out <= pixel_out_reg;
    pixel_valid <= pixel_valid_reg;

    diameter <= shift_left(radius, 1);

    rect_r_inst : entity work.rect_renderer
    port map(
      clk => clk,
      reset => reset,
      go => go,
      size => (diameter, diameter),
      color => color,
      pixel_out => rect_pixel_out,
      pixel_valid => rect_pixel_valid,
      done => rect_done
    );

    filter_proc : process(clk)
      variable dx, dy : unsigned(frame_pos_t'length-1 downto 0);
      variable dx2, dy2, l2, r2 : unsigned(frame_pos_t'length * 2 - 1 downto 0);
    begin
      if rising_edge(clk) then
        if reset = '1' then
          done_reg <= '0';
          pixel_out_reg <= default_pixel;
          pixel_valid_reg <= '0';
        else
          done_reg <= rect_done;
          pixel_out_reg <= rect_pixel_out;
          -- logic to determine if the pixel lies within the circle
          if rect_pixel_out.coord.x < radius then
            dx := unsigned(radius - rect_pixel_out.coord.x);
          else
            dx := unsigned(rect_pixel_out.coord.x - radius);
          end if;

          if rect_pixel_out.coord.y < radius then
            dy := unsigned(radius - rect_pixel_out.coord.y);
          else
            dy := unsigned(rect_pixel_out.coord.y - radius);
          end if;

          dx2 := dx * dx;
          dy2 := dy * dy;
          l2 := dx2 + dy2;
          r2 := radius * radius;

          if l2 > r2 then
            pixel_valid_reg <= '0';
          else
            pixel_valid_reg <= rect_pixel_valid;
          end if;
        end if;
      end if;
    end process;

  end circle_renderer;