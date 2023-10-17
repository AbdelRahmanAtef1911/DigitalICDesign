library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
use work.myconstants.all;  

ENTITY N_bits_multiplier_divider_combinational IS

   PORT( mode : IN std_logic;
         a, b : IN signed (N-1 DOWNTO 0);
         m,r : OUT signed (N-1 DOWNTO 0);
         error : OUT std_logic 
         ); 
END ENTITY N_bits_multiplier_divider_combinational;


architecture rtl of N_bits_multiplier_divider_combinational is
    component N_bits_multiplier_combinational
   
    Port (
         a, b : IN signed (N-1 DOWNTO 0);
         m,r : OUT signed (N-1 DOWNTO 0)
        );
    end component;

    component N_bits_divider_combinational
 
    Port (
         a, b : IN signed (N-1 DOWNTO 0);
         m,r : OUT signed (N-1 DOWNTO 0);
         error : OUT std_logic 
        );
    end component;

    FOR U_mutli_comb: N_bits_multiplier_combinational USE ENTITY WORK.N_bits_multiplier_combinational (rtl);
    FOR U_div_comb: N_bits_divider_combinational USE ENTITY WORK.N_bits_divider_combinational (rtl);

    signal m_multi,r_multi : signed (N-1 DOWNTO 0) ;
    signal m_div,r_div : signed (N-1 DOWNTO 0) ;
    signal error_sig : std_logic;
    begin

        U_mutli_comb : N_bits_multiplier_combinational
      
        port map (
            a => a,
            b => b,
            m => m_multi,
            r => r_multi
        );

        U_div_comb : N_bits_divider_combinational
       
        port map (
            a => a,
            b => b,
            m => m_div,
            r => r_div,
            error => error_sig
        );


        m <= m_multi when (mode = '0') else m_div;
        r <= r_multi when (mode = '0') else r_div;
        error <= '0' when (mode = '0') else error_sig;


    end architecture rtl;
