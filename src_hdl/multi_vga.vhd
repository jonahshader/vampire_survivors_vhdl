library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity multi_vga is
  Port (
    clear : in std_logic;
    r_in : in unsigned(3 downto 0);
    g_in : in unsigned(3 downto 0);
    b_in : in unsigned(3 downto 0);
    mode : in std_logic;
    clk1 : in std_logic;
    clk2 : in std_logic;
    r_out : out std_logic_vector(3 downto 0);
    g_out : out std_logic_vector(3 downto 0);
    b_out : out std_logic_vector(3 downto 0);
    x : out unsigned(10 downto 0);
    y : out unsigned(10 downto 0);
    hsync : out std_logic;
    vsync : out std_logic;
    valid : out std_logic;
    vga_width : out unsigned(10 downto 0);
    vga_height : out unsigned(10 downto 0);
    last_pixel : out std_logic
  );
end multi_vga;

architecture Behavioral of multi_vga is
    type color_array is array (0 to 1) of unsigned(3 downto 0);
    type color_out_array is array (0 to 1) of std_logic_vector(3 downto 0);
    type position_array is array (0 to 1) of unsigned(10 downto 0);
    
    signal mode_last_vec : std_logic_vector(1 downto 0) := "00";
    signal mode_last_2_vec : std_logic_vector(1 downto 0) := "00";
    
    signal r_out_vec : color_out_array;
    signal g_out_vec : color_out_array;
    signal b_out_vec : color_out_array;
    signal x_vec : position_array;
    signal y_vec : position_array;
    signal hsync_vec : std_logic_vector(1 downto 0);
    signal vsync_vec : std_logic_vector(1 downto 0);
    signal vga_width_vec : position_array;
    signal vga_height_vec : position_array;
    signal last_pixel_vec : std_logic_vector(1 downto 0);
    signal global_clear : std_logic;
    signal clear_vec : std_logic_vector(1 downto 0);

    

    
begin
    r_out <= r_out_vec(0) when mode = '0' else r_out_vec(1);
    g_out <= g_out_vec(0) when mode = '0' else g_out_vec(1);
    b_out <= b_out_vec(0) when mode = '0' else b_out_vec(1);
    x <= x_vec(0) when mode = '0' else x_vec(1);
    y <= y_vec(0) when mode = '0' else y_vec(1);
    hsync <= hsync_vec(0) when mode = '0' else hsync_vec(1);
    vsync <= vsync_vec(0) when mode = '0' else vsync_vec(1);
    vga_width <= vga_width_vec(0) when mode = '0' else vga_width_vec(1);
    vga_height <= vga_height_vec(0) when mode = '0' else vga_height_vec(1);
    last_pixel <= last_pixel_vec(0) when mode = '0' else last_pixel_vec(1);
    
    -- mode_last_proc : process (pixel_clock)
    -- begin
    --     if rising_edge(pixel_clock) then
    --         mode_last <= mode;
    --         global_clear <= clear or (mode_last xor mode);
    --     end if;
    -- end process;

    mode_last_1_proc : process (clk1)
    begin
        if rising_edge(clk1) then
            mode_last_2_vec(0) <= mode_last_vec(0);
            mode_last_vec(0) <= mode;
            clear_vec(0) <= clear or (mode_last_2_vec(0) xor mode_last_vec(0));
        end if;
    end process;

    mode_last_2_proc : process (clk2)
    begin
        if rising_edge(clk2) then
            mode_last_2_vec(1) <= mode_last_vec(1);
            mode_last_vec(1) <= mode;
            clear_vec(1) <= clear or (mode_last_2_vec(1) xor mode_last_vec(1));
        end if;
    end process;
      

    
    vga1 : entity work.vga
    generic map(
        h_visible => 1280,
        v_visible => 720,
        h_whole_line => 1650,
        v_whole_line => 750,
        h_front_porch => 110,
        v_front_porch => 5,
        h_sync_pulse => 40,
        v_sync_pulse => 5,
        h_sync_positive => false, -- was true
        v_sync_positive => true
    )
    port map(
        clk_pixel => clk1,
        clear => clear_vec(0),
        r_in => r_in,
        g_in => g_in,
        b_in => b_in,
        r_out => r_out_vec(0),
        g_out => g_out_vec(0),
        b_out => b_out_vec(0),
        x => x_vec(0),
        y => y_vec(0),
        hsync => hsync_vec(0),
        vsync => vsync_vec(0),
        last_pixel => last_pixel_vec(0),
        vga_width => vga_width_vec(0),
        vga_height => vga_height_vec(0)
    );

    vga2 : entity work.vga
    generic map(
        h_visible => 1280, -- 1280
        v_visible => 960, -- 960
        h_whole_line => 1696, -- 1712
        v_whole_line => 996, --994
        h_front_porch => 80, --80
        v_front_porch => 3, --1
        h_sync_pulse => 128, --136
        v_sync_pulse => 4, --3
        h_sync_positive => false, -- false
        v_sync_positive => true -- true
    )
    port map(
        clk_pixel => clk2,
        clear => clear_vec(1),
        r_in => r_in,
        g_in => g_in,
        b_in => b_in,
        r_out => r_out_vec(1),
        g_out => g_out_vec(1),
        b_out => b_out_vec(1),
        x => x_vec(1),
        y => y_vec(1),
        hsync => hsync_vec(1),
        vsync => vsync_vec(1),
        last_pixel => last_pixel_vec(1),
        vga_width => vga_width_vec(1),
        vga_height => vga_height_vec(1)
    );
    

end Behavioral;
