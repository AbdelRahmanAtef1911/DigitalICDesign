LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use std.textio.all;
use ieee.std_logic_textio.all;
use work.myconstants.all;



entity TB_comb is 
end entity TB_comb;


architecture behave of TB_comb is
    component N_bits_multiplier_divider_combinational
    
     PORT( mode : IN std_logic;
           a, b : IN signed (N-1 DOWNTO 0);
           m,r : OUT signed (N-1 DOWNTO 0);
           error : OUT std_logic 
           ); 
      end component;
FOR DUT: N_bits_multiplier_divider_combinational USE ENTITY WORK.N_bits_multiplier_divider_combinational (rtl);

-- Test signals
signal a_test,b_test,m_test,r_test : signed (N-1 downto 0);
signal mode_test,error_test : std_logic;

begin
    DUT : N_bits_multiplier_divider_combinational 
    port map ( 
        mode => mode_test, 
        a => a_test,
        b => b_test,
        m => m_test,
        r => r_test,
        error => error_test
        );


-- Stimulus process to apply test cases from the file
pr : process 

FILE vectors_f: text OPEN READ_MODE IS "comb_test_vectors - Copy.txt";
    FILE results_f: text OPEN WRITE_MODE IS "comb_test_results - Copy.txt";        
    VARIABLE stimuli_l, res_l : line;
    variable a_in_file,b_in_file : STD_LOGIC_VECTOR(N-1 downto 0);
    variable mode_in_file : std_logic;
    variable m_out_file,r_out_file : STD_LOGIC_VECTOR(N-1 downto 0);
    variable passed_test_counter_multi,total_test_counter_multi : integer :=0;
    variable passed_test_counter_divider,total_test_counter_divider : integer :=0;

    --variable result_multi_out_file : singed(2*N-1 downto 0);
    begin
        total_test_counter_multi := 0;
        passed_test_counter_multi := 0;
        total_test_counter_divider := 0;
        passed_test_counter_divider := 0;

        WRITE (res_l, string'("mode      a            b            m_exp        r_exp        m_act        r_act        Message"));
        WRITELINE (results_f, res_l);  


        WHILE NOT endfile(vectors_f) LOOP
                READLINE (vectors_f, stimuli_l);
                READ (stimuli_l, mode_in_file);
                READ (stimuli_l, a_in_file);
                READ (stimuli_l, b_in_file);
                READ (stimuli_l, m_out_file);
                READ (stimuli_l, r_out_file);

                mode_test <= mode_in_file;
                a_test <= signed(a_in_file);
                b_test <= signed(b_in_file);
                wait for 10 ns;

                


                WRITE (res_l, mode_in_file);
                write(res_l, string'("         "));  
                WRITE (res_l, a_in_file);
                write(res_l, string'("         "));  
                WRITE (res_l, b_in_file);
                write(res_l, string'("         "));  
                WRITE (res_l, m_out_file);
                write(res_l, string'("         "));  
                WRITE (res_l, r_out_file);
                write(res_l, string'("         "));  

                write (res_l, std_logic_vector(m_test));
                write(res_l, string'("         "));  
                write (res_l, std_logic_vector(r_test));
                write(res_l, string'("         ")); 

                if (m_test /= signed(m_out_file)) or ((r_test /= signed(r_out_file))) then
                    WRITE (res_l, string'("Test failed"));
                    if mode_test = '0' then
                        total_test_counter_multi := total_test_counter_multi +1;
                    else
                        total_test_counter_divider := total_test_counter_divider +1;
                    end if;
                else
                    WRITE (res_l, string'("Test passed"));
                    if mode_test = '0' then
                        total_test_counter_multi := total_test_counter_multi +1;
                        passed_test_counter_multi := passed_test_counter_multi +1;

                    else
                        total_test_counter_divider := total_test_counter_divider +1;
                        passed_test_counter_divider := passed_test_counter_divider +1;
                    end if;
                end if ;
                WRITELINE (results_f, res_l);
        END LOOP;
        write(res_l, string'(" ")); 
        WRITELINE (results_f, res_l);  

        WRITE (res_l, string'("the passed case for multiplier is : "));
        WRITE (res_l, passed_test_counter_multi);
        WRITE (res_l, string'(" of "));
        WRITE (res_l, total_test_counter_multi);
        WRITELINE (results_f, res_l);  

        WRITE (res_l, string'("the passed case for divider is : "));
        WRITE (res_l, passed_test_counter_divider);
        WRITE (res_l, string'(" of "));
        WRITE (res_l, total_test_counter_divider);

        WRITELINE (results_f, res_l);  

        WAIT; 
END PROCESS pr; 

end architecture behave;
