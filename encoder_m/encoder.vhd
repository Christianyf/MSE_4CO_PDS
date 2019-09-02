library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity encoder is
  generic(
    N : natural := 2; --Ancho de la palabra 2
    K : natural := 7;
    SHIFT : natural := 1
  );
  port(
    clk : in std_logic;
    rst : in std_logic;
    en  : in std_logic;
    b_in: in std_logic;
    u1  : out std_logic;
    u2  : out std_logic;
    dv  : out std_logic
    );
end entity;

architecture structural of encoder is

  signal dv_out : std_logic;
  signal elements : std_logic_vector(k-1 downto 0);

begin
  process(clk,rst)
  variable aux: unsigned (K-1 downto 0);
  variable aux2: unsigned (K-1 downto 0);
  variable inp: std_logic;
  begin
    --tomo los valores de entrada
    inp := b_in;
    if(rising_edge(clk)) then
      --clk = '1' and clk'event then
      if(rst = '1')then
          --reset all
          aux := (others => '0');
          aux2 := (others => '0');
          elements <= (others => '0');
          dv_out <= '0';

      elsif(en = '1')then
              --mi codigo 
              dv_out <= '1';
              aux2 := shift_right(aux,SHIFT);
              aux2(K-1) := inp;
              elements <= std_logic_vector(aux2);
              aux := aux2;
      end if; 
    end if;
  end process;

  u1 <= elements(K-1) xor elements(K-2) xor elements(K-3) xor elements(K-4) xor elements(K-7);
  u2 <= elements(K-1) xor elements(K-3) xor elements(K-4) xor elements(K-6) xor elements(K-7);
  dv <= dv_out;

end architecture;
