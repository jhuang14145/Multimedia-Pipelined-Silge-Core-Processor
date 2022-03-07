library IEEE;  
use IEEE.std_logic_1164.all;   
use IEEE.numeric_std.all;
use IEEE.MATH_REAL.all;
library ALU;
use ALU.all;
use work.all;

--package instruction_array_type is
--	type instruction_array is array(0 to 63) of STD_LOGIC_VECTOR (24 downto 0);
--end package instruction_array_type;	

library IEEE;  
use IEEE.std_logic_1164.all;   
use IEEE.numeric_std.all;
library ALU;
use ALU.all;
use work.Instruction_Buffer_Type.all;

entity Pipeline is 
	port(		  
	clk : in std_logic;
	instructions : in Instruction_Array;
	rd : in STD_LOGIC_VECTOR(4 downto 0);
	
	--rd_data : in STD_LOGIC_VECTOR(127 downto 0);
	
	rs1 : in STD_LOGIC_VECTOR(4 downto 0);	
	rs2 : in STD_LOGIC_VECTOR(4 downto 0);
	rs3 : in STD_LOGIC_VECTOR(4 downto 0);
	
	PC : inout Integer;
	
	reset : in std_logic;
	
	ALU_Result : out STD_LOGIC_VECTOR(127 downto 0)	
	
	);
end Pipeline;

architecture structural of Pipeline is 

--IF and ID to Register File temp
signal rd_temp_short : std_logic_vector(4 downto 0);

signal read_out_temp_1 : std_logic_vector(127 downto 0);
signal read_out_temp_2 : std_logic_vector(127 downto 0);
signal read_out_temp_3 : std_logic_vector(127 downto 0);	  

--ALU to Forwarding Unit
signal rd_temp_long : std_logic_vector(127 downto 0);

--Forwarding Unit to ALU
signal rs1_temp : std_logic_vector(127 downto 0);
signal rs2_temp : std_logic_vector(127 downto 0);
signal rs3_temp : std_logic_vector(127 downto 0);	

--ALU to Register File
signal write_back : std_logic;	  

-- temps
signal inst_temp : std_logic_vector(24 downto 0); 
-- signal reset : std_logic;

begin 			
		write_back <= '1';
		fetch : entity Instruction_Buffer port map (
			clk => clk,
			inst_arr => instructions,
			output => inst_temp,
			PC => PC
			);		
			
			
		decode : entity Register_File port map (
			clk=>clk,
			write_en=>write_back,
			ReadAddr1=> rs1,
			ReadAddr2=> rs2,
			ReadAddr3=> rs3,
			write_addr=>rd,
			ReadAddr1_out => read_out_temp_1,
			ReadAddr2_out => read_out_temp_2,
			ReadAddr3_out => read_out_temp_3, 
			reset => reset,
			write_data=>alu_result
			);	
			
		ex_wb : entity Forwarding_Unit port map ( 
			clk=>clk,
--			write_back=>write_back,
			rs1=> rs1,
			rs2=> rs2,
			rs3=> rs3,
			rd=>rd,
			ALU_Result=>alu_result,
			rs1_in => read_out_temp_1,
	       	rs2_in => read_out_temp_2,
        	rs3_in => read_out_temp_3,
        	rs1_out => rs1_temp,
        	rs2_out => rs2_temp,
        	rs3_out => rs3_temp				  
    		); 	 
			
		execute : entity ALU port map (
			rd => alu_result,
       		rs1 => rs1_temp,
        	rs2 => rs2_temp,
        	rs3 => rs3_temp,  
        	opcode => inst_temp
    		);	
			

end structural;
