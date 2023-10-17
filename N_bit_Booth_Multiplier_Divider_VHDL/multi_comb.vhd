library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
use work.myconstants.all;

ENTITY N_bits_multiplier_combinational IS
 
   PORT( --mode : IN std_logic;
         a, b : IN signed (N-1 DOWNTO 0);
         m,r : OUT signed (N-1 DOWNTO 0)
         --result : OUT signed (2*N-1 DOWNTO 0)
         ); 
END ENTITY N_bits_multiplier_combinational;

architecture rtl of N_bits_multiplier_combinational is
begin
      process (a,b)
      variable temp : signed (2*N-1 DOWNTO 0) ;
      variable temp_1 : signed (2*N-1 DOWNTO 0) ;
      begin
            temp := (others => '0');
            temp_1 := (others => '0');

            for i in 0 to N-1 loop
                  if b(i) = '1' then
                        temp_1 := (others => '0');  
                        temp_1(2*N-1 downto N) := a;
                        temp_1 := shift_right(temp_1,N-i);
                  else
                        temp_1 := (others => '0');
                  end if ;
                  
                  if i = N-1 then
                        temp := temp - temp_1;
                  else
                        temp := temp + temp_1;
                  end if ;

            end loop;
            m <= temp(2*N-1 DOWNTO N);
            r <= temp(N-1 DOWNTO 0);
            --result <= temp;
      end process;
end architecture rtl;



