library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.matrix.all;

entity ninecrossnine is
port(
	CLK:						in std_logic; --50MHz Clock
	Reset:					in std_logic; --whenever this is high, intermatrix will be reset to 0
	writeenable:			inout std_logic:='0'; --if high, data is written to RAM
	Set_output:					in std_logic
	);
end ninecrossnine;

architecture behave of ninecrossnine is
	shared variable intermatrix: t_2d_array9; --array in which final matrix is stored
	signal counter: unsigned(2 downto 0) :="000" ; --counter to create a slow clock of 10MHz
	signal datavalue: std_logic_vector(7 DOWNTO 0); --signal to store values that go intro ram
	signal writeaddress: std_logic_vector(6 DOWNTO 0) := "0000000"; --signal to store address to write in ram
	signal clock_slow: std_logic:='0'; --slower clock
	signal output_vector: vector; -- to simplify sending values to RAM
	shared variable randomnumber: std_logic_vector(7 DOWNTO 0):= "01011110"; --initial random number
	signal counter1: std_logic_vector(7 DOWNTO 0) := "00000000"; --counter to initialize values

component ram IS
	PORT
	(
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		address		: IN STD_LOGIC_VECTOR (6 DOWNTO 0);
		wren		: IN STD_LOGIC  := '0'
	);
	END component;

	
begin
--process to execute algorithm
Starter: process (Reset)
variable intermediate: std_logic_vector(7 Downto 0);
variable xoredbit: std_logic;


