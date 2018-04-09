library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.matrix.all;

entity secondstep is
port(
	CLK:						in std_logic; --50MHz Clock
	Reset:					in std_logic; --whenever this is high, intermatrix will be reset to 0
	writeenable:			inout std_logic; --if high, data is written to RAM
	Set_output:					in std_logic
	);
end secondstep;


architecture behave of secondstep is
	shared variable intermatrix: t_2d_array5; --array in which final matrix is stored
	signal counter: unsigned(2 downto 0) :="000" ; --counter to create a slow clock of 10MHz
	signal datavalue: std_logic_vector(7 DOWNTO 0); --signal to store values that go intro ram
	signal writeaddress: std_logic_vector(3 DOWNTO 0) := "0000"; --signal to store address to write in ram
	signal clock_slow: std_logic:='0'; --slower clock
	signal output_vector: vector; -- to simplify sending values to RAM
	shared variable randomnumber: std_logic_vector(7 DOWNTO 0):= "01011110"; --initial random number
	signal counter1: std_logic_vector(7 DOWNTO 0) := "00000000"; --counter to initialize values

	component ram IS
	PORT
	(
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		address		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		wren		: IN STD_LOGIC  := '0'
	);
	END component;
	
begin
--process to initialize every value to zero and then the corner values to some predefined value





--process to initialize corner values and start of the algorithm
Starter: process (Reset)
variable intermediate: std_logic_vector(7 Downto 0);
variable xoredbit: std_logic;

begin
	if (Reset = '0') then
		intermatrix(0)(0):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(0)(1):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(0)(2):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(0)(3):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(0)(4):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(0)(0):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(1)(0):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(2)(0):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(3)(0):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(4)(0):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(0)(0):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(4)(1):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(4)(2):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(4)(3):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(4)(4):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(0)(4):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(1)(4):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(2)(4):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(3)(4):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(3)(4):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(1)(1):=counter1;
		intermatrix(1)(3):=counter1;
		intermatrix(3)(1):=counter1;
		intermatrix(3)(3):=counter1;
		--process to do the square and diamond algorithm
		--square step 1
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(1)(1))+unsigned(intermatrix(1)(3))+unsigned(intermatrix(3)(1))+unsigned(intermatrix(3)(3)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(2)(2):= std_logic_vector(unsigned(intermediate)+unsigned(randomnumber));
		
		-- diamond step 1.1
		intermediate:= std_logic_vector( shift_right(unsigned(intermatrix(1)(1))+unsigned(intermatrix(3)(1))+unsigned(intermatrix(2)(2))+unsigned(intermatrix(2)(0)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(2)(1) := std_logic_vector(unsigned(intermediate) + shift_right(unsigned(randomnumber),2)) ;
		
		-- diamond step 1.2
		intermediate:= std_logic_vector( shift_right(unsigned(intermatrix(1)(1))+unsigned(intermatrix(1)(3))+unsigned(intermatrix(0)(2))+unsigned(intermatrix(2)(2)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(1)(2):= std_logic_vector(unsigned(intermediate) + shift_right(unsigned(randomnumber),2)) ;
		
		-- diamond step 1.3
		intermediate:= std_logic_vector( shift_right(unsigned(intermatrix(1)(1))+unsigned(intermatrix(1)(3))+unsigned(intermatrix(0)(2))+unsigned(intermatrix(2)(2)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(2)(3):= std_logic_vector(unsigned(intermediate) + shift_right(unsigned(randomnumber),2)) ;
		-- diamond step 1.4
		intermediate:= std_logic_vector( shift_right(unsigned(intermatrix(1)(1))+unsigned(intermatrix(1)(3))+unsigned(intermatrix(0)(2))+unsigned(intermatrix(2)(2)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(3)(2):= std_logic_vector(unsigned(intermediate) + shift_right(unsigned(randomnumber),1)) ;
	end if;
end process;

Countter: process (CLK)
begin
if(to_integer(unsigned(counter1))<255) then
counter1 <= std_logic_vector(unsigned(counter1)+1);
else
counter1 <= "00000000";
end if;
end process;


--declaration of ram
v_ram : ram port map(clock=>CLK,data=>datavalue,address=>writeaddress,wren=>writeenable);


--process to create a slower clock so that data is sent to ram efficiently
process(CLK)	
begin
	if(falling_edge(CLK)) then
		counter <= counter+1;
		if(counter = "101" ) then
			counter <= "000";
			clock_slow <= not (clock_slow);
		--	LEDout(0) <= clock_slow;
		end if;
	end if;
end process;	

--process to store matrix elements in output vector
process(clock_slow)
variable position: integer range 0 to 9:=0;
begin
	output_vector(0)<=intermatrix(1)(1);
	output_vector(1)<=intermatrix(1)(2);
	output_vector(2)<=intermatrix(1)(3);
	output_vector(3)<=intermatrix(2)(1);
	output_vector(4)<=intermatrix(2)(2);
	output_vector(5)<=intermatrix(2)(3);
	output_vector(6)<=intermatrix(3)(1);
	output_vector(7)<=intermatrix(3)(2);
	output_vector(8)<=intermatrix(3)(3);
end process;


--process to write intermatrix components to RAM signals
process(clock_slow)
begin
	if(Set_output='0') then
		if(to_integer(unsigned(writeaddress))<11) then 
			writeenable <= '0';
			
			if(falling_edge(clock_slow)) then

				
				datavalue<=output_vector(to_integer(unsigned(writeaddress)+1));
				writeaddress <= std_logic_vector(unsigned(writeaddress)+1);
				--end if;
			end if;
			writeenable <= '1';
		elsif(to_integer(unsigned(writeaddress))=8) then
			writeaddress <="0000";
			datavalue<=output_vector(0);
		else
			writeaddress <="1000";
			datavalue<=output_vector(8);
		
		end if;
	end if;
end process;

end behave;