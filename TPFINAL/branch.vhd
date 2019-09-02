library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity rama is
    generic(
      N : natural := 2;
      M : natural := 16;
      K : natural := 7;
      SHIFT : natural := 1;
      PARALLEL_WIDTH: natural := 2;
      WORD_WIDTH: natural := 4);
    port(
      clk : in std_logic;
      rst : in std_logic;
      en_i : in std_logic;
      x_i  : in std_logic;
      dv_o : out std_logic;
      i_o  : out std_logic_vector(M-1 downto 0);
      q_o  : out std_logic_vector(M-1 downto 0));
  end entity;


  architecture estructura of rama is
    component encoder is
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
        end component;

        component piso is
            generic (WORD_WIDTH: natural := 4;
            PARALLEL_WIDTH: natural := 2);
            port ( 
                p_u1 : in  std_logic;
                p_u2 : in  std_logic;
                s_out : out  std_logic_vector(WORD_WIDTH-1 downto 0);
                dv : out  std_logic;
                rst : in  std_logic;
                clk : in  std_logic;
                write_en : in  std_logic
                );
            end component;
        
        component mux is
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
          end component;

        signal wire_u1: std_logic;
        signal wire_u2: std_logic;
        signal wire_dv: std_logic;
        signal wire_out: std_logic_vector(WORD_WIDTH-1 downto 0);
        signal wire_dv_o: std_logic;
        signal wire_dv_fin: std_logic;
        signal wire_i: std_logic_vector(M-1 downto 0);
        signal wire_q: std_logic_vector(M-1 downto 0);

    begin
        COD_ENCODER: encoder
        generic map(N,K,SHIFT)
        port map(clk => clk,
        rst => rst,
        en => en_i,
        b_in => x_i,
        u1 => wire_u1,
        u2 => wire_u2,
        dv => wire_dv);

        COD_PISO: piso
        generic map(WORD_WIDTH,PARALLEL_WIDTH)
        port map(p_u1 => wire_u1,
        p_u2 => wire_u2,
        s_out => wire_out,
        dv => wire_dv_o,
        rst => rst,
        clk => clk,
        write_en => wire_dv);

        COD_MUX: mux
        generic map(M,WORD_WIDTH)
        port map(bites_in => wire_out,
        clk => clk,
        rst => rst,
        en => wire_dv_o,
        dv => wire_dv_fin,
        o_i => wire_i,
        o_q => wire_q);

        i_o <= wire_i;
        q_o <= wire_q;
        dv_o <= wire_dv_o;

        end estructura;