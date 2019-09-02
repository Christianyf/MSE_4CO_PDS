library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cordic is
  generic(
    N : natural := 16; --Ancho de la palabra 16
    ITER : natural := 10;--Numero de iteraciones 16
    PI : natural  := 1608);
  port(
    clk : in std_logic;
    rst : in std_logic;
    en_i : in std_logic;
    x_i  : in std_logic_vector(N-1 downto 0);
    y_i  : in std_logic_vector(N-1 downto 0);
    z_i  : in std_logic_vector(N-1 downto 0);
    dv_o : out std_logic;
    x_o  : out std_logic_vector(N-1 downto 0);
    y_o  : out std_logic_vector(N-1 downto 0);
    z_o  : out std_logic_vector(N-1 downto 0)
    );
end entity;

architecture structural of cordic is

  constant MAX_ITER : natural := 10;  -- Hay que popular la tabla de atan...
                                      --(Se puede automatizar)

  component cordic_iter is
  generic(
    N     : natural := 8;  --Ancho de la palabra
    SHIFT : natural := 1); --Desplazamiento
  port(
    clk   : in std_logic;
    rst   : in std_logic;
    en_i  : in std_logic;
    xi    : in std_logic_vector (N-1 downto 0);
    yi    : in std_logic_vector (N-1 downto 0);
    zi    : in std_logic_vector (N-1 downto 0);
    ci    : in std_logic_vector (N-1 downto 0);
    dv_o  : out std_logic;
    xip1  : out std_logic_vector (N-1 downto 0);
    yip1  : out std_logic_vector (N-1 downto 0);
    zip1  : out std_logic_vector (N-1 downto 0)
  );
  end component;

  type handShakeVector is array(ITER-1 downto 0) of std_logic;
  signal en, dv : handShakeVector;
  type ConnectVector is array(ITER downto 0) of std_logic_vector(N-1 downto 0);
  signal wirex, wirey, wirez, wireLUT : ConnectVector;
  --type intLUT is array(MAX_ITER downto 0) of integer range 0 to 2**N;
  type intLUT is array(ITER-1 downto 0) of integer range 0 to 2**N;
  --signal atanLUT : intLUT := (11,10,9,8,7,6,5,4,3,2,1); -- No son valores reales!
  --signal atanLUT : intLUT := (50,29,15,8,4,2,1,1,1,1);--tabla de arctan
  signal atanLUT : intLUT := (1,2,4,8,16,32,64,125,237,402);--tabla de arctan
  signal angle_correction: std_logic_vector (N-1 downto 0);

begin

en(0) <= en_i;
wirex(0) <= std_logic_vector(-signed(x_i)) when (signed(x_i) < 0 ) else 
            x_i;
wirey(0) <= y_i;
wirez(0) <= z_i;

CONNECTION_INSTANCE: for j in 0 to ITER-1 generate
  begin
    wireLUT(j) <= std_logic_vector(to_unsigned(atanLUT(j),N));

    ITERATION: cordic_iter
      generic map(N,j)
      port map(
        clk => clk,
        rst => rst,
        en_i  => en(0),--luego del 0 no se conecta a nada
        xi    => wirex(j),
        yi    => wirey(j),
        zi    => wirez(j),
        ci   => wireLUT(j),
        dv_o => dv(j),
        xip1 => wirex(j+1),
        yip1 => wirey(j+1),
        zip1 => wirez(j+1)
        );
  end generate;

  --angle_correction <= std_logic_vector(to_signed(PI,N));
z_o <= std_logic_vector(to_signed(PI,N) - signed(wirez(ITER))) when (signed(x_i) < 0 and signed(y_i) > 0) else 
       std_logic_vector(-to_signed(PI,N) - signed(wirez(ITER))) when (signed(x_i) < 0 and signed(y_i) < 0) else
       wirez(ITER);
       
dv_o <= dv(ITER-1);
x_o <= wirex(ITER);
y_o <= wirey(ITER);
--z_o <= wirez(ITER);

end architecture;
