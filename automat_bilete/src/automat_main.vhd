library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity automat_main is
	port
	(
	clock_placuta: in std_logic;
	load_casa: in std_logic;						  						--switch
	buton_distanta: in std_logic;					  						--buton
	enter_distanta: in std_logic;					  						--buton
	euro1, euro2, euro5, euro10, euro20, euro50: in std_logic;		  		--switch
	buton_ok_bani: in std_logic;                                            --buton
	enter_bani: in std_logic;						  						--buton
	reset: in std_logic;							  						--buton 
	led_lipsa_bilete: out std_logic;				  						--led
	led_suma_mica: out std_logic;					  						--led
	led_lipsa_rest: out std_logic;											--led
	anozi: inout std_logic_vector(3 downto 0);
	catozi: out std_logic_vector(0 to 7);
	arata_bilete: in std_logic;
	arata50: in std_logic;
	arata20: in std_logic;
	arata10: in std_logic;
	arata5: in std_logic;
	arata2: in std_logic;
	arata1: in std_logic
	);
end automat_main;

architecture arh_automat_main of automat_main is

--component divizor de frecventa
component divizor_de_frecventa is
	port(
	clock: in std_logic;
	clock_div: out std_logic
	);
end component divizor_de_frecventa;

--component debounce
component debounce is
	port(
	clock: in std_logic;
	input: in std_logic;
	output: out std_logic);
end component debounce;

--component afisare
component afisare is
	port(
	pret: in std_logic_vector(7 downto 0);
	suma_introdusa: in std_logic_vector(7 downto 0);
	clock:in std_logic;
	anozi: inout std_logic_vector(3 downto 0);
	catozi: out std_logic_vector(0 to 7)
	);
end component; 


--stari
signal stare: std_logic_vector(3 downto 0); 	  
constant stare_introducere_distanta: std_logic_vector(3 downto 0):="0001";
constant stare_introducere_bani: std_logic_vector(3 downto 0):="0010";
constant stare_verificare_date: std_logic_vector(3 downto 0):="0100";
constant stare_out_money: std_logic_vector(3 downto 0):="1000";

--debounce-uri
signal buton_distanta_deb: std_logic;
signal buton_ok_bani_deb: std_logic;


--semnale
signal distanta_pret: std_logic_vector(7 downto 0) := "00000000";
signal suma_introdusa: std_logic_vector(7 downto 0) := "00000000";


--leduri
signal led_lipsa_bilete_out: std_logic := '0';
signal led_suma_mica_out: std_logic := '0';
signal led_lipsa_rest_out: std_logic := '0';

