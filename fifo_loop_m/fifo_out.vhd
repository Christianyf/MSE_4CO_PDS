----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fifo_out is
	 generic (WORD_WIDTH: natural := 32;
	 		  SIZE_BUF: natural := 110);
	port ( --d_last   : in  std_logic;
		   bit_i    : in  std_logic;
		   data_o   : out  std_logic_vector(WORD_WIDTH-1 downto 0);
		   dv_o     : out  std_logic;
		   d_last_o : out  std_logic;
           rst      : in  std_logic;
           clk      : in  std_logic;
           read_en  : in  std_logic);
end fifo_out;

architecture arch_fifo_out of fifo_out is
	signal dv_tmp : std_logic;
	signal data_tmp : std_logic_vector(WORD_WIDTH-1 downto 0);
begin	
	
process(clk,rst)
--variable write_index: integer := 0;
--variable read_index: integer  := 0;
variable loop_index: integer  :=0;
--variable buffer_in: buffer_type;
variable tmp: std_logic_vector(WORD_WIDTH-1 downto 0) := (others => '0');	
begin

	if rst = '1' then
		--valores a cero;
	elsif clk'event and clk='1' then
		if read_en = '1' then
			--mi código
			if loop_index >= 0 and loop_index <= 30 then
				dv_tmp <= '0';
				tmp(loop_index) := bit_i;
				loop_index := loop_index +1;
			elsif loop_index = 31 then
				tmp(loop_index) := bit_i;
				d_last_o <= tmp(loop_index);
				dv_tmp <= '1';
				data_tmp <= tmp;
				loop_index := 0;
			end if;

		else
			
			--loop_index := 0;
			tmp := (others => '0');
			dv_tmp <= '0';
		end if;	
		--actualizar salidas
		dv_o <= dv_tmp;
		data_o <= data_tmp;
	end if;	
end process;


end arch_fifo_out;

