-- http://www.sunshine2k.de/articles/coding/crc/understanding_crc.html

ENTITY tb_lfsr IS
	GENERIC(t_n : INTEGER := 4;
		t_n_iter : INTEGER := 14);
END;

ARCHITECTURE test_lfsr OF tb_lfsr IS
	COMPONENT lfsr IS
		GENERIC (n : IN INTEGER;
			 n_iter : IN INTEGER);
		PORT (clk, input : IN BIT;
			polynomial : IN BIT_VECTOR(n DOWNTO 0);
			output : OUT BIT_VECTOR(n-1 DOWNTO 0));
	END COMPONENT;

	SIGNAL clk_s : BIT;
	SIGNAL input_s: BIT;
	SIGNAL polynomial_s : BIT_VECTOR(t_n DOWNTO 0);
	SIGNAL output_s : BIT_VECTOR(t_n-1 DOWNTO 0);
BEGIN

lfsr1: lfsr GENERIC MAP(n => t_n, n_iter => t_n_iter)
            PORT MAP(clk => clk_s, input => input_s, polynomial => polynomial_s, output => output_s);

clk_s <= NOT clk_s AFTER 5ns;
--input_s <= '1', '0' AFTER 10ns; --, '1' AFTER 20ns, '0' AFTER 40ns, '1' AFTER 60ns, '0' AFTER 70ns;
--input_s <= '1', '0' AFTER 20ns, '1' AFTER 40ns, '0' AFTER 60ns;
input_s <=
'1',
'1' AFTER 10ns,
'0' AFTER 20ns,
'1' AFTER 30ns,
'0' AFTER 40ns,
'1' AFTER 50ns,
'1' AFTER 60ns,
'0' AFTER 70ns,
'1' AFTER 80ns,
'1' AFTER 90ns,
'0' AFTER 100ns;
polynomial_s <= "10011";

END;