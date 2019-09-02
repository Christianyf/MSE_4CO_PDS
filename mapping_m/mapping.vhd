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
    M : natural := 8;--Tamaño de la palabra
    N : natural := 4--Bits de entrada
    );   
  port (
    bites_in : in  std_logic_vector (N-1 downto 0);
    o_i      : out std_logic_vector (M-1 downto 0);
    o_q      : out std_logic_vector (M-1 downto 0)
    );
end entity;

architecture arc_mux of mux is
begin
  process(bites_in)
  begin
    case to_integer(unsigned(bites_in)) is 
    when 0  => o_i <= "01100100";
               o_q <= "00000000";
    when 8  => o_i <= "01011100";
               o_q <= "00100110";
    when 10 => o_i <= "01000111";
               o_q <= "01000111";
    when 11 => o_i <= "00100110";
               o_q <= "01011100";
    when 9  => o_i <= "00000000";
               o_q <= "01100100";
    when 13 => o_i <= "11011010";
               o_q <= "01011100";
    when 12 => o_i <= "10111001";
               o_q <= "01000111";
    when 14 => o_i <= "10100100";
               o_q <= "00100110";
    when 15 => o_i <= "10011100";
               o_q <= "00000000";
    when 7  => o_i <= "10100100";
               o_q <= "11011010";
    when 5  => o_i <= "10111001";
               o_q <= "10111001";
    when 4  => o_i <= "11011010";
               o_q <= "10100100";
    when 6  => o_i <= "00000000";
               o_q <= "10011100";
    when 2  => o_i <= "00100110";
               o_q <= "10100100";
    when 3  => o_i <= "01000111";
               o_q <= "10111001";
    when 1  => o_i <= "01011100"; 
               o_q <= "11011010";
    when others => null;
    end case;
    end process;
end architecture;