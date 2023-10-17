library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
use work.myconstants.all;

ENTITY N_bits_divider_combinational IS

   PORT( --mode : IN std_logic;
         a, b : IN signed (N-1 DOWNTO 0);
         m,r : OUT signed (N-1 DOWNTO 0);
         error : OUT std_logic 
         ); 
END ENTITY N_bits_divider_combinational;

architecture rtl of N_bits_divider_combinational  is
begin
    process (a,b)
    variable A_Q : signed(2*N-1 downto 0);
    variable restored_A : signed(N-1 downto 0);
    variable M_divisor : signed(N-1 downto 0);
    variable temp_a,temp_b : signed (N-1 downto 0);

    begin
        A_Q := (others => '0');
        restored_A := (others => '0');
        M_divisor := (others => '0');

        if a(N-1) = '1' then
            temp_a := not(a)+1;
        else
            temp_a := a;
        end if;

        if b(N-1) = '1' then
            temp_b := not(b)+1;
        else
            temp_b := b;
        end if;

        A_Q(2*N-1 downto N) := temp_a;
        A_Q := shift_right(A_Q,N);
        M_divisor := temp_b;
        
        for i in N-1 downto 0 loop
            A_Q := shift_left(A_Q,1);
            restored_A := A_Q(2*N-1 downto N);

            if A_Q(2*N-1) = M_divisor(N-1) then
                A_Q(2*N-1 downto N) := A_Q(2*N-1 downto N) - M_divisor;
            else
                A_Q(2*N-1 downto N) := A_Q(2*N-1 downto N) + M_divisor;
            end if ;

            if (A_Q(2*N-1) = restored_A(N-1)) or (A_Q = 0) then
                A_Q(2*N-1 downto N) := A_Q(2*N-1 downto N) ;
                A_Q(0):= '1' ;
            else
                A_Q(2*N-1 downto N) := restored_A;
                A_Q(0):= '0' ;
            end if ;
        end loop;

        if a(N-1) = b(N-1) then
            m <= A_Q(N-1 downto 0);
        else
            m <= not(A_Q(N-1 downto 0)) + 1;
        end if;

        if (a(N-1) = '1') and not(a(N-2 downto 0) = 0) then
            r <= not(A_Q(2*N-1 downto N)) + 1;
        else
            r <= A_Q(2*N-1 downto N);
        end if;

        --r <= A_Q(2*N-1 downto N);

        if b = 0 then
            error <= '1';
        else
            error <= '0';
        end if ;
        
    end process;
end architecture;