library ieee;
use IEEE.std_logic_1164.all;
entity CPA_1 is
    port(
        in1,in2:in std_logic;
        Cin:in std_logic;
        S:out std_logic;
        C:out std_logic
        );
end CPA_1;
architecture behavioral of CPA_1 is
    signal c1,c2,c3: std_logic;
begin
    S<=Cin xor in2 xor in1;
    C1<=in1 and in2;
    C2<=in1 and Cin;
    C3<=Cin and in2;
    C<=C3 or C2 or C1;
end architecture behavioral;


library ieee;
use IEEE.std_logic_1164.all;
entity CPA_n is
    generic(num_inputs:integer:=16);
    port(
        in1,in2:in std_logic_vector(num_inputs-1 downto 0);
        Cin:in std_logic;
        S:out std_logic_vector(num_inputs-1 downto 0)
        );
end CPA_n;
architecture behavioral of CPA_n is

    signal Cout :std_logic_vector(num_inputs downto 0);
    SIGNAL SS :std_logic_vector(num_inputs-1 downto 0);
begin
    Cout(0)<=Cin;
    U0TONUMUOFINPUT:for i in 0 to num_inputs-1 generate
        begin
            Ui:entity work.CPA_1 port map(in1(i),in2(i),Cout(i),S(i),Cout(i+1));
        end generate;
        --S<=SS & Cout(num_inputs);
end architecture behavioral;


