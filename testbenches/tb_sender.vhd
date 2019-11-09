ENTITY tb_sender IS
        GENERIC (t_n : INTEGER := 4;
                 t_mes_len : INTEGER := 7);
END;

ARCHITECTURE test_sender OF tb_sender IS
	COMPONENT sender IS
	        GENERIC (n : INTEGER;
	                 mes_len : INTEGER);
	        PORT (clk : IN BIT;
	              polynomial : IN BIT_VECTOR(n DOWNTO 0);
	              input : IN BIT_VECTOR(mes_len-1 DOWNTO 0);
                      valid : OUT BIT;
	              output : OUT BIT);
	END COMPONENT;

	SIGNAL clk_s : BIT := '0';
	SIGNAL polynomial_s : BIT_VECTOR(t_n DOWNTO 0);
	SIGNAl input_s : BIT_VECTOR(t_mes_len-1 DOWNTO 0);
	SIGNAL valid_s : BIT;
	SIGNAL output_s : BIT;
BEGIN

sender1: sender GENERIC MAP(n => t_n, mes_len => t_mes_len)
                PORT MAP(clk => clk_s, polynomial => polynomial_s, input => input_s, valid => valid_s, output => output_s);

clk_s <= NOT clk_s AFTER 5ns;
polynomial_s <= "00011";
input_s <= "1011001"; -- output_s should be 10110011010

END;