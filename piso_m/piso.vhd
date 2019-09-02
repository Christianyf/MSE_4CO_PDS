----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:28:55 07/19/2010 
-- Design Name: 
-- Module Name:    piso - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity piso is
	 generic (WORD_WIDTH: natural := 4;
				 PARALLEL_WIDTH: natural := 2);
	port ( p_u1 : in  std_logic;
		   p_u2 : in  std_logic;
		   s_out : out  std_logic_vector(WORD_WIDTH-1 downto 0);
		   dv : out  std_logic;
           rst : in  std_logic;
           clk : in  std_logic;
           write_en : in  std_logic);
end piso;

architecture Behavioral of piso is

	signal tmp : std_logic_vector (WORD_WIDTH-1 downto 0);
	signal dv_0 : std_logic;
begin	
	
process(clk,rst)
variable sel: integer := 0;
variable data1: std_logic;--probar iniciando en 0
variable data2: std_logic;	
begin
	--tomo los valores de entrada
	data1 := p_u1;
	data2 := p_u2;

	if rst = '1' then
		tmp <= (others=>'0');
	elsif clk'event and clk='1' then
		if write_en = '1' then
			--tmp <= p_in;
			C1: case( sel ) is
			
				when 0 => tmp(WORD_WIDTH-1) <= data1;
						  tmp(WORD_WIDTH-2) <= data2;
						  sel := sel + 1;
						  dv_0 <= '0';
				when 1 => tmp(WORD_WIDTH-3) <= data1;
					      tmp(WORD_WIDTH-4) <= data2;
						  sel := 0;
						  dv_0 <= '1';
				when others => tmp <= (others=>'0');
						  sel := 0;
			end case C1;
		else	
			--tmp(PARALLEL_WIDTH*WORD_WIDTH-1 downto WORD_WIDTH) <= tmp( (PARALLEL_WIDTH-1)*WORD_WIDTH-1 downto 0);
		end if;	
	end if;	
end process;


s_out <= tmp;
dv <= dv_0;

end Behavioral;

