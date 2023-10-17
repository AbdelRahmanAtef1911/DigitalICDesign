library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
use ieee.std_logic_textio.all; 
use work.myconstants.all;

entity projectTB is
end projectTB;



architecture my_tb of projectTB is 
-- sequential component
component Mulitplier_divider is
    port (
      clk :in STD_LOGIC ;
      rst : in STD_LOGIC ;
      a : in STD_LOGIC_VECTOR(N-1 downto 0);   
      b : in STD_LOGIC_VECTOR(N-1 downto 0);   
      load : in std_logic;
      m : out STD_LOGIC_VECTOR(N-1 downto 0);
      r : out STD_LOGIC_VECTOR(N-1 downto 0);
      mode : in STD_LOGIC;
      Err : out STD_LOGIC;                     
      Busy : out std_logic;                     
      Valid : out std_logic                   
    ) ;
  end component Mulitplier_divider; 


-- declare signals for dut1 sequential Multipliee x Divider
signal dut1_clk : STD_LOGIC := '0' ;
signal dut1_rst,dut1_load,dut1_mode,dut1_Err,dut1_Busy,dut1_Valid : STD_LOGIC ; 
signal dut1_a,dut1_b,dut1_m,dut1_r : STD_LOGIC_VECTOR(N-1 downto 0);

for dut1 : Mulitplier_divider USE Entity Work.Mulitplier_divider(behav_mul_div);

begin 
dut1 : Mulitplier_divider PORT MAP (dut1_clk,dut1_rst,dut1_a,dut1_b,dut1_load,dut1_m,dut1_r,dut1_mode,dut1_Err,dut1_Busy,dut1_Valid);

dut1_clk <= not dut1_clk after 50 ps;




check_Mulitplier_divider : process is 
FILE file_read : text OPEN READ_MODE IS "Sequential_test_cases.txt";
FILE file_write : text OPEN WRITE_MODE IS "Sequential_results.txt";

variable l: line;
variable a_test,b_test: std_logic_vector(N-1 downto 0);
variable mode_test : std_logic;
variable expected_out_m,expected_out_r: std_logic_vector(N-1 downto 0);
variable space: character;


variable result_line: line;

variable passed_multiplier: integer :=0;
variable passed_divider: integer :=0;

variable total_multiplier: integer :=0;
variable total_divider: integer :=0;

begin
    -- do rst at first
    dut1_load <= '0'; 
dut1_rst <= '1';
wait for 50 ps;
dut1_rst <= '0';
wait for 50 ps;

while not endfile(file_read) loop
READLINE(file_read,l);
READ(l,mode_test);
READ(l,space);
READ(l,a_test);
READ(l,space);
READ(l,b_test);
READ(l,space);
READ(l,expected_out_m);
READ(l,space);
READ(l,expected_out_r);

if (mode_test = '0') then
            total_multiplier := total_multiplier + 1;
            dut1_mode <= '0';
            wait until falling_edge(dut1_clk); 
            dut1_load <= '1'; 
            dut1_a <= a_test;
            dut1_b <= b_test; 
            wait for 100 ps;
            dut1_load <= '0';
       
            for j in 0 to N-1 loop 
            wait until rising_edge(dut1_clk);
            end loop; 
            wait until falling_edge(dut1_clk);
                    if ( (expected_out_m = dut1_m) and (expected_out_r = dut1_r)  ) then 
                    write(result_line, string'("test passed to multiply ")  );
                    WRITE (result_line, to_integer(signed(a_test)));
                    write(result_line, string'("by ")  );
                    WRITE (result_line, to_integer(signed(b_test)));
                    write(result_line, string'(" actual output : msb :  ")  );
                    WRITE (result_line, dut1_m);
                    write(result_line, string'("  lsb :  ")  );
                    WRITE (result_line, dut1_r);
                    write(result_line, string'(" expected output : msb :  ")  );
                    WRITE (result_line, expected_out_m);
                    write(result_line, string'("  lsb :  ")  );
                    WRITE (result_line, expected_out_r);
                    WRITELINE(file_write,result_line);
                    


                    passed_multiplier := passed_multiplier +1;
                    else
                    write(result_line, string'("test failed to multiply ")  );
                    WRITE (result_line, to_integer(signed(a_test)));
                    write(result_line, string'("by ")  );
                    WRITE (result_line, to_integer(signed(b_test)));

                    write(result_line, string'(" actual output : msb :  ")  );
                    WRITE (result_line, dut1_m);
                    write(result_line, string'("  lsb :  ")  );
                    WRITE (result_line, dut1_r);
                    write(result_line, string'(" expected output : msb :  ")  );
                    WRITE (result_line, expected_out_m);
                    write(result_line, string'("  lsb :  ")  );
                    WRITE (result_line, expected_out_r);
                    WRITELINE(file_write,result_line); 
                    

                    
                    end if;
                  

else        
            total_divider := total_divider + 1;
            dut1_mode <= '1'; 
            wait until falling_edge(dut1_clk); 
            dut1_load <= '1'; 
            dut1_a <= a_test;
            dut1_b <= b_test; 
            wait for 100 ps;
            dut1_load <= '0'; 
            
            for i in 0 to N-1 loop 
            wait until rising_edge(dut1_clk);
            end loop; 
            wait until falling_edge(dut1_clk);
                    if ( (expected_out_m = dut1_m) and (expected_out_r = dut1_r)  ) then 
                    write(result_line, string'("test passed to divide   ")  );
                    WRITE (result_line, to_integer(signed(a_test)));
                    write(result_line, string'("by ")  );
                    WRITE (result_line, to_integer(signed(b_test)));

                    write(result_line, string'(" actual output : result :  ")  );
                    WRITE (result_line, dut1_m);
                    write(result_line, string'("  lsb :  ")  );
                    WRITE (result_line, dut1_r);
                    write(result_line, string'(" expected output : reminder :  ")  );
                    WRITE (result_line, expected_out_m);
                    write(result_line, string'("  lsb :  ")  );
                    WRITE (result_line, expected_out_r);

                    WRITELINE(file_write,result_line);
                    passed_divider := passed_divider +1;
                    else
                    write(result_line, string'("test failed to divide   ")  );
                    WRITE (result_line, to_integer(signed(a_test)));
                    write(result_line, string'("by ")  );
                    WRITE (result_line, to_integer(signed(b_test)));

                    write(result_line, string'(" actual output : result :  ")  );
                    WRITE (result_line, dut1_m);
                    write(result_line, string'("  lsb :  ")  );
                    WRITE (result_line, dut1_r);
                    write(result_line, string'(" expected output : reminder :  ")  );
                    WRITE (result_line, expected_out_m);
                    write(result_line, string'("  lsb :  ")  );
                    WRITE (result_line, expected_out_r);


                    WRITELINE(file_write,result_line);
                    end if;


            end if;


           
end loop;
write(result_line, string'("         ")  );
WRITELINE(file_write,result_line);

WRITE (result_line, string'("the passed case for multiplier is : "));
        WRITE (result_line, passed_multiplier);
        WRITE (result_line, string'(" of "));
        WRITE (result_line, total_multiplier);
        WRITELINE (file_write, result_line);  

        WRITE (result_line, string'("the passed case for divider is : "));
        WRITE (result_line, passed_divider);
        WRITE (result_line, string'(" of "));
        WRITE (result_line, total_divider);

        WRITELINE (file_write, result_line); 

 

wait;



end process check_Mulitplier_divider;
end Architecture my_tb; 
