library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity afisare is
	port(
	pret: in std_logic_vector(7 downto 0);
	suma_introdusa: in std_logic_vector(7 downto 0);
	clock:in std_logic;
	anozi: inout std_logic_vector(3 downto 0);
	catozi: out std_logic_vector(0 to 7)
	);
end afisare; 


architecture arh_afisare of afisare is

signal afisor1, afisor2, afisor3, afisor4: std_logic_vector(3 downto 0);

component numarator_modulo4 is
	port(
	clock: in std_logic;
	Q: out std_logic_vector(3 downto 0)
	);
end component ;		

component decodificator_pe_7_segmente is 
	port(
	intrari: in std_logic_vector(3 downto 0);
	catod: out std_logic_vector(0 to 7)
	);	
end component ;				 

component divizor_de_frecventa is
	port(
	clock: in std_logic;
	clock_div: out std_logic
	);
end component ;

component mux4_1 is
	port(
	input1: in std_logic_vector(3 downto 0);
	input2: in std_logic_vector(3 downto 0);
	input3: in std_logic_vector(3 downto 0);
	input4: in std_logic_vector(3 downto 0);
	selectie: in std_logic_vector(1 downto 0);
	iesire: out std_logic_vector(3 downto 0)
	);
end component ;

signal clk_intermediar: std_logic;
signal intrari_afisor: std_logic_vector(3 downto 0);   
signal selectii: std_logic_vector (1 downto 0);

signal pret_int: natural range 0 to 100;
signal sumaintrodusa_int: integer range 0 to 100;

begin

	pret_int <= to_integer(unsigned(pret));
	sumaintrodusa_int <= to_integer(unsigned(suma_introdusa));

	afisor3 <= std_logic_vector(to_unsigned(pret_int mod 10, 4));
	afisor4 <= std_logic_vector(to_unsigned(pret_int / 10, 4));

	afisor1 <= std_logic_vector(to_unsigned(sumaintrodusa_int mod 10, 4));
	afisor2 <= std_logic_vector(to_unsigned(sumaintrodusa_int / 10, 4));

	c1: divizor_de_frecventa port map(clock, clk_intermediar);
	c2:	numarator_modulo4 port map(clk_intermediar, anozi);	 
	c3: mux4_1 port map(afisor1, afisor2, afisor3, afisor4, selectii, intrari_afisor);
	c4: decodificator_pe_7_segmente port map (intrari_afisor, catozi);

	with anozi select selectii <= "00" when "1110",	  
								  "01" when "1101",
								  "10" when "1011",
								  "11" when "0111",
								  "00" when others;	

end architecture ;