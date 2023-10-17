library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.myconstants.all;                     

entity Booth_Division is
  
  port (
    clk :in STD_LOGIC ;
    rst : in STD_LOGIC ;
    M : in STD_LOGIC_VECTOR(N-1 downto 0);   
    Q_in : in STD_LOGIC_VECTOR(N-1 downto 0);  
    Err : out STD_LOGIC;                     
    Busy : out std_logic;                    
    Valid : out std_logic;
    Q_out: out std_logic_vector(N-1 downto 0);                    
    Remind : out std_logic_vector(N-1 downto 0); 
    load : in std_logic   
  ) ;
end Booth_Division; 

architecture behav of Booth_Division is

     

begin

    p1:process (clk,rst) 
        variable M_register : std_logic_vector(N-1 downto 0) ;   
        variable A : std_logic_vector(N downto 0) ;    
        variable  Q: std_logic_vector(N downto 0) ;   
        variable temp_A:  std_logic_vector(N downto 0) ;
        variable counter : integer:= N;                              
        variable busy_variable : std_logic:= '0';                               
        variable AQ : std_logic_vector (2*N downto 0) ;  
        Variable Sign :      std_logic;     
    begin
    
                                                                             
        
        if (rst = '1') then
            busy_variable := '0';
            Busy <= '0';         
            Err <= '0'; 
            Valid <= '0';
            Q_out <= (others => '0') ;  
            Remind <=  (others => '0');     
        elsif (load = '1') then                  
                                                                                                            
            busy_variable := '1';
            Busy <= '1';
            Valid <= '0';
            Err <= '0';     
            A := (others => '0');  
            Q := ('0' & Q_in);
            M_register := M;
 
            Q_out <= (others => '0');     
            Remind <= (others => '0');
            Valid <= '0' ;  
            Sign:= Q(N-1) xor M_register(N-1);
            if (Q(N-1)='1')then 
              Q := not Q +'1'; end if;
            if (M_register(N-1)='1') then
            M_register:= not M_register +'1';                                                      
                                                                                         
           end if; 
 
 
 
 
 
 
       elsif (rising_edge(clk) and busy_variable = '1') then   
            counter := counter - 1; 
                      
					A( N downto 1) := A(N-1 downto 0);
					A(0) := Q(N-1);
					Q( N downto 1) := Q(N-1 downto 0); 
					temp_A(N downto 0) := A(N downto 0);
          A(N downto 0) := A(N downto 0) - M_register(N-1 downto 0); 
                if (A(N)='0') then          
                  Q(0) := '1'; 
				        else 
				          Q(0) := '0';
                 
                  A(N downto 0) := temp_A(N downto 0);
                end if;
               
        end if;
        
       
        
        if (counter = 0) then   
        busy_variable := '0' ; 
        if (Sign = '1' and Q_in(N-1)='0') then 
        Q_out(N-1 downto 0) <= not Q(N-1 downto 0)+'1'; 
		    Remind(N-1 downto 0) <= A(N-1 downto 0); 
		    elsif (Q_in(N-1)='1' and Sign = '1' ) then
		    Q_out(N-1 downto 0) <= not Q(N-1 downto 0)+'1'; 
		    Remind(N-1 downto 0) <= not A(N-1 downto 0)+'1'; 
		    elsif (Q_in(N-1)='1' and Sign = '0') then 
		    Q_out(N-1 downto 0) <=  Q(N-1 downto 0); 
		    Remind(N-1 downto 0) <= not A(N-1 downto 0)+'1'; 
		    else 
		    Q_out(N-1 downto 0) <= Q(N-1 downto 0); 
		    Remind(N-1 downto 0) <= A(N-1 downto 0); 
		    end if;
		    
        Busy <= '0';                  
        counter := N;             
        Valid <= '1'; 
        end if;
   
        
        
        if (M = 0) then          
            Err <= '1';
            else       
            Err <= '0';
            
             end if;
            
        end process p1;

end architecture behav ;