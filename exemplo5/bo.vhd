LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY bo IS
GENERIC (N : integer := 4);
PORT (clk : IN STD_LOGIC;
      cA, cMult, cP, cB, mA, mP, m1, m2, op: IN STD_LOGIC;
      entA, entB : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
      Az, Bz : OUT STD_LOGIC;
      saida: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
END bo;

-- Sinais de comando
-- ini = RstP = mA = CB  => ini=1 somente em S1
-- CA=1 em S1 e em S4
-- dec = op = m1 = m2  => dec=1 somente em S4 (estado no qual ocorre A <= A - 1 )
-- CP=1 somente em S3 (estado no qual ocorre P <= P + B )

ARCHITECTURE estrutura OF bo IS
	
	COMPONENT registrador_r IS
	PORT (clk,  reset, carga : IN STD_LOGIC;
		  d : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		  q : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT registrador IS
	PORT (clk, carga : IN STD_LOGIC;
		  d : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		  q : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT mux2para1 IS
	PORT ( a, b : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
           sel: IN STD_LOGIC;
           y : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT somadorsubtrator IS
	PORT (a, b : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		  op: IN STD_LOGIC;
		  s : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
	END COMPONENT;
	
    COMPONENT igualazero IS
	PORT (a : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
          igual : OUT STD_LOGIC);
	END COMPONENT;
		
	SIGNAL saimux1, saimux2, saimux3, saimux4, sairegP, sairegA, sairegB, sairegMult, saisomasub: STD_LOGIC_VECTOR (N-1 DOWNTO 0);

BEGIN
	mux1: mux2para1 PORT MAP (saisomasub, "0000", mP, saimux1);
	regP: registrador PORT MAP (clk, CP, saimux1, sairegP);
	regA: registrador PORT MAP (clk, CA, saimux2, sairegA);
	regB: registrador PORT MAP (clk, CB, entB, sairegB);
	regMult: registrador PORT MAP (clk, cMult, sairegP, sairegMult);
	mux2: mux2para1 PORT MAP (saisomasub, entA, mA, saimux2);	
	mux3: mux2para1 PORT MAP (sairegP, sairegA, m1, saimux3);
	somasub: somadorsubtrator PORT MAP (saimux3, saimux4, op, saisomasub);
	geraAz: igualazero PORT MAP (sairegA, Az);
	geraBz: igualazero PORT MAP (sairegB, Bz);
	mux4: mux2para1 PORT MAP (sairegB, "0001", m2, saimux4);
	
	saida <= sairegP;

END estrutura;