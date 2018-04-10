library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package matrix is

   type t_1d_array3 is array(integer range 0 to 2) of std_logic_vector(7 downto 0);
   type t_2d_array3 is array(integer range 0 to 2) of t_1d_array3;
	type t_1d_array5 is array(integer range 0 to 4) of std_logic_vector(7 downto 0);
   type t_2d_array5 is array(integer range 0 to 4) of t_1d_array5;
	type t_1d_array7 is array(integer range 0 to 6) of std_logic_vector(7 downto 0);
   type t_2d_array7 is array(integer range 0 to 6) of t_1d_array7;
	type t_1d_array9 is array(integer range 0 to 8) of std_logic_vector(7 downto 0);
   type t_2d_array9 is array(integer range 0 to 8) of t_1d_array9;
	type vector is array(integer range 0 to 80) of std_logic_vector(7 downto 0);

end  matrix;