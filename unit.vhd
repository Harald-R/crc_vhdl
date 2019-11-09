ENTITY unit IS
        GENERIC (n : INTEGER := 8;
                 mes_len : INTEGER := 8);
        PORT (clk : IN BIT;
              polynomial : IN BIT_VECTOR(n DOWNTO 0);
	      flip_bit : IN BIT;
              input : IN BIT_VECTOR(mes_len-1 DOWNTO 0);
              output : OUT BIT_VECTOR(n-1 DOWNTO 0);
	      dbg_sender_valid_s : OUT BIT;
	      dbg_sender_output_s : OUT BIT;
	      dbg_receiver_input_s : OUT BIT;
	      dbg_receiver_valid_s : OUT BIT;
	      dbg_receiver_output_s : OUT BIT_VECTOR(n-1 DOWNTO 0));
END;

ARCHITECTURE desc OF unit IS
	COMPONENT sender IS
	        GENERIC (n : INTEGER;
	                 mes_len : INTEGER);
	        PORT (clk : IN BIT;
	              polynomial : IN BIT_VECTOR(n DOWNTO 0);
	              input : IN BIT_VECTOR(mes_len-1 DOWNTO 0);
	              valid : OUT BIT;
	              output : OUT BIT);
	END COMPONENT;

	COMPONENT receiver IS
	        GENERIC (n : INTEGER;
	                 mes_len : INTEGER);
	        PORT (clk : IN BIT;
	              polynomial : IN BIT_VECTOR(n DOWNTO 0);
	              input : IN BIT;
	              valid : IN BIT;
	              output : OUT BIT_VECTOR(n-1 DOWNTO 0));
	END COMPONENT;

	COMPONENT line IS
	        PORT(clk, input, flip_bit : IN BIT;
	             valid_in : IN BIT;
	             valid_out : OUT BIT;
	             output : OUT BIT);
	END COMPONENT;

	SIGNAL sender_valid_s : BIT;
	SIGNAL sender_output_s : BIT;

	SIGNAL receiver_input_s : BIT;
	SIGNAL receiver_valid_s : BIT;
	SIGNAL receiver_output_s : BIT_VECTOR(n-1 DOWNTO 0);
BEGIN

sender1: sender GENERIC MAP(n => n, mes_len => mes_len)
                PORT MAP(clk => clk, polynomial => polynomial, input => input, valid => sender_valid_s, output => sender_output_s);

line1: line PORT MAP(clk => clk, input => sender_output_s, flip_bit => flip_bit, valid_in => sender_valid_s, valid_out => receiver_valid_s, output => receiver_input_s);

receiver1: receiver GENERIC MAP(n => n, mes_len => mes_len)
                    PORT MAP(clk => clk, polynomial => polynomial, input => receiver_input_s, valid => receiver_valid_s, output => receiver_output_s);

output <= receiver_output_s;

dbg_sender_valid_s    <= sender_valid_s;
dbg_sender_output_s   <= sender_output_s;
dbg_receiver_input_s  <= receiver_input_s;
dbg_receiver_valid_s  <= receiver_valid_s;
dbg_receiver_output_s <= receiver_output_s;

END;