library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use work.funciones.all;

--* @brief Cordic vectorización
--*
--*  
--* 
--*
entity cordic_iter is
  generic (
    N     : natural := 8;
    SHIFT : natural := 1
    );   
  port (
    clk   : in std_logic;
    rst   : in std_logic;
    en_i  : in std_logic;
    xi    : in std_logic_vector (N-1 downto 0);
    yi    : in std_logic_vector (N-1 downto 0);
    zi    : in std_logic_vector (N-1 downto 0);
    ci    : in std_logic_vector (N-1 downto 0);--valor tabla arctan
    dv_o  : out std_logic;                     --señal de dato valido
    xip1  : out std_logic_vector (N-1 downto 0);
    yip1  : out std_logic_vector (N-1 downto 0);
    zip1  : out std_logic_vector (N-1 downto 0)
    );
end entity;

architecture arc_cordic of cordic_iter is
    signal dv_iter: std_logic;
    signal xi_iter: std_logic_vector (N-1 downto 0);
    signal yi_iter: std_logic_vector (N-1 downto 0);
    signal zi_iter: std_logic_vector (N-1 downto 0);
begin
    process(clk,rst)
    variable xi_aux: signed (N-1 downto 0);
    variable yi_aux: signed (N-1 downto 0);
    variable zi_aux: signed (N-1 downto 0);
    variable ci_aux: signed (N-1 downto 0);
    begin
        --tomo los valores de entrada
        xi_aux:=signed(xi);
        yi_aux:=signed(yi);
        zi_aux:=signed(zi);
        ci_aux:=signed(ci);

        if(rising_edge(clk)) then
            if(rst = '1')then
                --reset all
                xi_iter <= (others => '0');
                yi_iter <= (others => '0');
                zi_iter <= (others => '0');
                dv_iter <= '0';

            elsif(en_i='1')then
                    --mi codigo
                    dv_iter <= '1';
                    if (yi_aux < 0) then
                        xi_iter <= std_logic_vector(xi_aux - shift_right(yi_aux,SHIFT));
                        yi_iter <= std_logic_vector(yi_aux + shift_right(xi_aux,SHIFT));
                        zi_iter <= std_logic_vector(zi_aux - ci_aux);
                    else
                        xi_iter <= std_logic_vector(xi_aux + shift_right(yi_aux,SHIFT));
                        yi_iter <= std_logic_vector(yi_aux - shift_right(xi_aux,SHIFT));
                        zi_iter <= std_logic_vector(zi_aux + ci_aux);
                    end if;
            end if; 
        end if;
    end process;
    xip1 <= xi_iter;
    yip1 <= yi_iter;
    zip1 <= zi_iter;
    dv_o <= dv_iter;
end architecture;