begin
	if (Reset = '0') then
		--to initialize outer values to zero
		--setting 1st row to zero
		intermatrix(0)(0):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(0)(1):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(0)(2):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(0)(3):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(0)(4):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(0)(5):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(0)(6):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(0)(7):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(0)(8):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		--setting last row to zero
		intermatrix(8)(0):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(8)(1):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(8)(2):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(8)(3):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(8)(4):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(8)(5):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(8)(6):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(8)(7):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(8)(8):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		--setting 1st coloumn to zero
		intermatrix(0)(0):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(1)(0):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(2)(0):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(3)(0):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(4)(0):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(5)(0):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(6)(0):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(7)(0):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(8)(0):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		--setting last coloumn to zero
		intermatrix(0)(8):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(1)(8):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(2)(8):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(3)(8):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(4)(8):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(5)(8):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(6)(8):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(7)(8):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		intermatrix(8)(8):=std_logic_vector(to_signed(0,intermatrix(0)(0)'length));
		
		
		--initializing corner values to pseudo random number by using a counter
		intermatrix(0)(0):=counter1;
		intermatrix(0)(8):=counter1;
		intermatrix(8)(0):=counter1;
		intermatrix(8)(8):=counter1;
		
		--process to do the square and diamond algorithm
		--square step 1
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(0)(0))+unsigned(intermatrix(8)(0))+unsigned(intermatrix(8)(8))+unsigned(intermatrix(0)(8)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(4)(4):= std_logic_vector(unsigned(intermediate)+unsigned(randomnumber));
		
-- diamond step 2.1
		intermediate:= std_logic_vector( shift_right(unsigned(intermatrix(0)(0))+unsigned(intermatrix(4)(4))+unsigned(intermatrix(8)(0)),2));--Note that only three values are here
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(4)(0) := std_logic_vector(unsigned(intermediate) + shift_right(unsigned(randomnumber),2)) ;
		
		-- diamond step 2.2
		intermediate:= std_logic_vector( shift_right(unsigned(intermatrix(0)(0))+unsigned(intermatrix(0)(8))+unsigned(intermatrix(4)(4)),2));--Note the three terms
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(0)(4):= std_logic_vector(unsigned(intermediate) + shift_right(unsigned(randomnumber),2)) ;

		-- diamond step 2.3
		intermediate:= std_logic_vector( shift_right(unsigned(intermatrix(0)(8))+unsigned(intermatrix(4)(4))+unsigned(intermatrix(8)(8)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(4)(8):= std_logic_vector(unsigned(intermediate) + shift_right(unsigned(randomnumber),2)) ;
		
		-- diamond step 2.4
		intermediate:= std_logic_vector( shift_right(unsigned(intermatrix(4)(4))+unsigned(intermatrix(8)(0))+unsigned(intermatrix(8)(8)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(8)(4):= std_logic_vector(unsigned(intermediate) + shift_right(unsigned(randomnumber),2)) ;
		
		--square step 3.1
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(0)(0))+unsigned(intermatrix(4)(0))+unsigned(intermatrix(4)(4))+unsigned(intermatrix(0)(4)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(2)(2):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),3));

		--square step 3.2
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(0)(4))+unsigned(intermatrix(0)(8))+unsigned(intermatrix(4)(4))+unsigned(intermatrix(4)(8)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(2)(6):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),3));
		
		--square step 3.3
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(4)(0))+unsigned(intermatrix(8)(0))+unsigned(intermatrix(8)(4))+unsigned(intermatrix(4)(4)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(6)(2):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),3));
		
		--square step 3.4
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(4)(4))+unsigned(intermatrix(8)(4))+unsigned(intermatrix(8)(8))+unsigned(intermatrix(4)(8)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(6)(6):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),3));
		
		--diamond step 4.1
		intermediate:= std_logic_vector( shift_right(unsigned(intermatrix(0)(0))+unsigned(intermatrix(4)(0))+unsigned(intermatrix(2)(2)),2));--Note that only three values are here
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(2)(0) := std_logic_vector(unsigned(intermediate) + shift_right(unsigned(randomnumber),4)) ;

		--diamond step 4.2
		intermediate:= std_logic_vector( shift_right(unsigned(intermatrix(0)(0))+unsigned(intermatrix(2)(2))+unsigned(intermatrix(0)(4)),2));--Note that only three values are here
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(0)(2) := std_logic_vector(unsigned(intermediate) + shift_right(unsigned(randomnumber),4)) ;

	
		--diamond step 4.3
		intermediate:= std_logic_vector( shift_right(unsigned(intermatrix(0)(4))+unsigned(intermatrix(2)(2))+unsigned(intermatrix(4)(4))+unsigned(intermatrix(2)(6)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(2)(4) := std_logic_vector(unsigned(intermediate) + shift_right(unsigned(randomnumber),4)) ;

		--diamond step 4.4
		intermediate:= std_logic_vector( shift_right(unsigned(intermatrix(4)(0))+unsigned(intermatrix(2)(2))+unsigned(intermatrix(4)(4))+unsigned(intermatrix(6)(2)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(4)(2) := std_logic_vector(unsigned(intermediate) + shift_right(unsigned(randomnumber),4)) ;

		--diamond step 4.5
		intermediate:= std_logic_vector( shift_right(unsigned(intermatrix(4)(0))+unsigned(intermatrix(6)(2))+unsigned(intermatrix(8)(0)),2));--Note that only three values are here
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(6)(0) := std_logic_vector(unsigned(intermediate) + shift_right(unsigned(randomnumber),4)) ;

		--diamond step 4.6
		intermediate:= std_logic_vector( shift_right(unsigned(intermatrix(8)(0))+unsigned(intermatrix(8)(4))+unsigned(intermatrix(6)(2)),2));--Note that only three values are here
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(8)(2) := std_logic_vector(unsigned(intermediate) + shift_right(unsigned(randomnumber),4)) ;

		--diamond step 4.7
		intermediate:= std_logic_vector( shift_right(unsigned(intermatrix(8)(4))+unsigned(intermatrix(8)(8))+unsigned(intermatrix(6)(6)),2));--Note that only three values are here
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(8)(6) := std_logic_vector(unsigned(intermediate) + shift_right(unsigned(randomnumber),4)) ;

		--diamond step 4.8
		intermediate:= std_logic_vector( shift_right(unsigned(intermatrix(6)(6))+unsigned(intermatrix(8)(8))+unsigned(intermatrix(4)(8)),2));--Note that only three values are here
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(6)(8) := std_logic_vector(unsigned(intermediate) + shift_right(unsigned(randomnumber),4)) ;

		--diamond step 4.9
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(0)(8))+unsigned(intermatrix(4)(8))+unsigned(intermatrix(2)(6)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(2)(8):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),4));

		--diamond step 4.10
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(0)(8))+unsigned(intermatrix(2)(6))+unsigned(intermatrix(0)(4)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(0)(6):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),4));

		--diamond step 4.11
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(6)(2))+unsigned(intermatrix(8)(4))+unsigned(intermatrix(6)(6))+unsigned(intermatrix(4)(4)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(6)(4):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),4));

		--diamond step 4.12
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(4)(4))+unsigned(intermatrix(6)(6))+unsigned(intermatrix(4)(8))+unsigned(intermatrix(2)(6)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(4)(6):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),4));
	
		--square step 5.1
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(0)(0))+unsigned(intermatrix(2)(0))+unsigned(intermatrix(2)(2))+unsigned(intermatrix(0)(2)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(1)(1):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),5));


		--square step 5.2
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(0)(2))+unsigned(intermatrix(2)(2))+unsigned(intermatrix(2)(4))+unsigned(intermatrix(0)(4)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(1)(3):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),5));

		--square step 5.3
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(0)(4))+unsigned(intermatrix(2)(4))+unsigned(intermatrix(2)(6))+unsigned(intermatrix(0)(6)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(1)(5):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),5));

		--square step 5.4
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(0)(6))+unsigned(intermatrix(2)(6))+unsigned(intermatrix(2)(8))+unsigned(intermatrix(0)(8)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(1)(7):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),5));


		--square step 5.5
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(2)(0))+unsigned(intermatrix(4)(0))+unsigned(intermatrix(2)(2))+unsigned(intermatrix(4)(2)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(3)(1):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),5));


		--square step 5.6
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(2)(2))+unsigned(intermatrix(4)(2))+unsigned(intermatrix(2)(4))+unsigned(intermatrix(4)(4)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(3)(3):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),5));

		--square step 5.7
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(4)(4))+unsigned(intermatrix(2)(4))+unsigned(intermatrix(2)(6))+unsigned(intermatrix(4)(6)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(3)(5):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),5));

		--square step 5.8
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(4)(6))+unsigned(intermatrix(2)(6))+unsigned(intermatrix(2)(8))+unsigned(intermatrix(4)(8)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(3)(7):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),5));

		--square step 5.9
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(4)(0))+unsigned(intermatrix(6)(0))+unsigned(intermatrix(4)(2))+unsigned(intermatrix(6)(2)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(5)(1):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),5));


		--square step 5.10
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(4)(2))+unsigned(intermatrix(6)(2))+unsigned(intermatrix(4)(4))+unsigned(intermatrix(6)(4)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(5)(3):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),5));

		--square step 5.11
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(4)(4))+unsigned(intermatrix(6)(4))+unsigned(intermatrix(4)(6))+unsigned(intermatrix(6)(6)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(5)(5):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),5));

		--square step 5.12
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(4)(6))+unsigned(intermatrix(6)(6))+unsigned(intermatrix(4)(8))+unsigned(intermatrix(6)(8)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(5)(7):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),5));

		--square step 5.13
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(6)(0))+unsigned(intermatrix(8)(0))+unsigned(intermatrix(6)(2))+unsigned(intermatrix(8)(2)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(7)(1):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),5));


		--square step 5.14
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(6)(2))+unsigned(intermatrix(8)(2))+unsigned(intermatrix(6)(4))+unsigned(intermatrix(8)(4)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(7)(3):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),5));

		--square step 5.15
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(6)(4))+unsigned(intermatrix(8)(4))+unsigned(intermatrix(6)(6))+unsigned(intermatrix(8)(6)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(7)(5):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),5));

		--square step 5.16
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(6)(6))+unsigned(intermatrix(8)(6))+unsigned(intermatrix(6)(8))+unsigned(intermatrix(8)(8)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(1)(7):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),5));

        --diamond steps 6.1- 6.16 . these diamond steps find the value at the diamond points on the edge. thus they have sum pf 3 no.s on the 1st line.
        --diamond step 6.1
    	intermediate:= std_logic_vector( shift_right(unsigned(intermatrix(0)(0))+unsigned(intermatrix(1)(1))+unsigned(intermatrix(2)(0)),2));--Note that only three values are here
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(1)(0) := std_logic_vector(unsigned(intermediate) + shift_right(unsigned(randomnumber),6)) ;

		--diamond step 6.2
		intermediate:= std_logic_vector( shift_right(unsigned(intermatrix(2)(0))+unsigned(intermatrix(3)(1))+unsigned(intermatrix(4)(0)),2));--Note that only three values are here
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(3)(0) := std_logic_vector(unsigned(intermediate) + shift_right(unsigned(randomnumber),6)) ;
        

		--diamond step 6.3
		intermediate:= std_logic_vector( shift_right(unsigned(intermatrix(4)(0))+unsigned(intermatrix(5)(1))+unsigned(intermatrix(6)(0)),2));--Note that only three values are here
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(5)(0) := std_logic_vector(unsigned(intermediate) + shift_right(unsigned(randomnumber),6)) ;


		--diamond step 6.4
		intermediate:= std_logic_vector( shift_right(unsigned(intermatrix(6)(0))+unsigned(intermatrix(7)(1))+unsigned(intermatrix(8)(0)),2));--Note that only three values are here
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(7)(0) := std_logic_vector(unsigned(intermediate) + shift_right(unsigned(randomnumber),6)) ;


		--diamond step 6.5
		intermediate:= std_logic_vector( shift_right(unsigned(intermatrix(8)(0))+unsigned(intermatrix(7)(1))+unsigned(intermatrix(8)(2)),2));--Note that only three values are here
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(8)(1) := std_logic_vector(unsigned(intermediate) + shift_right(unsigned(randomnumber),6)) ;


		--diamond step 6.6
		intermediate:= std_logic_vector( shift_right(unsigned(intermatrix(8)(2))+unsigned(intermatrix(7)(3))+unsigned(intermatrix(8)(4)),2));--Note that only three values are here
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(8)(3) := std_logic_vector(unsigned(intermediate) + shift_right(unsigned(randomnumber),6)) ;


		--diamond step 6.7
		intermediate:= std_logic_vector( shift_right(unsigned(intermatrix(8)(4))+unsigned(intermatrix(7)(5))+unsigned(intermatrix(8)(6)),2));--Note that only three values are here
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(8)(5) := std_logic_vector(unsigned(intermediate) + shift_right(unsigned(randomnumber),6)) ;


		--diamond step 6.8
		intermediate:= std_logic_vector( shift_right(unsigned(intermatrix(8)(6))+unsigned(intermatrix(7)(7))+unsigned(intermatrix(8)(8)),2));--Note that only three values are here
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(8)(7) := std_logic_vector(unsigned(intermediate) + shift_right(unsigned(randomnumber),6)) ;

		
		--diamond step 6.9
		intermediate:= std_logic_vector( shift_right(unsigned(intermatrix(8)(8))+unsigned(intermatrix(7)(7))+unsigned(intermatrix(6)(8)),2));--Note that only three values are here
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(7)(8) := std_logic_vector(unsigned(intermediate) + shift_right(unsigned(randomnumber),6)) ;

		--diamond step 6.10
		intermediate:= std_logic_vector( shift_right(unsigned(intermatrix(6)(8))+unsigned(intermatrix(5)(7))+unsigned(intermatrix(4)(8)),2));--Note that only three values are here
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(5)(8) := std_logic_vector(unsigned(intermediate) + shift_right(unsigned(randomnumber),6)) ;

		--diamond step 6.11
		intermediate:= std_logic_vector( shift_right(unsigned(intermatrix(4)(8))+unsigned(intermatrix(3)(7))+unsigned(intermatrix(2)(8)),2));--Note that only three values are here
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(3)(8) := std_logic_vector(unsigned(intermediate) + shift_right(unsigned(randomnumber),6)) ;

		--diamond step 6.12
		intermediate:= std_logic_vector( shift_right(unsigned(intermatrix(2)(8))+unsigned(intermatrix(1)(7))+unsigned(intermatrix(0)(8)),2));--Note that only three values are here
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(1)(8) := std_logic_vector(unsigned(intermediate) + shift_right(unsigned(randomnumber),6)) ;

		--diamond step 6.13
		intermediate:= std_logic_vector( shift_right(unsigned(intermatrix(0)(6))+unsigned(intermatrix(1)(7))+unsigned(intermatrix(0)(8)),2));--Note that only three values are here
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(0)(7) := std_logic_vector(unsigned(intermediate) + shift_right(unsigned(randomnumber),6)) ;

		--diamond step 6.14
		intermediate:= std_logic_vector( shift_right(unsigned(intermatrix(0)(4))+unsigned(intermatrix(1)(5))+unsigned(intermatrix(0)(6)),2));--Note that only three values are here
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(0)(5) := std_logic_vector(unsigned(intermediate) + shift_right(unsigned(randomnumber),6)) ;

		--diamond step 6.15
		intermediate:= std_logic_vector( shift_right(unsigned(intermatrix(0)(2))+unsigned(intermatrix(1)(3))+unsigned(intermatrix(0)(6)),2));--Note that only three values are here
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(0)(3) := std_logic_vector(unsigned(intermediate) + shift_right(unsigned(randomnumber),6)) ;

		--diamond step 6.16
		intermediate:= std_logic_vector( shift_right(unsigned(intermatrix(0)(0))+unsigned(intermatrix(1)(1))+unsigned(intermatrix(0)(2)),2));--Note that only three values are here
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(0)(1) := std_logic_vector(unsigned(intermediate) + shift_right(unsigned(randomnumber),6)) ;

		--diamond steps 6.17-6.40 - internal diamond steps
		--diamond step 6.17
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(1)(1))+unsigned(intermatrix(1)(3))+unsigned(intermatrix(0)(2))+unsigned(intermatrix(2)(2)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(1)(2):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),6));

		--diamond step 6.18
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(1)(3))+unsigned(intermatrix(1)(5))+unsigned(intermatrix(0)(4))+unsigned(intermatrix(2)(4)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(1)(4):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),6));

		--diamond step 6.19
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(1)(5))+unsigned(intermatrix(1)(7))+unsigned(intermatrix(0)(6))+unsigned(intermatrix(2)(6)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(1)(6):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),6));

		--diamond step 6.20
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(1)(1))+unsigned(intermatrix(3)(1))+unsigned(intermatrix(2)(0))+unsigned(intermatrix(2)(2)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(2)(1):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),6));

		--diamond step 6.21
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(1)(3))+unsigned(intermatrix(3)(3))+unsigned(intermatrix(2)(2))+unsigned(intermatrix(2)(4)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(2)(3):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),6));

		--diamond step 6.22
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(1)(5))+unsigned(intermatrix(3)(5))+unsigned(intermatrix(2)(4))+unsigned(intermatrix(2)(6)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(2)(5):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),6));

		--diamond step 6.23
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(1)(7))+unsigned(intermatrix(3)(7))+unsigned(intermatrix(2)(6))+unsigned(intermatrix(2)(8)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(2)(7):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),6));

		--diamond step 6.24
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(2)(2))+unsigned(intermatrix(3)(3))+unsigned(intermatrix(3)(1))+unsigned(intermatrix(4)(2)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(3)(2):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),6));

		--diamond step 6.25
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(2)(4))+unsigned(intermatrix(3)(5))+unsigned(intermatrix(4)(4))+unsigned(intermatrix(3)(3)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(3)(4):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),6));

		--diamond step 6.26
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(3)(5))+unsigned(intermatrix(3)(7))+unsigned(intermatrix(2)(6))+unsigned(intermatrix(4)(6)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(3)(6):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),6));

		--diamond step 6.27
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(4)(0))+unsigned(intermatrix(4)(2))+unsigned(intermatrix(3)(1))+unsigned(intermatrix(5)(1)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(4)(1):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),6));

		--diamond step 6.28
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(4)(4))+unsigned(intermatrix(4)(2))+unsigned(intermatrix(3)(3))+unsigned(intermatrix(5)(3)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(4)(3):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),6));

		--diamond step 6.29
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(4)(4))+unsigned(intermatrix(4)(6))+unsigned(intermatrix(3)(5))+unsigned(intermatrix(5)(5)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(4)(5):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),6));

		--diamond step 6.30
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(4)(6))+unsigned(intermatrix(4)(8))+unsigned(intermatrix(3)(7))+unsigned(intermatrix(5)(7)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(4)(7):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),6));

		--diamond step 6.31
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(5)(1))+unsigned(intermatrix(5)(3))+unsigned(intermatrix(4)(2))+unsigned(intermatrix(6)(2)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(5)(2):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),6));

		--diamond step 6.32
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(5)(3))+unsigned(intermatrix(5)(5))+unsigned(intermatrix(4)(4))+unsigned(intermatrix(6)(4)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(5)(4):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),6));

		--diamond step 6.33
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(5)(5))+unsigned(intermatrix(5)(7))+unsigned(intermatrix(4)(6))+unsigned(intermatrix(6)(6)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(5)(6):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),6));

		--diamond step 6.34
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(6)(0))+unsigned(intermatrix(6)(2))+unsigned(intermatrix(5)(1))+unsigned(intermatrix(7)(1)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(6)(1):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),6));

		--diamond step 6.35
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(6)(2))+unsigned(intermatrix(6)(4))+unsigned(intermatrix(5)(3))+unsigned(intermatrix(7)(3)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(6)(3):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),6));

		--diamond step 6.36
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(6)(4))+unsigned(intermatrix(6)(6))+unsigned(intermatrix(5)(5))+unsigned(intermatrix(5)(7)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(6)(5):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),6));

		--diamond step 6.37
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(6)(6))+unsigned(intermatrix(6)(8))+unsigned(intermatrix(5)(7))+unsigned(intermatrix(7)(7)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(6)(7):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),6));

		--diamond step 6.38
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(7)(1))+unsigned(intermatrix(7)(3))+unsigned(intermatrix(6)(2))+unsigned(intermatrix(6)(4)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(7)(2):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),6));

		--diamond step 6.39
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(7)(3))+unsigned(intermatrix(7)(5))+unsigned(intermatrix(6)(4))+unsigned(intermatrix(8)(4)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(7)(4):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),6));

		--diamond step 6.40
		intermediate:=std_logic_vector( shift_right(unsigned(intermatrix(7)(5))+unsigned(intermatrix(7)(7))+unsigned(intermatrix(6)(6))+unsigned(intermatrix(6)(6)),2));
		xoredbit:=randomnumber(5) xor randomnumber(7);
		randomnumber:=std_logic_vector(shift_left(unsigned(randomnumber),1));
		randomnumber(0):=xoredbit;
		intermatrix(7)(6):= std_logic_vector(unsigned(intermediate)+shift_right(unsigned(randomnumber),6));

		end if;
	end process;
