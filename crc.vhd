ENTITY crc IS
        GENERIC (n : INTEGER := 8;
                 mes_len : INTEGER := 8);
        PORT (clk : IN BIT;
              polynomial : IN BIT_VECTOR(n DOWNTO 0);
              input : IN BIT_VECTOR(mes_len-1 DOWNTO 0);
              output : OUT BIT_VECTOR(n-1 DOWNTO 0));
END;

ARCHITECTURE desc OF crc IS
	COMPONENT lfsr IS
		GENERIC (n : IN INTEGER;
			 n_iter : IN INTEGER);
		PORT (clk, input : IN BIT;
			polynomial : IN BIT_VECTOR(n DOWNTO 0);
			output : OUT BIT_VECTOR(n-1 DOWNTO 0));
	END COMPONENT;

	SIGNAL lfsr_input_s : BIT;
	SIGNAL input_idx : INTEGER := mes_len-1;
BEGIN

lfsr1 : lfsr GENERIC MAP (n => n, n_iter => mes_len)
             PORT MAP (clk => clk, input => lfsr_input_s, polynomial => polynomial, output => output);

PROCESS
BEGIN
	IF clk = '1' AND clk'EVENT AND clk'LAST_VALUE = '0' THEN
		IF input_idx > 0 THEN
			input_idx <= input_idx - 1;
		ELSE
			WAIT;
		END IF;
	END IF;

	WAIT ON clk;
END PROCESS;

lfsr_input_s <= input(input_idx);

END;