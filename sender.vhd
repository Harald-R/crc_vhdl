ENTITY sender IS
        GENERIC (n : INTEGER := 8;
                 mes_len : INTEGER := 8);
        PORT (clk : IN BIT;
              polynomial : IN BIT_VECTOR(n DOWNTO 0);
              input : IN BIT_VECTOR(mes_len-1 DOWNTO 0);
              valid : OUT BIT;
              output : OUT BIT);
END;

ARCHITECTURE desc OF sender IS
	COMPONENT crc IS
	        GENERIC (n : INTEGER;
	                 mes_len : INTEGER);
	        PORT (clk : IN BIT;
	              polynomial : IN BIT_VECTOR(n DOWNTO 0);
	              input : IN BIT_VECTOR(mes_len-1 DOWNTO 0);
	              output : OUT BIT_VECTOR(n-1 DOWNTO 0));
	END COMPONENT;

	SIGNAL input_crc : BIT_VECTOR(mes_len+n-1 DOWNTO 0);
	SIGNAL output_crc : BIT_VECTOR(n-1 DOWNTO 0);

	SIGNAL idx_input : INTEGER := mes_len-1;
	SIGNAL idx_crc : INTEGER := n-1;

	SIGNAL send_crc : BIT := '0';
	SIGNAL valid_s : BIT := '0';
BEGIN

input_crc <= input & (n-1 DOWNTO 0 => '0');

crc1 : crc GENERIC MAP(n => n, mes_len => mes_len+n)
           PORT MAP(clk => clk, polynomial => polynomial, input => input_crc, output => output_crc);

PROCESS
	VARIABLE delay : INTEGER := n;
BEGIN
	IF clk = '1' AND clk'EVENT AND clk'LAST_VALUE = '0' THEN
		IF delay > 0 THEN
			delay := delay - 1;
		ELSE
			valid_s <= '1';
			WAIT;
		END IF;
	END IF;

	WAIT ON clk;
END PROCESS;

PROCESS
BEGIN
	IF clk = '1' AND clk'EVENT AND clk'LAST_VALUE = '0' THEN
		IF valid_s = '1' THEN		
			IF idx_input > 0 THEN
				idx_input <= idx_input - 1;
			ELSIF send_crc = '0' THEN
				send_crc <= '1';
			ELSIF idx_crc > 0 THEN
				idx_crc <= idx_crc -1;
			ELSE
				WAIT;
			END IF;
		END IF;
	END IF;

	WAIT ON clk;
END PROCESS;

valid <= valid_s;

output <= '0' WHEN valid_s = '0' ELSE
          input(idx_input) WHEN send_crc = '0' ELSE
          output_crc(idx_crc);

END;