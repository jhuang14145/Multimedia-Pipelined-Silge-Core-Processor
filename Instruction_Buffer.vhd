library IEEE;
use IEEE.std_logic_1164.all;		 
use IEEE.numeric_std.all;

package Instruction_Buffer_Type is
	type Instruction_Array is array(0 to 63) of std_logic_vector(24 downto 0);
end package Instruction_Buffer_Type;

library IEEE;
use IEEE.std_logic_1164.all;		 
use IEEE.numeric_std.all;			  
--'work' means your current working library
use work.Instruction_Buffer_Type.all;
												   	

entity Instruction_Buffer is
	 port(
	     clk : in std_logic;
	   	 inst_arr : in Instruction_Array;	
		 PC : inout Integer := 0;
		 output : out std_logic_vector(24 downto 0) := "0000000000000000000000000"
		 );
end Instruction_Buffer;

--}} End of automatically maintained section

architecture behavioral of Instruction_Buffer is  
signal output_temp : std_logic_vector(24 downto 0) := "0000000000000000000000000";
begin
	process(clk)
	variable PC_temp : integer := 0;
	begin 
		PC_temp := PC;
		if(rising_edge(clk)) then 		   
			if(PC_temp < 64) then
				output <= std_logic_vector(inst_arr(PC_temp));
				PC_temp := PC_temp + 1;		 
			end if;
			PC <= PC_temp;					
			--output <= output_temp;
			--output <= "0000000000000000000000000";
		end if;		 
		
	end process;
	

	 -- enter your statements here --

end behavioral;