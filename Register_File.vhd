library IEEE;
use IEEE.std_logic_1164.all;	
use IEEE.numeric_std.all;

entity Register_File is
	 port(
	 	 ReadAddr1 : in STD_LOGIC_VECTOR(4 downto 0);	
	 	 ReadAddr2 : in STD_LOGIC_VECTOR(4 downto 0);
		 ReadAddr3 : in STD_LOGIC_VECTOR(4 downto 0);	   
		 ReadAddr1_out : out STD_LOGIC_VECTOR(127 downto 0);	
	 	 ReadAddr2_out : out STD_LOGIC_VECTOR(127 downto 0);
		 ReadAddr3_out : out STD_LOGIC_VECTOR(127 downto 0);	
		 write_addr : in std_logic_vector(4 downto 0);
		 write_data : in STD_LOGIC_VECTOR(127 downto 0);
		 write_en : in STD_LOGIC;
		 
		 reset : in std_logic;
		 
		 clk : in STD_LOGIC
		 );
end Register_File;

--}} End of automatically maintained section

architecture behavior of Register_File is     							  
--delcaring of all the 32 128 bit registers in the register file
type register_array is array(0 to 31) of std_logic_vector(127 downto 0);  

signal arr : register_array; 		  
begin 
--	variable arr : register_array; 
	

	process(clk, reset)
	begin
		if(reset = '1') then
			for i in 0 to 31 loop
				arr(i) <= x"00000000000000000000000000000000";	
			end loop; 
		end if;
		--on update of rising edge of clock
		if(rising_edge(clk)) then			 
			ReadAddr1_out <= arr(to_integer(unsigned(ReadAddr1))); 
			ReadAddr2_out <= arr(to_integer(unsigned(ReadAddr2)));
			ReadAddr3_out <= arr(to_integer(unsigned(ReadAddr3)));
			--if write en is 1, write to whatever regitsre the write adrr is muxing to
			if (write_en = '1') then
				arr(to_integer(unsigned(write_addr))) <= write_data;
			end if;	
		end if;	   
	end process;

	 -- enter your statements here --
end behavior;