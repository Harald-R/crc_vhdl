ENTITY receiver IS
        GENERIC (n : INTEGER := 8;
                 mes_len : INTEGER := 8);
        PORT (clk : IN BIT;
              polynomial : IN BIT_VECTOR(n DOWNTO 0);
              input : IN BIT;
              valid : IN BIT;
              output : OUT BIT_VECTOR(n-1 DOWNTO 0));
END;

ARCHITECTURE desc OF receiver IS
	COMPONENT lfsr IS
		GENERIC (n : IN INTEGER;
			 n_iter : IN INTEGER);
		PORT (clk, input : IN BIT;
			polynomial : IN BIT_VECTOR(n DOWNTO 0);
			output : OUT BIT_VECTOR(n-1 DOWNTO 0));
	END COMPONENT;

	SIGNAL lfsr_clk_s : BIT := '0';
	SIGNAL lfsr_input_s : BIT;
BEGIN

lfsr1 : lfsr GENERIC MAP (n => n, n_iter => mes_len+n+2)
             PORT MAP (clk => lfsr_clk_s, input => lfsr_input_s, polynomial => polynomial, output => output);

PROCESS (clk)
BEGIN
	IF clk = '1' AND clk'EVENT AND clk'LAST_VALUE = '0' THEN
		IF valid = '0' THEN
			lfsr_input_s <= '0';
		ELSE
			lfsr_input_s <= input;
		END IF;
	END IF;
END PROCESS;

lfsr_clk_s <= '0' WHEN valid='0' ELSE clk;

END;