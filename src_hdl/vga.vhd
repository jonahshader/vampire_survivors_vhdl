library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga is
    generic (
        h_visible : natural := 640;
        v_visible : natural := 480;
        
        h_whole_line : natural := 800;
        v_whole_line : natural := 525;
        
        h_front_porch : natural := 16;
        v_front_porch : natural := 10;
        
        h_sync_pulse : natural := 96;
        v_sync_pulse : natural := 2;
        
        h_sync_positive : boolean := false;
        v_sync_positive : boolean := false);
    port ( 
        clk_pixel : in std_logic;
        clear : in std_logic;
        r_in : in unsigned(3 downto 0);
        g_in : in unsigned(3 downto 0);
        b_in : in unsigned(3 downto 0);
        r_out : out std_logic_vector(3 downto 0);
        g_out : out std_logic_vector(3 downto 0);
        b_out : out std_logic_vector(3 downto 0);
        x : out unsigned(10 downto 0);
        y : out unsigned(10 downto 0);
        hsync : out std_logic;
        vsync : out std_logic;
        valid : out std_logic;
        last_pixel : out std_logic;
        vga_width : out unsigned(10 downto 0);
        vga_height : out unsigned(10 downto 0));
end vga;

architecture Behavioral of vga is
    signal current_x : unsigned(10 downto 0) := to_unsigned(0, 11);
    signal current_y : unsigned(10 downto 0) := to_unsigned(0, 11);

    constant h_back_porch : natural := h_whole_line - h_visible - h_front_porch - h_sync_pulse;
    constant v_back_porch : natural := v_whole_line - v_visible - v_front_porch - v_sync_pulse;
    
begin
    vga_width <= to_unsigned(h_visible, vga_width'length);
    vga_height <= to_unsigned(v_visible, vga_height'length);
    
    process (clk_pixel, clear)
    begin
        if clear = '1' then
            current_x <= to_unsigned(0, current_x'length);
            current_y <= to_unsigned(0, current_y'length);
        elsif rising_edge(clk_pixel) then
            if current_x = to_unsigned(h_whole_line - 1, current_x'length) then
                current_x <= to_unsigned(0, current_x'length);
                if current_y = to_unsigned(v_whole_line - 1, current_y'length) then
                    current_y <= to_unsigned(0, current_y'length);
                else
                    current_y <= current_y + to_unsigned(1, current_y'length);
                end if;
            else
                current_x <= current_x + to_unsigned(1, current_x'length);
            end if;
        end if;
    end process;
    
    process (current_x, current_y)
        variable valid_var : boolean;
    begin
        valid_var := false;
        hsync <= '0' when h_sync_positive else '1';
        vsync <= '0' when v_sync_positive else '1';


        
        -- TODO: try dividing the - h_front_porch by 2 and v port
        -- if (current_x - h_front_porch) < to_unsigned(h_visible, current_x'length) and (current_y - v_front_porch) < to_unsigned(v_visible, current_y'length) then
        --     valid_var := true;
        -- end if;
        
        -- if current_x >= to_unsigned(h_visible + h_front_porch, current_x'length) and current_x < to_unsigned(h_visible + h_front_porch + h_sync_pulse, current_x'length) then
        --     hsync <= '1' when h_sync_positive else '0';
        -- end if;
        
        -- if current_y >= to_unsigned(v_visible + v_front_porch, current_y'length) and current_y < to_unsigned(v_visible + v_front_porch + v_sync_pulse, current_y'length) then
        --     vsync <= '1' when v_sync_positive else '0';
        -- end if;
        
        -- x <= (current_x - h_front_porch);
        -- y <= (current_y - v_front_porch);

        -- if current_x < to_unsigned(h_visible, current_x'length) and current_y < to_unsigned(v_visible, current_y'length) then
        --     valid_var := true;
        -- end if;

        -- if current_x >= to_unsigned(h_visible + h_front_porch, current_x'length) and current_x < to_unsigned(h_visible + h_front_porch + h_sync_pulse, current_x'length) then
        --     hsync <= '1' when h_sync_positive else '0';
        -- end if;

        -- if current_y >= to_unsigned(v_visible + v_front_porch, current_y'length) and current_y < to_unsigned(v_visible + v_front_porch + v_sync_pulse, current_y'length) then
        --     vsync <= '1' when v_sync_positive else '0';
        -- end if;

        -- x <= current_x;
        -- y <= current_y;

        -- trying with the order hsync -> back porch -> visible -> front porch
        if current_x < to_unsigned(h_sync_pulse, current_x'length) then
            hsync <= '1' when h_sync_positive else '0';
        end if;

        if current_y < to_unsigned(v_sync_pulse, current_y'length) then
            vsync <= '1' when v_sync_positive else '0';
        end if;

        if current_x >= to_unsigned(h_sync_pulse + h_back_porch, current_x'length) and current_x < to_unsigned(h_sync_pulse + h_back_porch + h_visible, current_x'length) and
              current_y >= to_unsigned(v_sync_pulse + v_back_porch, current_y'length) and current_y < to_unsigned(v_sync_pulse + v_back_porch + v_visible, current_y'length)
        then
            valid_var := true;
        end if; 

        x <= current_x - to_unsigned(h_sync_pulse + h_back_porch, current_x'length);
        y <= current_y - to_unsigned(v_sync_pulse + v_back_porch, current_y'length);



        last_pixel <= '1' when current_x = to_unsigned(h_visible, current_x'length) - 1 and current_y = to_unsigned(v_visible, current_y'length) - 1 else '0';
        valid <= '1' when valid_var else '0';
        
        if valid_var then
            r_out <= std_logic_vector(r_in);
            g_out <= std_logic_vector(g_in);
            b_out <= std_logic_vector(b_in);
        else
            r_out <= (others => '0');
            g_out <= (others => '0');
            b_out <= (others => '0');
        end if;
        
    end process;
    
end Behavioral;
