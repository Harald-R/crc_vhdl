ENTITY tb_unit IS
	GENERIC(t_n : INTEGER := 4;
                t_mes_len : INTEGER := 7);
END;

ARCHITECTURE test_unit OF tb_unit IS
	COMPONENT unit IS
	        GENERIC(n : INTEGER;
                        mes_len : INTEGER);
	        PORT(clk : IN BIT;
	             polynomial : IN BIT_VECTOR(n DOWNTO 0);
		     flip_bit : IN BIT;
	             input : IN BIT_VECTOR(mes_len-1 DOWNTO 0);
	             output : OUT BIT_VECTOR(n-1 DOWNTO 0);
		     dbg_sender_valid_s :  OUT BIT;
		     dbg_sender_output_s : OUT BIT;
		     dbg_receiver_input_s : OUT BIT;
		     dbg_receiver_valid_s : OUT BIT;
		     dbg_receiver_output_s : OUT BIT_VECTOR(n-1 DOWNTO 0));
	END COMPONENT;

	SIGNAL clk_s : BIT := '0';
	SIGNAL polynomial_s : BIT_VECTOR(t_n DOWNTO 0);
	SIGNAL flip_bit_s : BIT := '0';
	SIGNAl input_s : BIT_VECTOR(t_mes_len-1 DOWNTO 0);
	SIGNAL output_s : BIT_VECTOR(t_n-1 DOWNTO 0);
	SIGNAL sender_valid_s : BIT;
	SIGNAL sender_output_s : BIT;
	SIGNAL receiver_input_s : BIT;
	SIGNAL receiver_valid_s : BIT;
	SIGNAL receiver_output_s : BIT_VECTOR(t_n-1 DOWNTO 0);
BEGIN

unit1: unit GENERIC MAP(n => t_n, mes_len => t_mes_len)
            PORT MAP(clk => clk_s, polynomial => polynomial_s, flip_bit => flip_bit_s, input => input_s, output => output_s,
		     dbg_sender_valid_s    => sender_valid_s,
		     dbg_sender_output_s   => sender_output_s,
		     dbg_receiver_input_s  => receiver_input_s,
		     dbg_receiver_valid_s  => receiver_valid_s,
		     dbg_receiver_output_s => receiver_output_s);

clk_s <= NOT clk_s AFTER 5ns;
polynomial_s <= "00011";
input_s <= "1011001";
--flip_bit_s <= '0', '1' AFTER 80ns, '0' AFTER 90ns;

END;