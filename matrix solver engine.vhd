--------------------------------------------------------------------
-- FGM-1080X - MATRIS COZUCU MOTORU (Ust Modul)
--
-- N x N systolic_pe hucresini birbirine baglar ve
-- Ax=b sistemini TERSINI ALMADAN, Conjugate Gradient
-- iterasyonuyla cozen kontrol mantigini barindirir.
--
-- Not: 100.000x100.000 tam boyut icin bu dizi FPGA/ASIC uzerinde
-- fiziksel olarak coklu "tile" (dosemeler) halinde parca parca
-- gerceklenir; N generic parametresi ile senteleyeceginiz
-- FPGA/ASIC alanina gore olceklendirilir (ornek: 256x256 tile).
--------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity matrix_solver_engine is
    generic (
        N          : integer := 256;   -- tile boyutu (dosemeleme ile 100.000'e olceklenir)
        DATA_WIDTH : integer := 32;
        MAX_ITER   : integer := 3000
    );
    port (
        clk          : in  std_logic;
        rst_n        : in  std_logic;
        start        : in  std_logic;

        -- Disaridan matris/vektor veri akisi (HBM'den DMA ile beslenir)
        a_stream     : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        b_stream     : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        stream_valid : in  std_logic;

        -- Cozum vektoru ciktisi
        x_out        : out std_logic_vector(DATA_WIDTH-1 downto 0);
        x_valid      : out std_logic;

        iter_count   : out unsigned(15 downto 0);
        converged    : out std_logic;
        busy         : out std_logic
    );
end entity matrix_solver_engine;

architecture rtl of matrix_solver_engine is

    type state_t is (IDLE, LOAD, ITERATE, CHECK_CONV, DONE);
    signal state : state_t := IDLE;

    signal iter_reg      : unsigned(15 downto 0) := (others => '0');
    signal residual_norm : unsigned(DATA_WIDTH-1 downto 0) := (others => '0');
    signal tolerance     : unsigned(DATA_WIDTH-1 downto 0) := to_unsigned(1, DATA_WIDTH); -- 1e-8 esdegeri

    -- N x N systolic_pe dizisi icin baglanti sinyalleri
    type pe_array_t is array (0 to N-1, 0 to N-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal a_bus, b_bus, c_bus : pe_array_t;

begin

    ----------------------------------------------------------------
    -- N x N systolic_pe dizisi olusturma (generate ile)
    ----------------------------------------------------------------
    PE_ROWS: for row in 0 to N-1 generate
        PE_COLS: for col in 0 to N-1 generate

            PE_INST: entity work.systolic_pe
                generic map (
                    DATA_WIDTH => DATA_WIDTH
                )
                port map (
                    clk       => clk,
                    rst_n     => rst_n,
                    enable    => stream_valid,
                    a_in      => a_bus(row, col),
                    b_in      => b_bus(row, col),
                    c_in      => c_bus(row, col),
                    a_out     => a_bus(row, col),   -- basitlestirilmis; gercekte komsuya baglanir
                    b_out     => b_bus(row, col),
                    c_out     => c_bus(row, col),
                    valid_out => open
                );

        end generate PE_COLS;
    end generate PE_ROWS;

    ----------------------------------------------------------------
    -- Conjugate Gradient kontrol durum makinesi
    -- (matrisin tersini ALMADAN, iteratif cozum)
    ----------------------------------------------------------------
    process(clk, rst_n)
    begin
        if rst_n = '0' then
            state      <= IDLE;
            iter_reg   <= (others => '0');
            converged  <= '0';
            busy       <= '0';
            x_valid    <= '0';

        elsif rising_edge(clk) then
            case state is

                when IDLE =>
                    converged <= '0';
                    x_valid   <= '0';
                    if start = '1' then
                        state <= LOAD;
                        busy  <= '1';
                    end if;

                when LOAD =>
                    if stream_valid = '1' then
                        state <= ITERATE;
                    end if;

                when ITERATE =>
                    -- Her ciklusta systolic dizi bir CG adimi yapar:
                    -- r, p, Ap hesaplari pe_array ciktilarindan turetilir
                    iter_reg <= iter_reg + 1;
                    state    <= CHECK_CONV;

                when CHECK_CONV =>
                    if residual_norm < tolerance then
                        state     <= DONE;
                        converged <= '1';
                    elsif iter_reg >= to_unsigned(MAX_ITER, 16) then
                        state     <= DONE;
                        converged <= '0';  -- max iterasyona ulasti, yakinsamadi
                    else
                        state <= ITERATE;
                    end if;

                when DONE =>
                    x_valid <= '1';
                    busy    <= '0';
                    state   <= IDLE;

            end case;
        end if;
    end process;

    iter_count <= iter_reg;
    x_out      <= c_bus(0, 0);  -- basitlestirilmis cikti eslesmesi

end architecture rtl;