--process to make a counter to initialize values
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
begin
	output_vector(0)<= intermatrix(0)(0);
	output_vector(1)<= intermatrix(0)(1);
	output_vector(2)<= intermatrix(0)(2);
	output_vector(3)<= intermatrix(0)(3);
	output_vector(4)<= intermatrix(0)(4);
	output_vector(5)<= intermatrix(0)(5);
	output_vector(6)<= intermatrix(0)(6);
	output_vector(7)<= intermatrix(0)(7);
	output_vector(8)<= intermatrix(0)(8);
	output_vector(9)<= intermatrix(1)(0);
	output_vector(10)<= intermatrix(1)(1);
	output_vector(11)<= intermatrix(1)(2);
	output_vector(12)<= intermatrix(1)(3);
	output_vector(13)<= intermatrix(1)(4);
	output_vector(14)<= intermatrix(1)(5);
	output_vector(15)<= intermatrix(1)(6);
	output_vector(16)<= intermatrix(1)(7);
	output_vector(17)<= intermatrix(1)(8);
	output_vector(18)<= intermatrix(2)(0);
	output_vector(19)<= intermatrix(2)(1);
	output_vector(20)<= intermatrix(2)(2);
	output_vector(21)<= intermatrix(2)(3);
	output_vector(22)<= intermatrix(2)(4);
	output_vector(23)<= intermatrix(2)(5);
	output_vector(24)<= intermatrix(2)(6);
	output_vector(25)<= intermatrix(2)(7);
	output_vector(26)<= intermatrix(2)(8);
	output_vector(27)<= intermatrix(3)(0);
	output_vector(28)<= intermatrix(3)(1);
	output_vector(29)<= intermatrix(3)(2);
	output_vector(30)<= intermatrix(3)(3);
	output_vector(31)<= intermatrix(3)(4);
	output_vector(32)<= intermatrix(3)(5);
	output_vector(33)<= intermatrix(3)(6);
	output_vector(34)<= intermatrix(3)(7);
	output_vector(35)<= intermatrix(3)(8);
	output_vector(36)<= intermatrix(4)(0);
	output_vector(37)<= intermatrix(4)(1);
	output_vector(38)<= intermatrix(4)(2);
	output_vector(39)<= intermatrix(4)(3);
	output_vector(40)<= intermatrix(4)(4);
	output_vector(41)<= intermatrix(4)(5);
	output_vector(42)<= intermatrix(4)(6);
	output_vector(43)<= intermatrix(4)(7);
	output_vector(44)<= intermatrix(4)(8);
	output_vector(45)<= intermatrix(5)(0);
	output_vector(46)<= intermatrix(5)(1);
	output_vector(47)<= intermatrix(5)(2);
	output_vector(48)<= intermatrix(5)(3);
	output_vector(49)<= intermatrix(5)(4);
	output_vector(50)<= intermatrix(5)(5);
	output_vector(51)<= intermatrix(5)(6);
	output_vector(52)<= intermatrix(5)(7);
	output_vector(53)<= intermatrix(5)(8);
	output_vector(54)<= intermatrix(6)(0);
	output_vector(55)<= intermatrix(6)(1);
	output_vector(56)<= intermatrix(6)(2);
	output_vector(57)<= intermatrix(6)(3);
	output_vector(58)<= intermatrix(6)(4);
	output_vector(59)<= intermatrix(6)(5);
	output_vector(60)<= intermatrix(6)(6);
	output_vector(61)<= intermatrix(6)(7);
	output_vector(62)<= intermatrix(6)(8);
	output_vector(63)<= intermatrix(7)(0);
	output_vector(64)<= intermatrix(7)(1);
	output_vector(65)<= intermatrix(7)(2);
	output_vector(66)<= intermatrix(7)(3);
	output_vector(67)<= intermatrix(7)(4);
	output_vector(68)<= intermatrix(7)(5);
	output_vector(69)<= intermatrix(7)(6);
	output_vector(70)<= intermatrix(7)(7);
	output_vector(71)<= intermatrix(7)(8);
	output_vector(72)<= intermatrix(8)(0);
	output_vector(73)<= intermatrix(8)(1);
	output_vector(74)<= intermatrix(8)(2);
	output_vector(75)<= intermatrix(8)(3);
	output_vector(76)<= intermatrix(8)(4);
	output_vector(77)<= intermatrix(8)(5);
	output_vector(78)<= intermatrix(8)(6);
	output_vector(79)<= intermatrix(8)(7);
	output_vector(80)<= intermatrix(8)(8);
end process;

--process to write intermatrix components to RAM signals
process(clock_slow)
begin
	if(Set_output='0') then
		if(to_integer(unsigned(writeaddress))<81) then 
			if(falling_edge(clock_slow)) then
				datavalue<=output_vector(to_integer(unsigned(writeaddress)+1));
				writeaddress <= std_logic_vector(unsigned(writeaddress)+1);
			end if;

		elsif(to_integer(unsigned(writeaddress))=81) then
			writeaddress <="0000000";
			datavalue<=output_vector(0);
		else
			writeaddress <="0000000";
			datavalue<=output_vector(80);
		
		end if;
	end if;
end process;
	
	
end behave;
	