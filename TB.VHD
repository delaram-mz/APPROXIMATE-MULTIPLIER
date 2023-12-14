LIBRARY ieee;     
use IEEE.std_logic_1164.all;
USE STD.TEXTIO.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.numeric_std.all;
USE ieee.math_real.ALL;

ENTITY TB IS
END ENTITY TB;

ARCHITECTURE TEST OF TB IS
---------------------------------
-- FUNCTION TO CREATE RANDOM NUMBER
TYPE ARRAY_RAND IS ARRAY (NATURAL RANGE<>) OF STD_LOGIC_VECTOR(7 DOWNTO 0); 
FUNCTION RAND_GEN ( BASE : INTEGER ; NUM :INTEGER) RETURN ARRAY_RAND is
	VARIABLE RAND : ARRAY_RAND (NUM-1 DOWNTO 0);
	BEGIN
		 FOR I IN NUM DOWNTO 1 LOOP
            FOR J IN 1 TO NUM LOOP
                 RAND(J-1) := std_logic_vector(to_unsigned((BASE *I) + (BASE+2)*J, RAND(J)'length)) ;
            END LOOP;
        END LOOP;
	RETURN RAND;
END FUNCTION RAND_GEN;
---------------------------------
    SIGNAL A, B :  STD_LOGIC_VECTOR (7 DOWNTO 0):=(OTHERS =>'1');
    SIGNAL OUT_GOLDEN, OUT_APPROX_I, OUT_APPROX_II, OUT_APPROX_CPA  :  STD_LOGIC_VECTOR (15 DOWNTO 0);--:=(OTHERS =>'1');
    SIGNAL NUM_OF_TEST : INTEGER := 17;
    SIGNAL A_RAND, B_RAND : ARRAY_RAND (NUM_OF_TEST-1 DOWNTO 0);
    SIGNAL FAKE_CLK : BIT;
    SIGNAL L_I , L_II, L_CPA : REAL;


BEGIN
    CUT_I : ENTITY WORK.APPROXIMATE_MULTIPLIER_I(GATE) 
    PORT MAP(MULT_INPUT1=>A,MULT_INPUT2=>B,MULT_OUTPUT=>OUT_APPROX_I);
    
    CUT_II : ENTITY WORK.APPROXIMATE_MULTIPLIER_II(GATE) 
    PORT MAP(MULT_INPUT1=>A,MULT_INPUT2=>B,MULT_OUTPUT=>OUT_APPROX_II);

    CUT_CPA : ENTITY WORK.APPROXIMATE_MULTIPLIER_CPA(GATE) 
    PORT MAP(MULT_INPUT1=>A,MULT_INPUT2=>B,MULT_OUTPUT=>OUT_APPROX_CPA);

    FAKE_CLK <= NOT FAKE_CLK AFTER 10 NS;
    OUT_GOLDEN <= A*B;
    A_RAND <= RAND_GEN(30 , NUM_OF_TEST);
    B_RAND <= RAND_GEN(20 , NUM_OF_TEST);

    PROCESS
      --  VARIABLE L : REAL;
    BEGIN
            FOR K IN 0 TO NUM_OF_TEST-1 LOOP
                A <=  A_RAND(K);
                B <=  B_RAND(K);

                WAIT FOR 10 NS;
                REPORT "DESIGN I : FOR A = "&INTEGER'IMAGE(to_integer(unsigned(A)))&"  AND B = "&INTEGER'IMAGE(to_integer(unsigned(B))) &"  ERROR IS: "&REAL'IMAGE(L_I);
                REPORT "DESIGN II :FOR A = :"&INTEGER'IMAGE(to_integer(unsigned(A)))&"  AND B = : "&INTEGER'IMAGE(to_integer(unsigned(B))) &"  ERROR IS: "&REAL'IMAGE(L_II);
                REPORT "DESIGN CPA :FOR A = :"&INTEGER'IMAGE(to_integer(unsigned(A)))&"  AND B = : "&INTEGER'IMAGE(to_integer(unsigned(B))) &"  ERROR IS: "&REAL'IMAGE(L_CPA);

            END LOOP;


    END PROCESS;

    L_I <= (REAL(ABS(to_integer(unsigned(OUT_GOLDEN - OUT_APPROX_I)))) / REAL(to_integer(unsigned(OUT_GOLDEN)))) * REAL(100) WHEN NOW > 11 NS;

    L_II <= (REAL(ABS(to_integer(unsigned(OUT_GOLDEN - OUT_APPROX_II)))) / REAL(to_integer(unsigned(OUT_GOLDEN)))) * REAL(100) WHEN NOW > 11 NS;

    L_CPA <= (REAL(ABS(to_integer(unsigned(OUT_GOLDEN - OUT_APPROX_CPA)))) / REAL(to_integer(unsigned(OUT_GOLDEN)))) * REAL(100) WHEN NOW > 11 NS;
    

END ARCHITECTURE TEST;