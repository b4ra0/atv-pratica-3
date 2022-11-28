LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY bc IS
GENERIC (N : integer := 4);
PORT (Reset, clk, inicio : IN STD_LOGIC;
      Az, Bz : IN STD_LOGIC;
      pronto : OUT STD_LOGIC;
		A, B: IN std_logic_vector(N-1 downto 0);
      cA, cMult, cP, cB, mA, mP, m1, m2, op: OUT STD_LOGIC );
END bc;

-- Sinais de comando
architecture estrutura of bc is
	type states is (S0, S1, S2, S3, S4, S5);
	signal EA, PE: states;
begin

-- Logica de inicio de estado
	process(clk, reset)
		begin
			if reset= '1' then
				EA <= S0;
			elsif clk'event and clk = '1' then
				EA <= PE;
		end if;
	end process;

-- Logica de começo de estado
	process(clk, EA)
		begin
		
		case EA is
		
		when S0 =>
			if inicio = '1' then
				PE <= S1;
			end if;
			
		when S1 =>
			PE <= S2;
			
		when S2 =>
			if A /= "0000" and B /= "0000" then
				PE <= S3;
			end if;
			if A = "0000" or B = "0000" then
				PE <= S5;
			end if;
		
		when S3 =>
			PE <= S4;
			
		when S4 =>
			PE <= S2;
			
		when S5 =>
			PE <= S0;
		end case;
	end process;

-- Logica de saida
	process(clk, EA)
		begin
		
		case EA is
		
		when S0 =>
			CA <= '0';
			CP <= '0';
			pronto <= '1';
			
		when S1 =>
			pronto <= '0';
			mA <= '1';
			cA <= '1';
			cB <= '1';
			mP <= '1';
			cP <= '1';
			
		when S2 =>
			cP <= '0';
			cA <= '0';
			cB <= '0';
		
		when S3 =>
			mP <= '0';
			cP <= '1';
			m1 <= '0';
			m2 <= '0';
			op <= '0';
			
		when S4 =>
			mA <= '0';
			cA <= '1';
			m1 <= '1';
			m2 <= '1';
			op <= '1';
				
		when S5 =>
			cMult <= '1';
		end case;
	end process;
	
END estrutura;