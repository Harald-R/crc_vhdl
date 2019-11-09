ENTITY tb_crc IS
	GENERIC (t_n : INTEGER := 4;
		 t_mes_len : INTEGER := 11);
END;

ARCHITECTURE test_crc OF tb_crc IS
	COMPONENT crc IS
		GENERIC (n : INTEGER;
			 mes_len : INTEGER);
		PORT (clk : IN BIT;
	              polynomial : IN BIT_VECTOR(n DOWNTO 0);
		      input : IN BIT_VECTOR(mes_len-1 DOWNTO 0);
		      output : OUT BIT_VECTOR(n-1 DOWNTO 0));
	END COMPONENT;

	SIGNAL clk_s : BIT;
	SIGNAL polynomial_s : BIT_VECTOR(t_n DOWNTO 0);
	SIGNAL input_s : BIT_VECTOR(t_mes_len-1 DOWNTO 0);
	SIGNAL output_s : BIT_VECTOR(t_n-1 DOWNTO 0);
BEGIN

crc1 : crc GENERIC MAP (n => t_n, mes_len => t_mes_len)
           PORT MAP (clk => clk_s, polynomial => polynomial_s, input => input_s, output => output_s);

clk_s <= NOT clk_s AFTER 5ns;

polynomial_s <= "00011";
input_s <= "10110010000";  --len 11; remainder 1010

--polynomial_s <= "10011";
--input_s <= "11010110110000";  --len 14; remainder 1110


END;