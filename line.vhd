ENTITY line IS
        PORT(clk, input, flip_bit : IN BIT;
             valid_in : IN BIT;
             valid_out : OUT BIT;
             output : OUT BIT);
END;

ARCHITECTURE desc OF line IS
BEGIN

PROCESS (clk)
BEGIN
        IF clk = '1' AND clk'EVENT AND clk'LAST_VALUE = '0' THEN
                IF flip_bit = '1' THEN
                        output <= NOT input;
                ELSE
                        output <= input;
                END IF;
        END IF;
END PROCESS;

valid_out <= valid_in;

END;