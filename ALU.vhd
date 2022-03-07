-- Jonathan Huang and Benjamin Bravate



library IEEE;  
use IEEE.std_logic_1164.all;   
use IEEE.numeric_std.all;

entity ALU is
	 port(
		 rs1 : in STD_LOGIC_VECTOR(127 downto 0); --These are the inputs
		 rs2 : in STD_LOGIC_VECTOR(127 downto 0); -- they contain info about opcode and immediates
		 rs3 : in STD_LOGIC_VECTOR(127 downto 0);			
		 opcode : in STD_LOGIC_VECTOR(24 downto 0); -- the opcode to decode
		 rd : out STD_LOGIC_VECTOR(127 downto 0) -- one single output
	     );
end ALU;

--}} End of automatically maintained section

architecture behavior of ALU is	   		
signal rs1_temp : std_logic_vector(31 downto 0);	  -- 0 1 2 3  ..
signal rs2_temp : std_logic_vector(15 downto 0);	  -- 31 30 29 ..
signal rs3_temp : std_logic_vector(15 downto 0);	   
signal rs1_temp_long : std_logic_vector(63 downto 0);	
signal rs2_temp_long : std_logic_vector(31 downto 0);
signal rs3_temp_long : std_logic_vector(31 downto 0);	  
begin												  
	process(opcode,rs1,rs2,rs3)									  
	variable check : std_logic_vector(127 downto 0); 
	variable temp : std_logic_vector(127 downto 0);
	variable temp2 : std_logic_vector(127 downto 0);
	variable check_pos_long : std_logic_vector(63 downto 0); 	 
	variable check_neg_long : std_logic_vector(63 downto 0); 
	variable check_pos_int : std_logic_vector(31 downto 0); 	 
	variable check_neg_int : std_logic_vector(31 downto 0);
	variable check_pos_16bit : std_logic_vector(15 downto 0); 	 
	variable check_neg_16bit : std_logic_vector(15 downto 0); 
	variable counter : integer := 0;
	begin	 						  
		for i in 0 to 62 loop
			check_pos_long(i) := '1';
			if(i < 31) then 
				check_pos_int(i) := '1';
			end if;	
			if(i < 15) then
				check_pos_16bit(i) := '1';	
			end if;
		end loop;	
		check_pos_long(63) := '0';	  
		check_neg_long(63) := '1';
		check_pos_int(31) := '0'; 
		check_neg_int(31) := '1'; 
		check_pos_16bit(15) := '0';	   
		check_neg_16bit(15) := '1';
		case std_logic_vector'(opcode(24), opcode(23)) is	
			when "00" => --load immediate  
				rd <= std_logic_vector(resize(signed(opcode(20 downto 5)), rd'length)); 
			when "01" => --load immediate  
				rd <= std_logic_vector(resize(signed(opcode(20 downto 5)), rd'length)); 										
			when "10" => --Mult-add/Mult-sub R4
				case std_logic_vector'(opcode(22), opcode(21), opcode(20)) is
					when "000" => 	--signed int mult-add low 	(rs3+rs2)*rs1  	
						rs3_temp <= rs3(15 downto 0);	
						rs2_temp <= rs2(15 downto 0);
						rs1_temp <= rs1(31 downto 0); 
						check := std_logic_vector(resize(signed(((signed(rs3_temp) * signed(rs2_temp)) + signed(rs1_temp))),check'length));	
						if ((signed(check) > signed(check_pos_int))) then		
							check(31 downto 0) := check_pos_int;
						elsif ((signed(check) < signed(check_neg_int))) then  
							check(31 downto 0) := check_neg_int;
						end if;
						rd <= std_logic_vector(check);
					when "001" =>  --signed int mult-add high 
						rs1_temp <= rs1(31 downto 0);	
						rs2_temp <= rs2(31 downto 16);
						rs3_temp <= rs3(31 downto 16); 	   
						check := std_logic_vector(resize(signed(((signed(rs3_temp) * signed(rs2_temp)) + signed(rs1_temp))),check'length));
						if ((signed(check) > signed(check_pos_int))) then		
							check(31 downto 0) := check_pos_int;
						elsif ((signed(check) < signed(check_neg_int))) then  
							check(31 downto 0) := check_neg_int;
						end if;
						rd <= std_logic_vector(check);
					when "010" => 	--signed int mult-sub low 
						rs3_temp <= rs3(15 downto 0);	
						rs2_temp <= rs2(15 downto 0);
						rs1_temp <= rs1(31 downto 0); 
						check := std_logic_vector(resize(signed(((signed(rs3_temp) * signed(rs2_temp)) - signed(rs1_temp))),check'length));  
						if ((signed(check) > signed(check_pos_int))) then		
							check(31 downto 0) := check_pos_int;
						elsif ((signed(check) < signed(check_neg_int))) then  
							check(31 downto 0) := check_neg_int;
						end if;
						rd <= std_logic_vector(check);
					when "011" => 	--signed int mult-sub high 	 
						rs1_temp <= rs1(31 downto 0);	
						rs2_temp <= rs2(31 downto 16);
						rs3_temp <= rs3(31 downto 16); 
						check := std_logic_vector(resize(signed(((signed(rs3_temp) * signed(rs2_temp)) - signed(rs1_temp))),check'length));  
						if ((signed(check) > signed(check_pos_int))) then		
							check(31 downto 0) := check_pos_int;
						elsif ((signed(check) < signed(check_neg_int))) then  
							check(31 downto 0) := check_neg_int;
						end if;
						rd <= std_logic_vector(check);
					when "100" => 	--signed long add low  
						rs3_temp_long <= rs3(31 downto 0);	
						rs2_temp_long <= rs2(31 downto 0);
						rs1_temp_long <= rs1(63 downto 0); 
						check := std_logic_vector(resize(signed(((signed(rs3_temp_long) * signed(rs2_temp_long)) + signed(rs1_temp_long))),check'length));   
						if ((signed(check) > signed(check_pos_long))) then		
							check(63 downto 0) := check_pos_long;
						elsif ((signed(check) < signed(check_neg_long))) then  
							check(63 downto 0) := check_neg_long;
						end if;
						rd <= std_logic_vector(check);
					when "101" => 	--signed long add high	   
						rs3_temp_long <= rs3(63 downto 32);	
						rs2_temp_long <= rs2(63 downto 32);
						rs1_temp_long <= rs1(63 downto 0); 
						check := std_logic_vector(resize(signed(((signed(rs3_temp_long) * signed(rs2_temp_long)) + signed(rs1_temp_long))),check'length));
						if ((signed(check) > signed(check_pos_long))) then		
							check(63 downto 0) := check_pos_long;
						elsif ((signed(check) < signed(check_neg_long))) then  
							check(63 downto 0) := check_neg_long;
						end if;
						rd <= std_logic_vector(check);
					when "110" => 	--signed long sub low	 
						rs3_temp_long <= rs3(31 downto 0);	
						rs2_temp_long <= rs2(31 downto 0);
						rs1_temp_long <= rs1(63 downto 0); 
						check := std_logic_vector(resize(signed(((signed(rs3_temp_long) * signed(rs2_temp_long)) - signed(rs1_temp_long))),check'length)); 
						if ((signed(check) > signed(check_pos_long))) then		
							check(63 downto 0) := check_pos_long;
						elsif ((signed(check) < signed(check_neg_long))) then  
							check(63 downto 0) := check_neg_long;
						end if;
						rd <= std_logic_vector(check);
					when "111" => 	--signed long sub high	
						rs3_temp_long <= rs3(63 downto 32);	
						rs2_temp_long <= rs2(63 downto 32);
						rs1_temp_long <= rs1(63 downto 0); 
						check := std_logic_vector(resize(signed(((signed(rs3_temp_long) * signed(rs2_temp_long)) - signed(rs1_temp_long))),check'length));	  
						if ((signed(check) > signed(check_pos_long))) then		
							check(63 downto 0) := check_pos_long;
						elsif ((signed(check) < signed(check_neg_long))) then  
							check(63 downto 0) := check_neg_long;
						end if;
						rd <= std_logic_vector(check);
					when others => null;
				end case;	
			when "11" => --Mult-add/Mult-sub R3
				case std_logic_vector'(opcode(18), opcode(17), opcode(16), opcode(15)) is
					when "0000" => null;	--NOP
					when "0001" =>  --AH
						check(15 downto 0) := std_logic_vector(unsigned(rs1(15 downto 0)) + unsigned(rs2(15 downto 0)));
						check(31 downto 16) := std_logic_vector(unsigned(rs1(31 downto 16)) + unsigned(rs2(31 downto 16)));
						check(47 downto 32) := std_logic_vector(unsigned(rs1(47 downto 32)) + unsigned(rs2(47 downto 32)));
						check(63 downto 48) := std_logic_vector(unsigned(rs1(63 downto 48)) + unsigned(rs2(63 downto 48)));
						check(79 downto 64) := std_logic_vector(unsigned(rs1(79 downto 64)) + unsigned(rs2(79 downto 64)));
						check(95 downto 80) := std_logic_vector(unsigned(rs1(95 downto 80)) + unsigned(rs2(95 downto 80)));
						check(111 downto 96) := std_logic_vector(unsigned(rs1(111 downto 96)) + unsigned(rs2(111 downto 96)));
						check(127 downto 112) := std_logic_vector(unsigned(rs1(127 downto 112)) + unsigned(rs2(127 downto 112)));  
						rd <= check;
					when "0010" => 	--AHS 
						check := std_logic_vector(to_unsigned(0,128));
						check := std_logic_vector(resize(signed((signed(rs3(15 downto 0)) * signed(rs2(15 downto 0)))),check'length));
						if ((signed(check) > signed(check_pos_16bit))) then		
							check(15 downto 0) := check_pos_16bit;
						elsif ((signed(check) < signed(check_neg_16bit))) then  
							check(15 downto 0) := check_neg_16bit;
						end if;
						temp(15 downto 0) := std_logic_vector(check(15 downto 0)); --1 
						check := std_logic_vector(resize(signed((signed(rs3(31 downto 16)) * signed(rs2(31 downto 16)))),check'length));
						if ((signed(check) > signed(check_pos_16bit))) then		
							check(31 downto 16) := check_pos_16bit;
						elsif ((signed(check) < signed(check_neg_16bit))) then  
							check(31 downto 16) := check_neg_16bit;
						end if;
						temp(31 downto 16) := std_logic_vector(check(31 downto 16)); --2
						check := std_logic_vector(resize(signed((signed(rs3(47 downto 32)) * signed(rs2(47 downto 32)))),check'length));
						if ((signed(check) > signed(check_pos_16bit))) then		
							check(47 downto 32) := check_pos_16bit;
						elsif ((signed(check) < signed(check_neg_16bit))) then  
							check(47 downto 32) := check_neg_16bit;
						end if;
						temp(47 downto 32) := std_logic_vector(check(47 downto 32));--3
						check := std_logic_vector(resize(signed((signed(rs3(63 downto 48)) * signed(rs2(63 downto 48)))),check'length));
						if ((signed(check) > signed(check_pos_16bit))) then		
							check(63 downto 48) := check_pos_16bit;
						elsif ((signed(check) < signed(check_neg_16bit))) then  
							check(63 downto 48) := check_neg_16bit;
						end if;
						temp(63 downto 48) := std_logic_vector(check(63 downto 48));--4
						check := std_logic_vector(resize(signed((signed(rs3(79 downto 64)) * signed(rs2(79 downto 64)))),check'length));
						if ((signed(check) > signed(check_pos_16bit))) then		
							check(79 downto 64) := check_pos_16bit;
						elsif ((signed(check) < signed(check_neg_16bit))) then  
							check(79 downto 64) := check_neg_16bit;
						end if;
						temp(79 downto 64) := std_logic_vector(check(79 downto 64));--5
						check := std_logic_vector(resize(signed((signed(rs3(95 downto 80)) * signed(rs2(95 downto 80)))),check'length));
						if ((signed(check) > signed(check_pos_16bit))) then		
							check(95 downto 80) := check_pos_16bit;
						elsif ((signed(check) < signed(check_neg_16bit))) then  
							check(95 downto 80) := check_neg_16bit;
						end if;
						temp(95 downto 80) := std_logic_vector(check(95 downto 80));--6
						check := std_logic_vector(resize(signed((signed(rs3(111 downto 96)) * signed(rs2(111 downto 96)))),check'length));
						if ((signed(check) > signed(check_pos_16bit))) then		
							check(111 downto 96) := check_pos_16bit;
						elsif ((signed(check) < signed(check_neg_16bit))) then  
							check(111 downto 96) := check_neg_16bit;
						end if;
						temp(111 downto 96) := std_logic_vector(check(111 downto 96)); --7
						check := std_logic_vector(resize(signed((signed(rs3(127 downto 112)) * signed(rs2(127 downto 112)))),check'length));
						if ((signed(check) > signed(check_pos_16bit))) then		
							check(127 downto 112) := check_pos_16bit;
						elsif ((signed(check) < signed(check_neg_16bit))) then  
							check(127 downto 112) := check_neg_16bit;
						end if;
						temp(127 downto 112) := std_logic_vector(check(127 downto 112)); --8
						rd <= temp;
					when "0011" => 	--BCW	 
						temp(31 downto 0) := rs1(31 downto 0);
						temp(63 downto 32) := rs1(31 downto 0);
						temp(95 downto 64) := rs1(31 downto 0);
						temp(127 downto 96) := rs1(31 downto 0); 
						rd <= temp;
					when "0100" =>	--CGH  	 
						check := std_logic_vector(to_unsigned(0,128));
						temp := std_logic_vector(resize(unsigned((unsigned(rs1(15 downto 0)) + unsigned(rs2(15 downto 0)))),temp'length));
						check(0) := temp(16);	   
						temp := std_logic_vector(resize(unsigned((unsigned(rs1(31 downto 16)) + unsigned(rs2(31 downto 16)))),temp'length));
						check(16) := temp(16);	  
						temp := std_logic_vector(resize(unsigned((unsigned(rs1(47 downto 32)) + unsigned(rs2(47 downto 32)))),temp'length));
						check(32) := temp(16);			
						temp := std_logic_vector(resize(unsigned((unsigned(rs1(63 downto 48)) + unsigned(rs2(63 downto 48)))),temp'length));
						check(48) := temp(16);	
						temp := std_logic_vector(resize(unsigned((unsigned(rs1(79 downto 64)) + unsigned(rs2(79 downto 64)))),temp'length));
						check(64) := temp(16);	 
						temp := std_logic_vector(resize(unsigned((unsigned(rs1(95 downto 80)) + unsigned(rs2(95 downto 80)))),temp'length));
						check(80) := temp(16);	  
						temp := std_logic_vector(resize(unsigned((unsigned(rs1(111 downto 96)) + unsigned(rs2(111 downto 96)))),temp'length));
						check(96) := temp(16);			 
						temp := std_logic_vector(resize(unsigned((unsigned(rs1(127 downto 112)) + unsigned(rs2(127 downto 112)))),temp'length));
						check(112) := temp(16);
						rd <= check;
					when "0101" => 	--CLZ	 
				   		for i in 31 downto 0 loop 
							counter := 0; 
							if(rs1(i) = '1') then
								exit;
							else  
								counter := counter + 1;	 
							end if;
							check(31 downto 0) := std_logic_vector(to_unsigned(counter, 32));
						end loop;  
						for i in 63 downto 32 loop 
							counter := 0;
							if(rs1(i) = '1') then
								exit;
							else  
								counter := counter + 1;	 
							end if;
							check(63 downto 32) := std_logic_vector(to_unsigned(counter, 32));
						end loop;
						for i in 95 downto 64 loop 
							counter := 0;
							if(rs1(i) = '1') then
								exit;
							else  
								counter := counter + 1;	 
							end if;
							check(95 downto 64) := std_logic_vector(to_unsigned(counter, 32));
						end loop;
						for i in 127 downto 96 loop 
							counter := 0;
							if(rs1(i) = '1') then
								exit;
							else  
								counter := counter + 1;	 
							end if;
							check(127 downto 96) := std_logic_vector(to_unsigned(counter, 32));
						end loop;
						rd <= check;
					when "0110" => 	--MAX 
						if((abs(signed(rs1(31 downto 0)))) > (abs(signed(rs2(31 downto 0))))) then	--handles 0 to 31
							check(31 downto 0) := rs1(31 downto 0);
						else
							check(31 downto 0) := rs2(31 downto 0);
						end if;		 
						if((abs(signed(rs1(63 downto 32)))) > (abs(signed(rs2(63 downto 32))))) then --handles 32 to 63
							check(63 downto 32) := rs1(63 downto 32);
						else
							check(63 downto 32) := rs2(63 downto 32);
						end if;		 
						
						if((abs(signed(rs1(95 downto 64)))) > (abs(signed(rs2(95 downto 64))))) then --handles 64 to 95
							check(95 downto 64) := rs1(95 downto 64);						 
						else
							check(95 downto 64) := rs2(95 downto 64);
						end if;	 
						
						if((abs(signed(rs1(127 downto 96)))) > (abs(signed(rs2(127 downto 96))))) then --hanldes 96 to 127
							check(127 downto 96) := rs1(127 downto 96);
						else
							check(127 downto 96) := rs2(127 downto 96);
						end if;	 
						rd <= check;
					when "0111" => 	--MIN
						if((abs(signed(rs1(31 downto 0)))) < (abs(signed(rs2(31 downto 0))))) then	--handles 0 to 31
							check(31 downto 0) := rs1(31 downto 0);
						else
							check(31 downto 0) := rs2(31 downto 0);
						end if;		 
						
						if((abs(signed(rs1(63 downto 32)))) < (abs(signed(rs2(63 downto 32))))) then --handles 32 to 63
							check(63 downto 32) := rs1(63 downto 32);
						else
							check(63 downto 32) := rs2(63 downto 32);
						end if;		 
						
						if((abs(signed(rs1(95 downto 64)))) < (abs(signed(rs2(95 downto 64))))) then --handles 64 to 95
							check(95 downto 64) := rs1(95 downto 64);						 
						else
							check(95 downto 64) := rs2(95 downto 64);
						end if;	 
						
						if((abs(signed(rs1(127 downto 96)))) < (abs(signed(rs2(127 downto 96))))) then --hanldes 96 to 127
							check(127 downto 96) := rs1(127 downto 96);
						else
							check(127 downto 96) := rs2(127 downto 96);
						end if;	 
						rd <= check;
					when "1000" => 	--MSGN
						if(rs2(31) = '1') then
							temp := std_logic_vector(resize(signed(rs1(31 downto 0))*(-1),temp'length));
							if(temp <= check_neg_int) then
								temp := std_logic_vector(resize((signed(check_neg_int)), temp'length)); 
							end if;
						else
							temp := std_logic_vector(resize(signed(rs1(31 downto 0)),temp'length));
						end if;	  	 
						check(31 downto 0) := temp(31 downto 0);
						
						if(rs2(63) = '1') then
							temp := std_logic_vector(resize(signed(rs1(63 downto 32))*(-1),temp'length));
							if(temp <= check_neg_int) then
								temp := std_logic_vector(resize((signed(check_neg_int)), temp'length)); 
							end if;
						else
							temp := std_logic_vector(resize(signed(rs1(63 downto 32)),temp'length));
						end if;	 	  
						check(63 downto 32) := temp(63 downto 32);
						
						if(rs2(95) = '1') then
							temp := std_logic_vector(resize(signed(rs1(95 downto 64))*(-1),temp'length));
							if(temp <= check_neg_int) then
								temp := std_logic_vector(resize((signed(check_neg_int)), temp'length)); 
							end if;
						else
							temp := std_logic_vector(resize(signed(rs1(95 downto 64)),temp'length));
						end if;	 								
						check(95 downto 64) := temp(95 downto 64);
						
						if(rs2(127) = '1') then
							temp := std_logic_vector(resize(signed(rs1(127 downto 96))*(-1),temp'length));
							if(temp <= check_neg_int) then
								temp := std_logic_vector(resize((signed(check_neg_int)), temp'length)); 
							end if;
						else
							temp := std_logic_vector(resize(signed(rs1(127 downto 96)),temp'length));
						end if;	 	 							
						check(127 downto 96) := temp(127 downto 96);  
						
						rd <= check;
					when "1001" =>	--POPCNTH
						counter := 0;
						for i in 15 downto 0 loop
							if(rs1(i) = '1') then
								counter := counter + 1;
							end if;
						end loop;
						check(15 downto 0) := std_logic_vector(to_unsigned(counter,16));	
						counter := 0;
						for i in 31 downto 16 loop
							if(rs1(i) = '1') then
								counter := counter + 1;
							end if;
						end loop;
						check(31 downto 16) := std_logic_vector(to_unsigned(counter,16));
						counter := 0;
						for i in 47 downto 32 loop
							if(rs1(i) = '1') then
								counter := counter + 1;
							end if;
						end loop;
						check(47 downto 32) := std_logic_vector(to_unsigned(counter,16));
						counter := 0;
						for i in 63 downto 48 loop
							if(rs1(i) = '1') then
								counter := counter + 1;
							end if;
						end loop;
						check(63 downto 48) := std_logic_vector(to_unsigned(counter,16));
						counter := 0;
						for i in 79 downto 64 loop
							if(rs1(i) = '1') then
								counter := counter + 1;
							end if;
						end loop;
						check(79 downto 64) := std_logic_vector(to_unsigned(counter,16));
						counter := 0;
						for i in 95 downto 80 loop
							if(rs1(i) = '1') then
								counter := counter + 1;
							end if;
						end loop;
						check(95 downto 80) := std_logic_vector(to_unsigned(counter,16));
						counter := 0;
						for i in 111 downto 96 loop
							if(rs1(i) = '1') then
								counter := counter + 1;
							end if;
						end loop;
						check(111 downto 96) := std_logic_vector(to_unsigned(counter,16));
						counter := 0;
						for i in 127 downto 112 loop
							if(rs1(i) = '1') then
								counter := counter + 1;
							end if;
						end loop;
						check(127 downto 112) := std_logic_vector(to_unsigned(counter,16));	   
						rd <= check;
						
					when "1010" => 	--ROT
						temp := std_logic_vector(resize((rs2(6),rs2(5),rs2(4),rs2(3),rs2(2),rs2(1),rs2(0)), temp'length));	
						check := rs1;	
						for i in to_integer(unsigned(temp)) downto 0 loop
							counter := 0;
							if(rs1(0) = '1') then
								counter := 1;
							else 
								counter := 0;
							end if;
							check := std_logic_vector(shift_right(signed(check),1));
							if(unsigned(temp) > 0) then
								if(counter = 1) then
									check(127) := '1';
								else
									check(127) := '0';
								end if;
							end if;
						end loop;
						rd <= check;
					when "1011" => 	--ROTW	
						temp := std_logic_vector(resize((rs2(4),rs2(3),rs2(2),rs2(1),rs2(0)), temp'length));	
						check(31 downto 0) := rs1(31 downto 0);	
						for i in to_integer(unsigned(temp)) downto 0 loop
							counter := 0;
							if(rs1(0) = '1') then
								counter := 1;
							else 
								counter := 0;
							end if;
							check := std_logic_vector(shift_right(signed(check),1));
							if(unsigned(temp) > 0) then
								if(counter = 1) then
									check(31) := '1';
								else
									check(31) := '0';
								end if;
							end if;
						end loop;
						temp2(31 downto 0) := check(31 downto 0); --1	
						
						temp := std_logic_vector(resize((rs2(36),rs2(35),rs2(34),rs2(33),rs2(32)), temp'length));	
						check(63 downto 32) := rs1(63 downto 32);	
						for i in to_integer(unsigned(temp)) downto 0 loop
							counter := 0;
							if(rs1(0) = '1') then
								counter := 1;
							else 
								counter := 0;
							end if;
							check := std_logic_vector(shift_right(signed(check),1));
							if(unsigned(temp) > 0) then
								if(counter = 1) then
									check(63) := '1';
								else
									check(63) := '0';
								end if;
							end if;
						end loop;
						temp2(63 downto 32) := check(63 downto 32); --2	
						
						temp := std_logic_vector(resize((rs2(68),rs2(67),rs2(66),rs2(65),rs2(64)), temp'length));	
						check(95 downto 64) := rs1(95 downto 64);	
						for i in to_integer(unsigned(temp)) downto 0 loop
							counter := 0;
							if(rs1(0) = '1') then
								counter := 1;
							else 
								counter := 0;
							end if;
							check := std_logic_vector(shift_right(signed(check),1));
							if(unsigned(temp) > 0) then
								if(counter = 1) then
									check(95) := '1';
								else
									check(95) := '0';
								end if;
							end if;
						end loop;
						temp2(95 downto 64) := check(95 downto 64); --3  
						
						temp := std_logic_vector(resize((rs2(100),rs2(99),rs2(98),rs2(97),rs2(96)), temp'length));	
						check(127 downto 96) := rs1(127 downto 96);	
						for i in to_integer(unsigned(temp)) downto 0 loop
							counter := 0;
							if(rs1(0) = '1') then
								counter := 1;
							else 
								counter := 0;
							end if;
							check := std_logic_vector(shift_right(signed(check),1));
							if(unsigned(temp) > 0) then
								if(counter = 1) then
									check(127) := '1';
								else
									check(127) := '0';
								end if;
							end if;
						end loop;
						temp2(127 downto 96) := check(127 downto 96); --4	
						rd <= temp2;
						
					when "1100" => 	--SHLHI	
						for i in 0 to 7 loop
							temp := std_logic_vector(resize((rs2(16*i+3),rs2(16*i+2),rs2(16*i+1),rs2(16*i)), temp'length));
							check((16*i+15) downto (16*i)) := rs1((16*i+15) downto (16*i));							
							temp2((16*i+15) downto (16*i)) := std_logic_vector(shift_left(unsigned(check(16*i+15 downto (16*i))),to_integer(unsigned(temp))));
						end loop;	
						rd <= temp2;
					when "1101" => 	--SFH 		
						for i in 0 to 7 loop
							temp(16*i+15 downto i) := std_logic_vector(unsigned(rs2(16*i+15 downto i)) - unsigned(rs1(16*i+15 downto i))); 
						end loop;
						rd <= temp;
					when "1110" => 	--SFHS	
						check := std_logic_vector(to_unsigned(0,128));
						for i in 0 to 7 loop
							temp := std_logic_vector(resize((signed(rs2(16*i+15 downto i)) - signed(rs1(16*i+15 downto i))), temp'length)); 
							if ((signed(temp) > signed(check_pos_16bit))) then		
								check(16*i+15 downto 16*i) := check_pos_16bit;
							elsif ((signed(check) < signed(check_neg_16bit))) then  
								check(16*i+15 downto 16*i) := check_neg_16bit;	  
							else 
								check(16*i+15 downto 16*i) := temp(15 downto 0);
							end if;
						end loop;
						rd <= check;
					when "1111" => 	--XOR
						for i in 0 to 127 loop
							if((rs1(i) = '1' and rs2(i) = '1') or (rs1(i) = '0' and rs2(i) = '0')) then
								temp(i) := '0';
							else
								temp(i) := '1';
							end if;
						end loop;
						rd <= temp;
					when others => null;
				end case;	
			when others => null;
		end case;				
	end process;
end behavior;