begin  

	Debounce1: debounce port map(clock_placuta, buton_distanta, buton_distanta_deb);
	Debounce2: debounce port map(clock_placuta, buton_ok_bani, buton_ok_bani_deb);
	
	process(clock_placuta, load_casa, buton_distanta_deb, enter_distanta, euro1, euro2, euro5, euro10, euro20, euro50, enter_bani, reset, stare, buton_ok_bani_deb)

    variable money: std_logic_vector(7 downto 0) := "00000000";
	variable q, r: integer;
	variable ok_out_money: std_logic;
	variable ok_ee: std_logic;
	variable rest_calculat: std_logic_vector(7 downto 0) := "00000000";	
	variable casa_bilete: std_logic_vector(7 downto 0) := "00000000";
	variable error_so_far: std_logic;
	variable buton_distanta_deb_last: std_logic := '0';
	variable buton_ok_bani_deb_last: std_logic := '0';
	variable bani1, bani2, bani5, bani10, bani20, bani50: integer range 0 to 400;
	
	begin
	
	
	if reset = '1' then
                stare <= stare_out_money;
                money := suma_introdusa;
	elsif rising_edge(clock_placuta) then
		
		if load_casa = '1' then
			casa_bilete := "00000100";
			bani1 := 3;
			bani2 := 3;
			bani5 := 3;
			bani10 := 3;
			bani20 := 3;
			bani50 := 3;
			led_lipsa_bilete_out <= '0';
		end if;
		
			case stare is 
				
				when stare_introducere_distanta =>
				
					error_so_far := '0';
					if buton_distanta_deb='0' then
					   buton_distanta_deb_last:='0';
					end if;
				
					if buton_distanta_deb_last='0' and buton_distanta_deb='1' then
						led_lipsa_bilete_out <= '0';
						led_suma_mica_out <= '0';
						led_lipsa_rest_out <= '0';
						distanta_pret <= std_logic_vector(unsigned(distanta_pret) + 1);
						if unsigned(distanta_pret) = 100 then
							distanta_pret <= distanta_pret;
						end if;
						buton_distanta_deb_last:='1';
					end if;
					
					
					if enter_distanta='1' then
						stare <= stare_introducere_bani;					
					end if;
					
					if unsigned(casa_bilete) = 0 then
					   led_lipsa_bilete_out <= '1';
					   stare <= stare_introducere_distanta;
					end if;
					
					
				
					
				
				when stare_introducere_bani =>
				
				ok_ee := '0';
				
				if buton_ok_bani_deb = '0' then
				    buton_ok_bani_deb_last := '0';
				end if;
				
				    if euro1='1' and buton_ok_bani_deb = '1' and buton_ok_bani_deb_last = '0' then
                        suma_introdusa <= std_logic_vector(unsigned(suma_introdusa) + 1);
                        ok_ee := '1';
                        buton_ok_bani_deb_last := '1';
                        bani1 := bani1 + 1;
                    end if;		
					
				    if euro2='1' and buton_ok_bani_deb = '1' and buton_ok_bani_deb_last = '0' and ok_ee = '0' then
                        suma_introdusa <= std_logic_vector(unsigned(suma_introdusa) + 2);	
                        ok_ee := '1';
                        buton_ok_bani_deb_last := '1';
                        bani2 := bani2 + 1;
                    end if;    
					
				    if euro5='1' and buton_ok_bani_deb = '1' and buton_ok_bani_deb_last = '0' and ok_ee = '0' then
                        suma_introdusa <= std_logic_vector(unsigned(suma_introdusa) + 5);
                        ok_ee := '1';
                        buton_ok_bani_deb_last := '1';
                        bani5 := bani5 + 1;
                    end if;    		
					
				    if euro10='1' and buton_ok_bani_deb = '1' and buton_ok_bani_deb_last = '0' and ok_ee = '0' then
                        suma_introdusa <= std_logic_vector(unsigned(suma_introdusa) + 10);
                        ok_ee := '1';
                        buton_ok_bani_deb_last := '1';
                        bani10 := bani10 + 1;
                    end if;    		
					
				    if euro20='1' and buton_ok_bani_deb = '1' and buton_ok_bani_deb_last = '0' and ok_ee = '0' then
                        suma_introdusa <= std_logic_vector(unsigned(suma_introdusa) + 20);
                        ok_ee := '1';
                        buton_ok_bani_deb_last := '1';
                        bani20 := bani20 + 1;
                    end if;    		
					
				    if euro50='1' and buton_ok_bani_deb = '1' and buton_ok_bani_deb_last = '0' and ok_ee = '0' then
                        suma_introdusa <= std_logic_vector(unsigned(suma_introdusa) + 50);
                        ok_ee := '1';   
                        buton_ok_bani_deb_last := '1';
                        bani50 := bani50 + 1; 
   					end if;
   					
   					
					
					if enter_bani='1' then
						stare <= stare_verificare_date;
					end if;
					
				
					
				
				when stare_verificare_date =>
				
					if unsigned(casa_bilete) = 0 then
						led_lipsa_bilete_out <= '1';
						error_so_far := '1';
					end if;
					
					if unsigned(suma_introdusa) < unsigned(distanta_pret) then
						led_suma_mica_out <= '1';
						error_so_far := '1';
					else
						rest_calculat := std_logic_vector(unsigned(suma_introdusa) - unsigned(distanta_pret));			
					end if;
					
					--algoritm rest
					r := to_integer(unsigned(rest_calculat));
					 
					if r /= 0 then											  --bani50
						q := r/50;
						if bani50 >= q then
							r := r mod 50;
						else
							r := r - 50 * bani50;
						end if;
					end if;
					
					if r /= 0 then											  --bani20
						q := r/20;
						if bani20 >= q then
							r := r mod 20;
						else
							r := r - 20*bani20;
						end if;
					end if;
					
					if r /= 0 then											  --bani10
						q := r/10;
						if bani10 >= q then
							r := r mod 10;
						else
							r := r - 10*bani10;
						end if;
					end if;
					
					if r /= 0 then											   --bani5
						q := r/5;
						if bani5 >= q then
							r := r mod 5;
						else
							r := r - 5*bani5;
						end if;
					end if;
					
					if r /= 0 then											   --bani2
						q := r/2;
						if bani2 >= q then
							r := r mod 2;
						else
							r := r - 2*bani2;
						end if;
					end if;
					
					if r /= 0 then											   --bani1
						q := r/1;
						if bani1 >= q then
							r := r mod 1;
						else
							r := r - bani1;
						end if;
					end if;
					
					-- verificare rest
					if r /= 0 then
						led_lipsa_rest_out <= '1';
						error_so_far := '1';
					end if;
					--sfarsit algoritm rest
					
					if error_so_far = '0' then
						money := rest_calculat;
						casa_bilete := std_logic_vector(unsigned(casa_bilete) - 1);
					else
						money := suma_introdusa;
					end if;
					
					--NSL
					stare <= stare_out_money;
						
					
				when stare_out_money =>
							
					if unsigned(money) > 0 then

						ok_out_money := '1';
						if unsigned(money) >= 50 and bani50 /= 0 then
							money := std_logic_vector(unsigned(money) - 50);
							ok_out_money := '0';
							bani50 := bani50 - 1;
						end if;
						
						if (unsigned(money) >= 20 and ok_out_money = '1' and bani20 /= 0) then
							money := std_logic_vector(unsigned(money) - 20);
							ok_out_money := '0';
							bani20 := bani20 - 1;
						end if;
						
						if (unsigned(money) >= 10 and ok_out_money = '1' and bani10 /= 0)  then
							money := std_logic_vector(unsigned(money) - 10);
							ok_out_money := '0';
							bani10 := bani10 - 1;
						end if;
						
						if (unsigned(money) >= 5 and ok_out_money = '1' and bani5 /= 0)  then
							money := std_logic_vector(unsigned(money) - 5);
							ok_out_money := '0';
							bani5 := bani5 - 1;
						end if;
						
						if (unsigned(money) >= 2 and ok_out_money = '1' and bani2 /= 0)  then
							money := std_logic_vector(unsigned(money) - 2);
							ok_out_money := '0';
							bani2 := bani2 - 1;
						end if;
						
						if (unsigned(money) >= 1 and ok_out_money = '1' and bani1 /= 0)  then
							money := std_logic_vector(unsigned(money) - 1);
							bani1 := bani1 - 1;
						end if;	
						
					end if;
						
					if unsigned(money) = 0 then
						distanta_pret <= "00000000";
						suma_introdusa <= "00000000";
						stare <= stare_introducere_distanta;
						rest_calculat := "00000000";
					end if;
				
				
				when others =>
					stare <= stare_introducere_distanta;
				
			end case;
	end if;
	if arata_bilete='1' then
        distanta_pret <= casa_bilete;
    elsif arata50='1' then
        distanta_pret <= std_logic_vector(to_unsigned(bani50, 8));
    elsif arata20='1' then
        distanta_pret <= std_logic_vector(to_unsigned(bani20, 8));
    elsif arata10='1' then
        distanta_pret <= std_logic_vector(to_unsigned(bani10, 8));
    elsif arata5='1' then
        distanta_pret <= std_logic_vector(to_unsigned(bani5, 8));
    elsif arata2='1' then
        distanta_pret <= std_logic_vector(to_unsigned(bani2, 8));
    elsif arata1='1' then
        distanta_pret <= std_logic_vector(to_unsigned(bani1, 8));
    end if;	
	end process;	

	Afisarea: afisare port map(distanta_pret, suma_introdusa, clock_placuta, anozi, catozi);
	
	led_lipsa_bilete <= led_lipsa_bilete_out;
	led_suma_mica <= led_suma_mica_out;
	led_lipsa_rest <= led_lipsa_rest_out;
	
end arh_automat_main;	 
