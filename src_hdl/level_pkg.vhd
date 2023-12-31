-- This file was generated by map_to_rom.py

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package level_pkg is
    type tile_render_t is record
        tile_id : unsigned(3 downto 0);
        tile_x : unsigned(4 downto 0);
        tile_y : unsigned(4 downto 0);
    end record;

    type tile_render_t_array is array (natural range <>) of tile_render_t;

constant tile_render_rom : tile_render_t_array := (
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(0, 5), tile_y => to_unsigned(0, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(1, 5), tile_y => to_unsigned(0, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(2, 5), tile_y => to_unsigned(0, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(3, 5), tile_y => to_unsigned(0, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(4, 5), tile_y => to_unsigned(0, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(5, 5), tile_y => to_unsigned(0, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(6, 5), tile_y => to_unsigned(0, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(7, 5), tile_y => to_unsigned(0, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(8, 5), tile_y => to_unsigned(0, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(9, 5), tile_y => to_unsigned(0, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(10, 5), tile_y => to_unsigned(0, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(11, 5), tile_y => to_unsigned(0, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(12, 5), tile_y => to_unsigned(0, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(13, 5), tile_y => to_unsigned(0, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(14, 5), tile_y => to_unsigned(0, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(15, 5), tile_y => to_unsigned(0, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(16, 5), tile_y => to_unsigned(0, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(17, 5), tile_y => to_unsigned(0, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(18, 5), tile_y => to_unsigned(0, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(19, 5), tile_y => to_unsigned(0, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(0, 5), tile_y => to_unsigned(1, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(1, 5), tile_y => to_unsigned(1, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(2, 5), tile_y => to_unsigned(1, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(3, 5), tile_y => to_unsigned(1, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(4, 5), tile_y => to_unsigned(1, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(5, 5), tile_y => to_unsigned(1, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(6, 5), tile_y => to_unsigned(1, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(7, 5), tile_y => to_unsigned(1, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(8, 5), tile_y => to_unsigned(1, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(9, 5), tile_y => to_unsigned(1, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(10, 5), tile_y => to_unsigned(1, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(11, 5), tile_y => to_unsigned(1, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(12, 5), tile_y => to_unsigned(1, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(13, 5), tile_y => to_unsigned(1, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(14, 5), tile_y => to_unsigned(1, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(15, 5), tile_y => to_unsigned(1, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(16, 5), tile_y => to_unsigned(1, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(17, 5), tile_y => to_unsigned(1, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(18, 5), tile_y => to_unsigned(1, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(19, 5), tile_y => to_unsigned(1, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(0, 5), tile_y => to_unsigned(2, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(1, 5), tile_y => to_unsigned(2, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(2, 5), tile_y => to_unsigned(2, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(3, 5), tile_y => to_unsigned(2, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(4, 5), tile_y => to_unsigned(2, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(5, 5), tile_y => to_unsigned(2, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(6, 5), tile_y => to_unsigned(2, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(7, 5), tile_y => to_unsigned(2, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(8, 5), tile_y => to_unsigned(2, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(9, 5), tile_y => to_unsigned(2, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(10, 5), tile_y => to_unsigned(2, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(11, 5), tile_y => to_unsigned(2, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(12, 5), tile_y => to_unsigned(2, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(13, 5), tile_y => to_unsigned(2, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(14, 5), tile_y => to_unsigned(2, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(15, 5), tile_y => to_unsigned(2, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(16, 5), tile_y => to_unsigned(2, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(17, 5), tile_y => to_unsigned(2, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(18, 5), tile_y => to_unsigned(2, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(19, 5), tile_y => to_unsigned(2, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(0, 5), tile_y => to_unsigned(3, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(1, 5), tile_y => to_unsigned(3, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(2, 5), tile_y => to_unsigned(3, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(3, 5), tile_y => to_unsigned(3, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(4, 5), tile_y => to_unsigned(3, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(5, 5), tile_y => to_unsigned(3, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(6, 5), tile_y => to_unsigned(3, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(7, 5), tile_y => to_unsigned(3, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(8, 5), tile_y => to_unsigned(3, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(9, 5), tile_y => to_unsigned(3, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(10, 5), tile_y => to_unsigned(3, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(11, 5), tile_y => to_unsigned(3, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(12, 5), tile_y => to_unsigned(3, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(13, 5), tile_y => to_unsigned(3, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(14, 5), tile_y => to_unsigned(3, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(15, 5), tile_y => to_unsigned(3, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(16, 5), tile_y => to_unsigned(3, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(17, 5), tile_y => to_unsigned(3, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(18, 5), tile_y => to_unsigned(3, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(19, 5), tile_y => to_unsigned(3, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(0, 5), tile_y => to_unsigned(4, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(1, 5), tile_y => to_unsigned(4, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(2, 5), tile_y => to_unsigned(4, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(3, 5), tile_y => to_unsigned(4, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(4, 5), tile_y => to_unsigned(4, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(5, 5), tile_y => to_unsigned(4, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(6, 5), tile_y => to_unsigned(4, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(7, 5), tile_y => to_unsigned(4, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(8, 5), tile_y => to_unsigned(4, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(9, 5), tile_y => to_unsigned(4, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(10, 5), tile_y => to_unsigned(4, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(11, 5), tile_y => to_unsigned(4, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(12, 5), tile_y => to_unsigned(4, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(13, 5), tile_y => to_unsigned(4, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(14, 5), tile_y => to_unsigned(4, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(15, 5), tile_y => to_unsigned(4, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(16, 5), tile_y => to_unsigned(4, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(17, 5), tile_y => to_unsigned(4, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(18, 5), tile_y => to_unsigned(4, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(19, 5), tile_y => to_unsigned(4, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(0, 5), tile_y => to_unsigned(5, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(1, 5), tile_y => to_unsigned(5, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(2, 5), tile_y => to_unsigned(5, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(3, 5), tile_y => to_unsigned(5, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(4, 5), tile_y => to_unsigned(5, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(5, 5), tile_y => to_unsigned(5, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(6, 5), tile_y => to_unsigned(5, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(7, 5), tile_y => to_unsigned(5, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(8, 5), tile_y => to_unsigned(5, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(9, 5), tile_y => to_unsigned(5, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(10, 5), tile_y => to_unsigned(5, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(11, 5), tile_y => to_unsigned(5, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(12, 5), tile_y => to_unsigned(5, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(13, 5), tile_y => to_unsigned(5, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(14, 5), tile_y => to_unsigned(5, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(15, 5), tile_y => to_unsigned(5, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(16, 5), tile_y => to_unsigned(5, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(17, 5), tile_y => to_unsigned(5, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(18, 5), tile_y => to_unsigned(5, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(19, 5), tile_y => to_unsigned(5, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(0, 5), tile_y => to_unsigned(6, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(1, 5), tile_y => to_unsigned(6, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(2, 5), tile_y => to_unsigned(6, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(3, 5), tile_y => to_unsigned(6, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(4, 5), tile_y => to_unsigned(6, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(5, 5), tile_y => to_unsigned(6, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(6, 5), tile_y => to_unsigned(6, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(7, 5), tile_y => to_unsigned(6, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(8, 5), tile_y => to_unsigned(6, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(9, 5), tile_y => to_unsigned(6, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(10, 5), tile_y => to_unsigned(6, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(11, 5), tile_y => to_unsigned(6, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(12, 5), tile_y => to_unsigned(6, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(13, 5), tile_y => to_unsigned(6, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(14, 5), tile_y => to_unsigned(6, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(15, 5), tile_y => to_unsigned(6, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(16, 5), tile_y => to_unsigned(6, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(17, 5), tile_y => to_unsigned(6, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(18, 5), tile_y => to_unsigned(6, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(19, 5), tile_y => to_unsigned(6, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(0, 5), tile_y => to_unsigned(7, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(1, 5), tile_y => to_unsigned(7, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(2, 5), tile_y => to_unsigned(7, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(3, 5), tile_y => to_unsigned(7, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(4, 5), tile_y => to_unsigned(7, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(5, 5), tile_y => to_unsigned(7, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(6, 5), tile_y => to_unsigned(7, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(7, 5), tile_y => to_unsigned(7, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(8, 5), tile_y => to_unsigned(7, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(9, 5), tile_y => to_unsigned(7, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(10, 5), tile_y => to_unsigned(7, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(11, 5), tile_y => to_unsigned(7, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(12, 5), tile_y => to_unsigned(7, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(13, 5), tile_y => to_unsigned(7, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(14, 5), tile_y => to_unsigned(7, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(15, 5), tile_y => to_unsigned(7, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(16, 5), tile_y => to_unsigned(7, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(17, 5), tile_y => to_unsigned(7, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(18, 5), tile_y => to_unsigned(7, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(19, 5), tile_y => to_unsigned(7, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(0, 5), tile_y => to_unsigned(8, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(1, 5), tile_y => to_unsigned(8, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(2, 5), tile_y => to_unsigned(8, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(3, 5), tile_y => to_unsigned(8, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(4, 5), tile_y => to_unsigned(8, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(5, 5), tile_y => to_unsigned(8, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(6, 5), tile_y => to_unsigned(8, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(7, 5), tile_y => to_unsigned(8, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(8, 5), tile_y => to_unsigned(8, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(9, 5), tile_y => to_unsigned(8, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(10, 5), tile_y => to_unsigned(8, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(11, 5), tile_y => to_unsigned(8, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(12, 5), tile_y => to_unsigned(8, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(13, 5), tile_y => to_unsigned(8, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(14, 5), tile_y => to_unsigned(8, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(15, 5), tile_y => to_unsigned(8, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(16, 5), tile_y => to_unsigned(8, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(17, 5), tile_y => to_unsigned(8, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(18, 5), tile_y => to_unsigned(8, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(19, 5), tile_y => to_unsigned(8, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(0, 5), tile_y => to_unsigned(9, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(1, 5), tile_y => to_unsigned(9, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(2, 5), tile_y => to_unsigned(9, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(3, 5), tile_y => to_unsigned(9, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(4, 5), tile_y => to_unsigned(9, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(5, 5), tile_y => to_unsigned(9, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(6, 5), tile_y => to_unsigned(9, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(7, 5), tile_y => to_unsigned(9, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(8, 5), tile_y => to_unsigned(9, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(9, 5), tile_y => to_unsigned(9, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(10, 5), tile_y => to_unsigned(9, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(11, 5), tile_y => to_unsigned(9, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(12, 5), tile_y => to_unsigned(9, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(13, 5), tile_y => to_unsigned(9, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(14, 5), tile_y => to_unsigned(9, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(15, 5), tile_y => to_unsigned(9, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(16, 5), tile_y => to_unsigned(9, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(17, 5), tile_y => to_unsigned(9, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(18, 5), tile_y => to_unsigned(9, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(19, 5), tile_y => to_unsigned(9, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(0, 5), tile_y => to_unsigned(10, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(1, 5), tile_y => to_unsigned(10, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(2, 5), tile_y => to_unsigned(10, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(3, 5), tile_y => to_unsigned(10, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(4, 5), tile_y => to_unsigned(10, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(5, 5), tile_y => to_unsigned(10, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(6, 5), tile_y => to_unsigned(10, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(7, 5), tile_y => to_unsigned(10, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(8, 5), tile_y => to_unsigned(10, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(9, 5), tile_y => to_unsigned(10, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(10, 5), tile_y => to_unsigned(10, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(11, 5), tile_y => to_unsigned(10, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(12, 5), tile_y => to_unsigned(10, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(13, 5), tile_y => to_unsigned(10, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(14, 5), tile_y => to_unsigned(10, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(15, 5), tile_y => to_unsigned(10, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(16, 5), tile_y => to_unsigned(10, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(17, 5), tile_y => to_unsigned(10, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(18, 5), tile_y => to_unsigned(10, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(19, 5), tile_y => to_unsigned(10, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(0, 5), tile_y => to_unsigned(11, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(1, 5), tile_y => to_unsigned(11, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(2, 5), tile_y => to_unsigned(11, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(3, 5), tile_y => to_unsigned(11, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(4, 5), tile_y => to_unsigned(11, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(5, 5), tile_y => to_unsigned(11, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(6, 5), tile_y => to_unsigned(11, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(7, 5), tile_y => to_unsigned(11, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(8, 5), tile_y => to_unsigned(11, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(9, 5), tile_y => to_unsigned(11, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(10, 5), tile_y => to_unsigned(11, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(11, 5), tile_y => to_unsigned(11, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(12, 5), tile_y => to_unsigned(11, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(13, 5), tile_y => to_unsigned(11, 5)),
(tile_id => to_unsigned(0, 4), tile_x => to_unsigned(14, 5), tile_y => to_unsigned(11, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(15, 5), tile_y => to_unsigned(11, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(16, 5), tile_y => to_unsigned(11, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(17, 5), tile_y => to_unsigned(11, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(18, 5), tile_y => to_unsigned(11, 5)),
(tile_id => to_unsigned(2, 4), tile_x => to_unsigned(19, 5), tile_y => to_unsigned(11, 5)),
(tile_id => to_unsigned(1, 4), tile_x => to_unsigned(0, 5), tile_y => to_unsigned(0, 5)),
(tile_id => to_unsigned(5, 4), tile_x => to_unsigned(1, 5), tile_y => to_unsigned(0, 5)),
(tile_id => to_unsigned(8, 4), tile_x => to_unsigned(2, 5), tile_y => to_unsigned(0, 5)),
(tile_id => to_unsigned(9, 4), tile_x => to_unsigned(3, 5), tile_y => to_unsigned(0, 5)),
(tile_id => to_unsigned(8, 4), tile_x => to_unsigned(4, 5), tile_y => to_unsigned(0, 5)),
(tile_id => to_unsigned(1, 4), tile_x => to_unsigned(5, 5), tile_y => to_unsigned(0, 5)),
(tile_id => to_unsigned(9, 4), tile_x => to_unsigned(6, 5), tile_y => to_unsigned(0, 5)),
(tile_id => to_unsigned(5, 4), tile_x => to_unsigned(7, 5), tile_y => to_unsigned(0, 5)),
(tile_id => to_unsigned(5, 4), tile_x => to_unsigned(8, 5), tile_y => to_unsigned(0, 5)),
(tile_id => to_unsigned(8, 4), tile_x => to_unsigned(9, 5), tile_y => to_unsigned(0, 5)),
(tile_id => to_unsigned(1, 4), tile_x => to_unsigned(10, 5), tile_y => to_unsigned(0, 5)),
(tile_id => to_unsigned(1, 4), tile_x => to_unsigned(11, 5), tile_y => to_unsigned(0, 5)),
(tile_id => to_unsigned(5, 4), tile_x => to_unsigned(12, 5), tile_y => to_unsigned(0, 5)),
(tile_id => to_unsigned(1, 4), tile_x => to_unsigned(13, 5), tile_y => to_unsigned(0, 5)),
(tile_id => to_unsigned(5, 4), tile_x => to_unsigned(14, 5), tile_y => to_unsigned(0, 5)),
(tile_id => to_unsigned(9, 4), tile_x => to_unsigned(15, 5), tile_y => to_unsigned(0, 5)),
(tile_id => to_unsigned(5, 4), tile_x => to_unsigned(16, 5), tile_y => to_unsigned(0, 5)),
(tile_id => to_unsigned(5, 4), tile_x => to_unsigned(17, 5), tile_y => to_unsigned(0, 5)),
(tile_id => to_unsigned(5, 4), tile_x => to_unsigned(18, 5), tile_y => to_unsigned(0, 5)),
(tile_id => to_unsigned(9, 4), tile_x => to_unsigned(19, 5), tile_y => to_unsigned(0, 5)),
(tile_id => to_unsigned(5, 4), tile_x => to_unsigned(0, 5), tile_y => to_unsigned(1, 5)),
(tile_id => to_unsigned(13, 4), tile_x => to_unsigned(2, 5), tile_y => to_unsigned(1, 5)),
(tile_id => to_unsigned(13, 4), tile_x => to_unsigned(3, 5), tile_y => to_unsigned(1, 5)),
(tile_id => to_unsigned(3, 4), tile_x => to_unsigned(6, 5), tile_y => to_unsigned(1, 5)),
(tile_id => to_unsigned(7, 4), tile_x => to_unsigned(9, 5), tile_y => to_unsigned(1, 5)),
(tile_id => to_unsigned(11, 4), tile_x => to_unsigned(12, 5), tile_y => to_unsigned(1, 5)),
(tile_id => to_unsigned(12, 4), tile_x => to_unsigned(14, 5), tile_y => to_unsigned(1, 5)),
(tile_id => to_unsigned(3, 4), tile_x => to_unsigned(16, 5), tile_y => to_unsigned(1, 5)),
(tile_id => to_unsigned(9, 4), tile_x => to_unsigned(19, 5), tile_y => to_unsigned(1, 5)),
(tile_id => to_unsigned(5, 4), tile_x => to_unsigned(0, 5), tile_y => to_unsigned(2, 5)),
(tile_id => to_unsigned(11, 4), tile_x => to_unsigned(3, 5), tile_y => to_unsigned(2, 5)),
(tile_id => to_unsigned(13, 4), tile_x => to_unsigned(4, 5), tile_y => to_unsigned(2, 5)),
(tile_id => to_unsigned(13, 4), tile_x => to_unsigned(5, 5), tile_y => to_unsigned(2, 5)),
(tile_id => to_unsigned(11, 4), tile_x => to_unsigned(6, 5), tile_y => to_unsigned(2, 5)),
(tile_id => to_unsigned(7, 4), tile_x => to_unsigned(7, 5), tile_y => to_unsigned(2, 5)),
(tile_id => to_unsigned(12, 4), tile_x => to_unsigned(15, 5), tile_y => to_unsigned(2, 5)),
(tile_id => to_unsigned(15, 4), tile_x => to_unsigned(17, 5), tile_y => to_unsigned(2, 5)),
(tile_id => to_unsigned(13, 4), tile_x => to_unsigned(18, 5), tile_y => to_unsigned(2, 5)),
(tile_id => to_unsigned(1, 4), tile_x => to_unsigned(19, 5), tile_y => to_unsigned(2, 5)),
(tile_id => to_unsigned(9, 4), tile_x => to_unsigned(0, 5), tile_y => to_unsigned(3, 5)),
(tile_id => to_unsigned(7, 4), tile_x => to_unsigned(6, 5), tile_y => to_unsigned(3, 5)),
(tile_id => to_unsigned(13, 4), tile_x => to_unsigned(11, 5), tile_y => to_unsigned(3, 5)),
(tile_id => to_unsigned(3, 4), tile_x => to_unsigned(12, 5), tile_y => to_unsigned(3, 5)),
(tile_id => to_unsigned(13, 4), tile_x => to_unsigned(13, 5), tile_y => to_unsigned(3, 5)),
(tile_id => to_unsigned(13, 4), tile_x => to_unsigned(14, 5), tile_y => to_unsigned(3, 5)),
(tile_id => to_unsigned(11, 4), tile_x => to_unsigned(16, 5), tile_y => to_unsigned(3, 5)),
(tile_id => to_unsigned(1, 4), tile_x => to_unsigned(19, 5), tile_y => to_unsigned(3, 5)),
(tile_id => to_unsigned(9, 4), tile_x => to_unsigned(0, 5), tile_y => to_unsigned(4, 5)),
(tile_id => to_unsigned(15, 4), tile_x => to_unsigned(1, 5), tile_y => to_unsigned(4, 5)),
(tile_id => to_unsigned(11, 4), tile_x => to_unsigned(10, 5), tile_y => to_unsigned(4, 5)),
(tile_id => to_unsigned(13, 4), tile_x => to_unsigned(11, 5), tile_y => to_unsigned(4, 5)),
(tile_id => to_unsigned(7, 4), tile_x => to_unsigned(14, 5), tile_y => to_unsigned(4, 5)),
(tile_id => to_unsigned(7, 4), tile_x => to_unsigned(18, 5), tile_y => to_unsigned(4, 5)),
(tile_id => to_unsigned(1, 4), tile_x => to_unsigned(19, 5), tile_y => to_unsigned(4, 5)),
(tile_id => to_unsigned(5, 4), tile_x => to_unsigned(0, 5), tile_y => to_unsigned(5, 5)),
(tile_id => to_unsigned(7, 4), tile_x => to_unsigned(1, 5), tile_y => to_unsigned(5, 5)),
(tile_id => to_unsigned(7, 4), tile_x => to_unsigned(3, 5), tile_y => to_unsigned(5, 5)),
(tile_id => to_unsigned(15, 4), tile_x => to_unsigned(5, 5), tile_y => to_unsigned(5, 5)),
(tile_id => to_unsigned(13, 4), tile_x => to_unsigned(6, 5), tile_y => to_unsigned(5, 5)),
(tile_id => to_unsigned(15, 4), tile_x => to_unsigned(10, 5), tile_y => to_unsigned(5, 5)),
(tile_id => to_unsigned(3, 4), tile_x => to_unsigned(11, 5), tile_y => to_unsigned(5, 5)),
(tile_id => to_unsigned(7, 4), tile_x => to_unsigned(12, 5), tile_y => to_unsigned(5, 5)),
(tile_id => to_unsigned(7, 4), tile_x => to_unsigned(15, 5), tile_y => to_unsigned(5, 5)),
(tile_id => to_unsigned(13, 4), tile_x => to_unsigned(17, 5), tile_y => to_unsigned(5, 5)),
(tile_id => to_unsigned(7, 4), tile_x => to_unsigned(18, 5), tile_y => to_unsigned(5, 5)),
(tile_id => to_unsigned(5, 4), tile_x => to_unsigned(19, 5), tile_y => to_unsigned(5, 5)),
(tile_id => to_unsigned(9, 4), tile_x => to_unsigned(0, 5), tile_y => to_unsigned(6, 5)),
(tile_id => to_unsigned(11, 4), tile_x => to_unsigned(1, 5), tile_y => to_unsigned(6, 5)),
(tile_id => to_unsigned(15, 4), tile_x => to_unsigned(3, 5), tile_y => to_unsigned(6, 5)),
(tile_id => to_unsigned(13, 4), tile_x => to_unsigned(7, 5), tile_y => to_unsigned(6, 5)),
(tile_id => to_unsigned(13, 4), tile_x => to_unsigned(8, 5), tile_y => to_unsigned(6, 5)),
(tile_id => to_unsigned(12, 4), tile_x => to_unsigned(12, 5), tile_y => to_unsigned(6, 5)),
(tile_id => to_unsigned(7, 4), tile_x => to_unsigned(14, 5), tile_y => to_unsigned(6, 5)),
(tile_id => to_unsigned(11, 4), tile_x => to_unsigned(18, 5), tile_y => to_unsigned(6, 5)),
(tile_id => to_unsigned(1, 4), tile_x => to_unsigned(19, 5), tile_y => to_unsigned(6, 5)),
(tile_id => to_unsigned(1, 4), tile_x => to_unsigned(0, 5), tile_y => to_unsigned(7, 5)),
(tile_id => to_unsigned(13, 4), tile_x => to_unsigned(1, 5), tile_y => to_unsigned(7, 5)),
(tile_id => to_unsigned(12, 4), tile_x => to_unsigned(3, 5), tile_y => to_unsigned(7, 5)),
(tile_id => to_unsigned(15, 4), tile_x => to_unsigned(4, 5), tile_y => to_unsigned(7, 5)),
(tile_id => to_unsigned(13, 4), tile_x => to_unsigned(5, 5), tile_y => to_unsigned(7, 5)),
(tile_id => to_unsigned(15, 4), tile_x => to_unsigned(7, 5), tile_y => to_unsigned(7, 5)),
(tile_id => to_unsigned(7, 4), tile_x => to_unsigned(12, 5), tile_y => to_unsigned(7, 5)),
(tile_id => to_unsigned(7, 4), tile_x => to_unsigned(14, 5), tile_y => to_unsigned(7, 5)),
(tile_id => to_unsigned(9, 4), tile_x => to_unsigned(19, 5), tile_y => to_unsigned(7, 5)),
(tile_id => to_unsigned(1, 4), tile_x => to_unsigned(0, 5), tile_y => to_unsigned(8, 5)),
(tile_id => to_unsigned(15, 4), tile_x => to_unsigned(1, 5), tile_y => to_unsigned(8, 5)),
(tile_id => to_unsigned(3, 4), tile_x => to_unsigned(3, 5), tile_y => to_unsigned(8, 5)),
(tile_id => to_unsigned(7, 4), tile_x => to_unsigned(5, 5), tile_y => to_unsigned(8, 5)),
(tile_id => to_unsigned(12, 4), tile_x => to_unsigned(6, 5), tile_y => to_unsigned(8, 5)),
(tile_id => to_unsigned(13, 4), tile_x => to_unsigned(12, 5), tile_y => to_unsigned(8, 5)),
(tile_id => to_unsigned(3, 4), tile_x => to_unsigned(15, 5), tile_y => to_unsigned(8, 5)),
(tile_id => to_unsigned(13, 4), tile_x => to_unsigned(16, 5), tile_y => to_unsigned(8, 5)),
(tile_id => to_unsigned(15, 4), tile_x => to_unsigned(17, 5), tile_y => to_unsigned(8, 5)),
(tile_id => to_unsigned(13, 4), tile_x => to_unsigned(18, 5), tile_y => to_unsigned(8, 5)),
(tile_id => to_unsigned(1, 4), tile_x => to_unsigned(19, 5), tile_y => to_unsigned(8, 5)),
(tile_id => to_unsigned(8, 4), tile_x => to_unsigned(0, 5), tile_y => to_unsigned(9, 5)),
(tile_id => to_unsigned(15, 4), tile_x => to_unsigned(1, 5), tile_y => to_unsigned(9, 5)),
(tile_id => to_unsigned(3, 4), tile_x => to_unsigned(2, 5), tile_y => to_unsigned(9, 5)),
(tile_id => to_unsigned(13, 4), tile_x => to_unsigned(4, 5), tile_y => to_unsigned(9, 5)),
(tile_id => to_unsigned(11, 4), tile_x => to_unsigned(7, 5), tile_y => to_unsigned(9, 5)),
(tile_id => to_unsigned(13, 4), tile_x => to_unsigned(8, 5), tile_y => to_unsigned(9, 5)),
(tile_id => to_unsigned(15, 4), tile_x => to_unsigned(11, 5), tile_y => to_unsigned(9, 5)),
(tile_id => to_unsigned(3, 4), tile_x => to_unsigned(12, 5), tile_y => to_unsigned(9, 5)),
(tile_id => to_unsigned(11, 4), tile_x => to_unsigned(13, 5), tile_y => to_unsigned(9, 5)),
(tile_id => to_unsigned(3, 4), tile_x => to_unsigned(14, 5), tile_y => to_unsigned(9, 5)),
(tile_id => to_unsigned(7, 4), tile_x => to_unsigned(15, 5), tile_y => to_unsigned(9, 5)),
(tile_id => to_unsigned(7, 4), tile_x => to_unsigned(18, 5), tile_y => to_unsigned(9, 5)),
(tile_id => to_unsigned(5, 4), tile_x => to_unsigned(19, 5), tile_y => to_unsigned(9, 5)),
(tile_id => to_unsigned(8, 4), tile_x => to_unsigned(0, 5), tile_y => to_unsigned(10, 5)),
(tile_id => to_unsigned(5, 4), tile_x => to_unsigned(1, 5), tile_y => to_unsigned(10, 5)),
(tile_id => to_unsigned(9, 4), tile_x => to_unsigned(2, 5), tile_y => to_unsigned(10, 5)),
(tile_id => to_unsigned(9, 4), tile_x => to_unsigned(3, 5), tile_y => to_unsigned(10, 5)),
(tile_id => to_unsigned(1, 4), tile_x => to_unsigned(4, 5), tile_y => to_unsigned(10, 5)),
(tile_id => to_unsigned(5, 4), tile_x => to_unsigned(5, 5), tile_y => to_unsigned(10, 5)),
(tile_id => to_unsigned(5, 4), tile_x => to_unsigned(6, 5), tile_y => to_unsigned(10, 5)),
(tile_id => to_unsigned(9, 4), tile_x => to_unsigned(7, 5), tile_y => to_unsigned(10, 5)),
(tile_id => to_unsigned(1, 4), tile_x => to_unsigned(8, 5), tile_y => to_unsigned(10, 5)),
(tile_id => to_unsigned(9, 4), tile_x => to_unsigned(9, 5), tile_y => to_unsigned(10, 5)),
(tile_id => to_unsigned(5, 4), tile_x => to_unsigned(10, 5), tile_y => to_unsigned(10, 5)),
(tile_id => to_unsigned(9, 4), tile_x => to_unsigned(11, 5), tile_y => to_unsigned(10, 5)),
(tile_id => to_unsigned(1, 4), tile_x => to_unsigned(12, 5), tile_y => to_unsigned(10, 5)),
(tile_id => to_unsigned(8, 4), tile_x => to_unsigned(13, 5), tile_y => to_unsigned(10, 5)),
(tile_id => to_unsigned(9, 4), tile_x => to_unsigned(14, 5), tile_y => to_unsigned(10, 5)),
(tile_id => to_unsigned(8, 4), tile_x => to_unsigned(15, 5), tile_y => to_unsigned(10, 5)),
(tile_id => to_unsigned(5, 4), tile_x => to_unsigned(16, 5), tile_y => to_unsigned(10, 5)),
(tile_id => to_unsigned(8, 4), tile_x => to_unsigned(17, 5), tile_y => to_unsigned(10, 5)),
(tile_id => to_unsigned(8, 4), tile_x => to_unsigned(18, 5), tile_y => to_unsigned(10, 5)),
(tile_id => to_unsigned(5, 4), tile_x => to_unsigned(19, 5), tile_y => to_unsigned(10, 5)),
(tile_id => to_unsigned(9, 4), tile_x => to_unsigned(0, 5), tile_y => to_unsigned(11, 5)),
(tile_id => to_unsigned(1, 4), tile_x => to_unsigned(1, 5), tile_y => to_unsigned(11, 5)),
(tile_id => to_unsigned(5, 4), tile_x => to_unsigned(2, 5), tile_y => to_unsigned(11, 5)),
(tile_id => to_unsigned(9, 4), tile_x => to_unsigned(3, 5), tile_y => to_unsigned(11, 5)),
(tile_id => to_unsigned(5, 4), tile_x => to_unsigned(4, 5), tile_y => to_unsigned(11, 5)),
(tile_id => to_unsigned(8, 4), tile_x => to_unsigned(5, 5), tile_y => to_unsigned(11, 5)),
(tile_id => to_unsigned(5, 4), tile_x => to_unsigned(6, 5), tile_y => to_unsigned(11, 5)),
(tile_id => to_unsigned(9, 4), tile_x => to_unsigned(7, 5), tile_y => to_unsigned(11, 5)),
(tile_id => to_unsigned(9, 4), tile_x => to_unsigned(8, 5), tile_y => to_unsigned(11, 5)),
(tile_id => to_unsigned(9, 4), tile_x => to_unsigned(9, 5), tile_y => to_unsigned(11, 5)),
(tile_id => to_unsigned(8, 4), tile_x => to_unsigned(10, 5), tile_y => to_unsigned(11, 5)),
(tile_id => to_unsigned(8, 4), tile_x => to_unsigned(11, 5), tile_y => to_unsigned(11, 5)),
(tile_id => to_unsigned(8, 4), tile_x => to_unsigned(12, 5), tile_y => to_unsigned(11, 5)),
(tile_id => to_unsigned(9, 4), tile_x => to_unsigned(13, 5), tile_y => to_unsigned(11, 5)),
(tile_id => to_unsigned(8, 4), tile_x => to_unsigned(14, 5), tile_y => to_unsigned(11, 5)),
(tile_id => to_unsigned(5, 4), tile_x => to_unsigned(15, 5), tile_y => to_unsigned(11, 5)),
(tile_id => to_unsigned(9, 4), tile_x => to_unsigned(16, 5), tile_y => to_unsigned(11, 5)),
(tile_id => to_unsigned(1, 4), tile_x => to_unsigned(17, 5), tile_y => to_unsigned(11, 5)),
(tile_id => to_unsigned(1, 4), tile_x => to_unsigned(18, 5), tile_y => to_unsigned(11, 5)),
(tile_id => to_unsigned(9, 4), tile_x => to_unsigned(19, 5), tile_y => to_unsigned(11, 5))
);
end level_pkg;