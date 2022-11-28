LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY topo IS
GENERIC (N : integer := 4);
PORT (iniciar, reset, clock: in std_logic;
		entA, entB: in std_logic_vector(N-1 downto 0);
		mult: OUT std_logic_vector(N-1 downto 0);
		pronto: OUT std_logic);
END topo;

-- Sinais de comando
architecture estrutura of topo is

COMPONENT bo IS
GENERIC (N : integer := 4);
PORT (clk : IN STD_LOGIC;
      cA, cMult, cP, cB, mA, mP, m1, m2, op: IN STD_LOGIC;
      entA, entB : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
      Az, Bz : OUT STD_LOGIC;
      saida: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
END COMPONENT;

COMPONENT bc IS
GENERIC (N : integer := 4);
PORT (Reset, clk, inicio : IN STD_LOGIC;
      Az, Bz : IN STD_LOGIC;
      pronto : OUT STD_LOGIC;
		A, B: IN std_logic_vector(N-1 downto 0);
      cA, cMult, cP, cB, mA, mP, m1, m2, op: OUT STD_LOGIC );
END COMPONENT;

signal s_cA, s_cMult, s_cP, s_cB, s_mA, s_mP, s_m1, s_m2, s_op, s_Az, s_Bz: std_logic;

begin
	bo_0: bo PORT MAP (clock, s_cA, s_cMult, s_cP, s_cB, s_mA, s_mP, s_m1, s_m2, s_op, entA, entB, s_Az, s_Bz, mult);
	bc_0: bc PORT MAP (reset, clock, iniciar, s_Az, s_Bz, pronto, entA, entB, s_cA, s_cMult, s_cP, s_cB, s_mA, s_mP, s_m1, s_m2, s_op);
	
end estrutura;