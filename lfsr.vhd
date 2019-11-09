ENTITY lfsr IS
	GENERIC (n : IN INTEGER := 8;
		 n_iter : IN INTEGER := 16);
	PORT (clk, input : IN BIT;
		polynomial : IN BIT_VECTOR(n DOWNTO 0);
		output : OUT BIT_VECTOR(n-1 DOWNTO 0));
END;

ARCHITECTURE desc OF lfsr IS
	COMPONENT flipflop_d IS
		PORT (clk, D : IN BIT;
			Q : OUT BIT);
	END COMPONENT;
BEGIN

PROCESS
	VARIABLE out_val : BIT_VECTOR(n-1 DOWNTO 0);
	VARIABLE iter : INTEGER := 0;
	VARIABLE extra_bit : BIT := '0';
BEGIN
	IF iter = n_iter THEN
		WAIT;
	END IF;

	IF clk = '1' AND clk'EVENT AND clk'LAST_VALUE = '0' THEN
		extra_bit := out_val(n-1);

		FOR i IN n-1 DOWNTO 1 LOOP
			out_val(i) := out_val(i-1) XOR (extra_bit AND polynomial(i));
		END LOOP;
		out_val(0) := input XOR (extra_bit AND polynomial(0));

		output <= out_val;
		iter := iter + 1;
	END IF;

	WAIT ON clk;
END PROCESS;

END;