----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fifo_in is
	 generic (WORD_WIDTH: natural := 32;
	 		  SIZE_BUF: natural := 110);
	port ( d_last : in  std_logic;
		   data_i : in  std_logic_vector(WORD_WIDTH-1 downto 0);
		   bit_o  : out  std_logic;
		   dv_o   : out  std_logic;
		   --d_last_o  : out  std_logic;
           rst    : in  std_logic;
           clk    : in  std_logic;
           write_en : in  std_logic);
end fifo_in;

architecture arch_fifo_in of fifo_in is
    type buffer_type is array(SIZE_BUF downto 0) of std_logic_vector(WORD_WIDTH-1 downto 0);
	signal dv_en : std_logic;
	signal bit_en : std_logic;
begin	
	
process(clk,rst)
variable last: std_logic;
variable write_index: integer := 0;
variable read_index: integer  := 0;
variable loop_index: integer  :=0;
variable buffer_in: buffer_type;
variable tmp: std_logic_vector(WORD_WIDTH-1 downto 0) := (others => '0');	
begin

	if rst = '1' then
		--valores a cero;
		bit_en <= '0';
	elsif clk'event and clk='1' then
		if write_en = '1' then
			--hay palabra;
			last := d_last;
			buffer_in(write_index) := data_i;
			write_index := write_index + 1;
		else
		end if;	
			--no hay palabra pero hay bits;
			if write_index /= read_index then
				dv_en <= '1'; 
				if loop_index = 0 then
					--permite nueva palabra
					tmp := buffer_in(read_index);
					read_index := read_index +1;
				elsif loop_index > 0 and loop_index < 32 then
					--esta a media palabra
				elsif loop_index >= 32 then
					--termino palabra
					tmp := buffer_in(read_index);
					read_index := read_index +1;
					loop_index := 0;
				end if;
				--enviar bit a la salida
				bit_en <= tmp(loop_index);
				loop_index := loop_index +1;
			else
				--termina de leer el buffer
				write_index := 0;
				read_index := 0;
				--loop_index :=0; 
				--falta terminar de leer la palabra actual
				if loop_index = 0 then
					bit_en <= '0';
					dv_en <= '0'; 
				elsif loop_index > 0 and loop_index < 32 then
					bit_en <= tmp(loop_index);
					loop_index := loop_index +1;
				elsif loop_index >= 32 then
					loop_index := 0;
					bit_en <= '0';
					dv_en <= '0';
				end if;
			end if;
		--end if;	
		bit_o <= bit_en;
		dv_o <= dv_en; 
	end if;	
end process;


end arch_fifo_in;

