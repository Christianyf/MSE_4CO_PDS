library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use work.funciones.all;

--* @brief Tablas mapping 16PSK
--*
--*  
--* 
--*
entity mux is
  generic (
    M : natural := 16;--Tamaño de la palabra
    N : natural := 4--Bits de entrada
    );   
  port (
    bites_in : in  std_logic_vector (N-1 downto 0);
    clk      : in std_logic;
    rst      : in std_logic;
    en       : in std_logic;
    dv       : out std_logic;
    o_i      : out std_logic_vector (M-1 downto 0);
    o_q      : out std_logic_vector (M-1 downto 0)
    );
end entity;

architecture arc_mux of mux is
begin
  process(clk,rst)
  begin

    if (rst = '1') then
      o_i <= (others => '0');
      o_q <= (others => '0');
    elsif (clk'event and clk = '1') then
      if en = '1' then
        dv <= '1';
        case to_integer(unsigned(bites_in)) is 
        when 0  => o_i <= "0000000111110110";
                   o_q <= "0000000001100100";
        when 8  => o_i <= "0000000110101010";
                   o_q <= "0000000100011100";
        when 10 => o_i <= "0000000100011100";
                   o_q <= "0000000110101010";
        when 11 => o_i <= "0000000001100100";
                   o_q <= "0000000111110110";
        when 9  => o_i <= "1111111110011100";
                   o_q <= "0000000111110110";
        when 13 => o_i <= "1111111011100100";
                   o_q <= "0000000110101010";
        when 12 => o_i <= "1111111001010110";
                   o_q <= "0000000100011100";
        when 14 => o_i <= "1111111000001010";
                   o_q <= "0000000001100100";
        when 15 => o_i <= "1111111000001010";
                   o_q <= "1111111110011100";
        when 7  => o_i <= "1111111001010110";
                   o_q <= "1111111011100100";
        when 5  => o_i <= "1111111011100100";
                   o_q <= "1111111001010110";
        when 4  => o_i <= "1111111110011100";
                   o_q <= "1111111000001010";
        when 6  => o_i <= "0000000001100100";
                   o_q <= "1111111000001010";
        when 2  => o_i <= "0000000100011100";
                   o_q <= "1111111001010110";
        when 3  => o_i <= "0000000110101010";
                   o_q <= "1111111011100100";
        when 1  => o_i <= "0000000111110110"; 
                   o_q <= "1111111110011100";
        when others => null;
        end case;
      else
        dv <='0';
      end if;
    end if;
    end process;
end architecture;