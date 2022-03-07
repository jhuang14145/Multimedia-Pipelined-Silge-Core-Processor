library IEEE;
use IEEE.std_logic_1164.all;		 
use IEEE.numeric_std.all;	 
use IEEE.MATH_REAL;
use STD.textio.all;
use ieee.std_logic_textio.all;	

library ALU;
use ALU.all;
use work.Instruction_Buffer_Type.all; 

entity testbench_new is
end testbench_new;

--}} End of automatically maintained section

architecture tb_architecture of testbench is							 
	signal opcode : STD_LOGIC_VECTOR(24 downto 0);
	signal clk : std_logic:='0';			 
	signal instructions : Instruction_Array;
	signal rd : STD_LOGIC_VECTOR(4 downto 0);	 
	
	signal PC : Integer := 0;
	
--	signal rd_data : STD_LOGIC_VECTOR(127 downto 0);
	
	signal rs1 : STD_LOGIC_VECTOR(4 downto 0);	
	signal rs2 : STD_LOGIC_VECTOR(4 downto 0);
	signal rs3 : STD_LOGIC_VECTOR(4 downto 0);	 
	
	signal ALU_Result : STD_LOGIC_VECTOR(127 downto 0);	
	signal reset : std_logic;

	-- clk period
	constant period: time := 20ns; 
	constant period2 : time := 60ns;
	--
	-- Files
	--
	file input : text;
	
	begin
	UUT: entity Pipeline
		port map(	 
		clk => clk,  
		instructions => instructions,
		rd => rd,
		--rd_data => rd_data,
		rs1 => rs1,
		rs2 => rs2,
		rs3 => rs3,		
		PC => PC,
		reset => reset,
		ALU_Result => ALU_Result	
		);		   

		tb: process
		-- files --
		variable input_line : line;
		variable output_line : line;
		variable opcode_input : std_logic_vector(24 downto 0);
		variable counter : integer := 0;
		file input_file : text;
		file output_file : text;	   
		
		begin	
		file_open(input_file, "additional_test.bin", read_mode);
		  
		
		
		reset <= '1';
		wait for period2;
		reset <= '0';
		
		ALU_Result <= std_logic_vector(x"00000000000000000000000000000000");
		
		while not endfile(input_file) loop
			if(counter = 63) then
				exit;
			end if;
			readline(input_file, input_line);
			bread(input_line, opcode_input);
			instructions(counter) <= opcode_input;
			  
			counter := counter + 1;	  
		end loop; 
		file_close(input_file);
		wait;
	end process;
		
		
	process	
		variable output_line : line;
		file output_file : text;
		variable opcode_input : std_logic_vector(24 downto 0);
	begin
		file_open(output_file, "output.txt", write_mode);
		for i in 0 to 63 loop
			write(output_line, to_hstring(ALU_Result));--ALU RESULT --)
			writeline(output_file, output_line);
			-- decode? 
			opcode_input := instructions(i);  
			opcode<=instructions(i);
			if((opcode_input(24) = '1') and (opcode_input(23) = '0')) then 
				rs1 <= opcode_input(19 downto 15);
				rs2 <= opcode_input(14 downto 10);
				rs3 <= opcode_input(9 downto 5); 
				rd <= opcode_input(4 downto 0);	  
				
			elsif((opcode_input(24) = '1') and (opcode_input(23) = '1')) then
				rs1 <= opcode_input(14 downto 10);
				rs2 <= opcode_input(9 downto 5);
				rd <= opcode_input(4 downto 0);
			end if;	
			wait for period;   	 		  
		end loop;
		
		
		file_close(output_file);
		std.env.finish;
		end process;	   
		
		process
		begin	  
			clk <= not clk;		 
			wait for period/2;
		end process;
		
	 -- enter your statements here --

end tb_architecture;
