library IEEE;  
use IEEE.std_logic_1164.all;   
use IEEE.numeric_std.all;
use IEEE.MATH_REAL.all;
library ALU;
use ALU.all;

entity Forwarding_Unit is
	port(
	clk : in std_logic;	
--	write_back : in std_logic;
	
	rs1 : in STD_LOGIC_VECTOR(4 downto 0);
	rs2 : in STD_LOGIC_VECTOR(4 downto 0);
	rs3 : in STD_LOGIC_VECTOR(4 downto 0);
	rd  : in STD_LOGIC_VECTOR(4 downto 0); 
	
	ALU_Result : in STD_LOGIC_VECTOR(127 downto 0);
	
	rs1_in : in STD_LOGIC_VECTOR(127 downto 0);
	rs2_in : in STD_LOGIC_VECTOR(127 downto 0);
	rs3_in : in STD_LOGIC_VECTOR(127 downto 0);
	
	rs1_out : out STD_LOGIC_VECTOR(127 downto 0);
	rs2_out : out STD_LOGIC_VECTOR(127 downto 0);
	rs3_out : out STD_LOGIC_VECTOR(127 downto 0)
	);
end Forwarding_Unit;

architecture forwarding of Forwarding_Unit is

	--implement 3 muxes for 3 read registers
	--2 inputs into the mux, either old value of read register or new value (alu reset)
	
	begin 
		P1 : process(clk)
		begin 
			if rising_edge(clk) then 
				
				--R1
				if unsigned(rs1) = unsigned(rd) then 
					rs1_out <= ALU_Result;
				else 
					rs1_out <= rs1_in;
				end if;	
				
				--R2
				if unsigned(rs2) = unsigned(rd) then 
					rs2_out <= ALU_Result;
				else 
					rs2_out <= rs2_in;
				end if;
				
				--R3
				if unsigned(rs3) = unsigned(rd) then 
					rs3_out <= ALU_Result;
				else 
					rs3_out <= rs3_in;
				end if;
				
			end if;
		end process;
	end forwarding;
				
				