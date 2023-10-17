library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.myconstants.all;  


entity Mulitplier_divider is
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
  end entity Mulitplier_divider; 

architecture behav_mul_div of Mulitplier_divider is 

component Booth_multiplier is
  port (
    clk :in STD_LOGIC ;
    rst : in STD_LOGIC ;
    M : in STD_LOGIC_VECTOR(N-1 downto 0);   
    Q : in STD_LOGIC_VECTOR(N-1 downto 0);    
    Err : out STD_LOGIC;                     
    Busy : out std_logic;                     
    Valid : out std_logic;                     
    msb_P:  out STD_LOGIC_VECTOR((2*N)-1 downto N  );
    lsb_P:  out STD_LOGIC_VECTOR(N-1 downto 0  );
    load : in std_logic
  ) ;
end component Booth_multiplier;

COMPONENT Booth_Division is

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
end COMPONENT Booth_Division;



signal m_mul,m_divider,r_mul,r_divider : STD_LOGIC_VECTOR(N-1 downto 0);
signal mul_Err,mul_Busy,mul_Valid : STD_LOGIC;
signal div_Err,div_Busy,div_Valid : STD_LOGIC;

begin

 
 mymul : Booth_multiplier port map(clk,rst,a,b,mul_Err,mul_Busy,mul_Valid,m_mul,r_mul,load); 
 mydiv : Booth_Division port map(clk,rst,b,a,div_Err,div_Busy,div_Valid,m_divider,r_divider,load); 
 
m <= m_mul when mode='0' else 
     m_divider;
r <= r_mul when mode='0' else 
     r_divider;
Err <= mul_Err when mode='0' else 
      div_Err;
Busy <= mul_Busy when mode='0' else 
      mul_Busy;
Valid <= mul_Valid when mode='0' else 
div_Valid;



end architecture behav_mul_div;
