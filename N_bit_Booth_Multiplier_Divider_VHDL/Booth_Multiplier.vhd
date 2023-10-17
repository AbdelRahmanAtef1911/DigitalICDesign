library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.myconstants.all;                                                                                    -- package contains size of multipler and divder bits

entity Booth_multiplier is
  port (
    clk :in STD_LOGIC ;
    rst : in STD_LOGIC ;
    M : in STD_LOGIC_VECTOR(N-1 downto 0);                                                                             -- contains multiplier
    Q : in STD_LOGIC_VECTOR(N-1 downto 0);                                                                             -- contains multiplicand 
    Err : out STD_LOGIC;                                                                                     -- indicates error of multiplication 
    Busy : out std_logic;                                                                                    -- Indicates signal can't accept inputs right now 
    Valid : out std_logic;                                                                                   -- means that the result is ready 
    msb_P:  out STD_LOGIC_VECTOR((2*N)-1 downto N  );                                                                  -- msb of result
    lsb_P:  out STD_LOGIC_VECTOR(N-1 downto 0  );                                                                      -- lsb of result
    load : in std_logic                                                                                      -- controls start of computation
  ) ;
end Booth_multiplier; 

architecture behav of Booth_multiplier is

     

begin
    

    p1:process (clk,rst) 
        variable M_register : STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0');                                       -- to store multiplicand
        variable Accumelator : STD_LOGIC_VECTOR(N-1 downto 0) :=(others => '0');                                       -- to store multiplier
        variable  AQq: STD_LOGIC_VECTOR(2*N downto 0) := (others => '0');                                              -- variable to store A : Q : q0  
        variable counter : integer:= N;                                                                      -- loop N times to finish multiplication
        variable busy_variable : std_logic:= '0';                                                            -- not busy at first
        variable P : STD_LOGIC_VECTOR((2*N)-1 downto 0  ):=(others => '0');                                            -- store the entire result
        
    begin
        if (rst = '1') then                                                                                  -- initially it should reset the hardware with intial values
                                                                                                             -- first initialize variables that we use in algorithm
            M_register :=(others => '0');
            Accumelator := ((others => '0'));
            AQq := (others => '0');  
            P := (others => '0'); 
                                                                                                             -- initialize outputs           
            Busy <= '0';
            Valid <= '0' ;              
            Err <= '0';
            msb_P <= (others => '0');
            lsb_P <= (others => '0');  
        elsif (load = '1') then                  
                                                                                                            -- set busy with one and load values into our variables
        busy_variable := '1';
        Busy <= '1';
        Valid <= '0';
        Err <= '0';                                                           
        M_register := M; 
        AQq := (others => '0');                                                                                   -- store the value of Input M into M register 
        AQq (N downto 1):= Q;                                                                               -- store value of Q into the bits of AQq variable 
        
        elsif rising_edge(clk) and busy_variable = '1' then                                                 -- when load signal down to zero , it starts computation
            
                counter := counter - 1;                                                                     -- number of stages this algorithm executes 
                if(AQq(1) = '1' and AQq(0) = '0') then                                                      -- case 10
                    Accumelator := AQq(2*N downto N+1);                                                     -- accumelator get the left most N bits of register
                    AQq(2*N downto N+1) := Accumelator(N-1 downto 0) - M_register(N-1 downto 0);            -- A= A-M
                elsif (AQq(1) = '0' and AQq(0) = '1') then                                                  -- case 01 
                Accumelator := AQq(2*N downto N+1);  
                AQq(2*N downto N+1) := Accumelator(N-1 downto 0) + M_register(N-1 downto 0);                -- A= A+M
                
                end if;
                AQq( (2*N)-1 downto 0) := AQq(2*N downto 1);                                                -- in any case , make arithmatic shift right of register
        end if;

        if (counter = 0) then                                                                               -- finsihed computation
        busy_variable := '0' ;                                                                              -- return to be not busy again
        P((2*N)-1 downto 0) := AQq ((2*N) downto 1);                                                        -- output the result into our variable
        msb_P <= P((2*N)-1 downto N);                                                                       -- split msb from result
        lsb_P <= P(N-1 downto 0);                                                                           -- split lsb from result
        Busy <= '0';                                                                                        -- output that i'm not busy anymore 
        counter := N;                                                                                       -- initialize counter again
        Valid <= '1';                                                                                       -- value on the output is correct
            if (M(N-1) ='0' and Q(n-1)='0' and AQq(2*N) = '1') then                                         -- + * + gives negative
            Err <= '1';
            elsif (M(N-1) ='1' and Q(n-1)='1' and AQq(2*N) = '1') then                                      -- - * - gives - 
            Err <= '1';
            elsif (M(N-1) ='0' and Q(n-1)='1' and AQq(2*N) = '0') then                                      -- + * - gives +
            Err <= '1';
            elsif (M(N-1) ='1' and Q(n-1)='0' and AQq(2*N) = '0') then                                      -- - * + gives +
            Err <= '1';
            else 
            Err<='0';
            end if;
        end if;


    
        end process p1;

end architecture behav ; 

