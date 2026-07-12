--------------------------------------------------------------------------------
-- robot_chip_tb.vhd
-- robot_chip_top icin testbench.
--
-- Bir "sanal host" gibi davranarak UART uzerinden:
--   1) cognition_core'a agirlik/bias/giris yazar, START verir
--   2) emotion_core'a stres/odul girisi yazar, START verir
--   3) sonuclari ic sinyallerden (hiyerarsik erisimle) gozlemler
--
-- GHDL ile calistirmak icin:
--   ghdl -a --std=08 pkg/wb_pkg.vhd rtl/*.vhd tb/robot_chip_tb.vhd
--   ghdl -e --std=08 robot_chip_tb
--   ghdl -r --std=08 robot_chip_tb --wave=wave.ghw --stop-time=2ms
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.wb_pkg.all;

entity robot_chip_tb is
end entity robot_chip_tb;

architecture sim of robot_chip_tb is

    constant CLK_FREQ_HZ : integer := 50_000_000;
    constant BAUD_RATE   : integer := 115_200;
    constant CLK_PERIOD  : time := 20 ns; -- 50 MHz
    constant BIT_PERIOD  : time := 1000 ms / BAUD_RATE;

    signal clk   : std_logic := '0';
    signal rst_n : std_logic := '0';

    signal uart_rx : std_logic := '1'; -- testbench -> comm_core (idle=1)
    signal uart_tx : std_logic;        -- comm_core -> testbench

    signal sensor_stress : signed(15 downto 0) := (others => '0');
    signal sensor_reward : signed(15 downto 0) := (others => '0');

    signal motor_l_pwm, motor_l_dir, motor_r_pwm, motor_r_dir : std_logic;

    constant CMD_WRITE : std_logic_vector(7 downto 0) := x"01";

    -- Ic sinyalleri gozlemlemek icin VHDL-2008 "external name" probe'lari
    -- (uut.u_cognition.out_regs gibi dogrudan nokta erisimi standart degildir)
    signal probe_cog_out  : signed_array_t(0 to 2);
    signal probe_emo_mood : signed_array_t(0 to 2);
    signal probe_speed_l  : signed(15 downto 0);
    signal probe_speed_r  : signed(15 downto 0);

    ----------------------------------------------------------------------
    procedure send_byte(signal line_sig : out std_logic; b : std_logic_vector(7 downto 0)) is
    begin
        line_sig <= '0'; -- start biti
        wait for BIT_PERIOD;
        for i in 0 to 7 loop
            line_sig <= b(i);
            wait for BIT_PERIOD;
        end loop;
        line_sig <= '1'; -- stop biti
        wait for BIT_PERIOD;
    end procedure;

    procedure wb_write(signal line_sig : out std_logic;
                        addr : unsigned(7 downto 0);
                        data : signed(15 downto 0)) is
    begin
        send_byte(line_sig, CMD_WRITE);
        send_byte(line_sig, std_logic_vector(addr));
        send_byte(line_sig, std_logic_vector(data(15 downto 8)));
        send_byte(line_sig, std_logic_vector(data(7 downto 0)));
    end procedure;

    -- Q4.12 sabit noktali deger uretmek icin yardimci fonksiyon (float -> signed)
    function to_q412(v : real) return signed is
    begin
        return to_signed(integer(v * 4096.0), 16);
    end function;

begin

    ----------------------------------------------------------------------
    uut : entity work.robot_chip_top
        generic map (
            CLK_FREQ_HZ => CLK_FREQ_HZ,
            BAUD_RATE   => BAUD_RATE,
            PWM_PERIOD  => 256
        )
        port map (
            clk           => clk,
            rst_n         => rst_n,
            uart_rx       => uart_rx,
            uart_tx       => uart_tx,
            sensor_stress => sensor_stress,
            sensor_reward => sensor_reward,
            motor_l_pwm   => motor_l_pwm,
            motor_l_dir   => motor_l_dir,
            motor_r_pwm   => motor_r_pwm,
            motor_r_dir   => motor_r_dir
        );

    clk <= not clk after CLK_PERIOD/2;

    -- VHDL-2008 external name ile ic sinyallere salt-okunur erisim
    probe_cog_out  <= << signal .robot_chip_tb.uut.u_cognition.out_regs  : signed_array_t(0 to 2) >>;
    probe_emo_mood <= << signal .robot_chip_tb.uut.u_emotion.mood_regs   : signed_array_t(0 to 2) >>;
    probe_speed_l  <= << signal .robot_chip_tb.uut.u_motor.speed_l       : signed(15 downto 0) >>;
    probe_speed_r  <= << signal .robot_chip_tb.uut.u_motor.speed_r       : signed(15 downto 0) >>;

    ----------------------------------------------------------------------
    stim : process
    begin
        rst_n <= '0';
        wait for 200 ns;
        rst_n <= '1';
        wait for 200 ns;

        ------------------------------------------------------------------
        -- COGNITION_CORE: 3 noron icin agirlik/bias yukle
        -- Basit ornek: noron0 sadece IN0'i gecirsin (W=1.0), digerleri 0
        ------------------------------------------------------------------
        wb_write(uart_rx, C_COG_W_BASE + 0, to_q412(1.0));  -- N0-W0
        wb_write(uart_rx, C_COG_W_BASE + 1, to_q412(0.0));  -- N0-W1
        wb_write(uart_rx, C_COG_W_BASE + 2, to_q412(0.0));  -- N0-W2
        wb_write(uart_rx, C_COG_W_BASE + 3, to_q412(0.0));  -- N0-W3
        wb_write(uart_rx, C_COG_B_BASE + 0, to_q412(0.0));  -- bias0

        wb_write(uart_rx, C_COG_W_BASE + 4, to_q412(0.0));  -- N1-W0
        wb_write(uart_rx, C_COG_W_BASE + 5, to_q412(1.0));  -- N1-W1 (don egilimi = IN1)
        wb_write(uart_rx, C_COG_W_BASE + 6, to_q412(0.0));
        wb_write(uart_rx, C_COG_W_BASE + 7, to_q412(0.0));
        wb_write(uart_rx, C_COG_B_BASE + 1, to_q412(0.0));

        wb_write(uart_rx, C_COG_W_BASE + 8,  to_q412(0.0));
        wb_write(uart_rx, C_COG_W_BASE + 9,  to_q412(0.0));
        wb_write(uart_rx, C_COG_W_BASE + 10, to_q412(0.0));
        wb_write(uart_rx, C_COG_W_BASE + 11, to_q412(0.0));
        wb_write(uart_rx, C_COG_B_BASE + 2,  to_q412(0.0)); -- bias2 (dur egilimi=0)

        -- Giris: "ileri git" sensor okumasi = 0.8
        wb_write(uart_rx, C_COG_IN0, to_q412(0.8));
        wb_write(uart_rx, C_COG_IN1, to_q412(0.1)); -- hafif sag sapma
        wb_write(uart_rx, C_COG_IN2, to_q412(0.0));
        wb_write(uart_rx, C_COG_IN3, to_q412(0.0));

        -- START
        wb_write(uart_rx, C_COG_CTRL, x"0001");

        wait for 2 us; -- MAC hesaplamasi icin bekle

        ------------------------------------------------------------------
        -- EMOTION_CORE: stres/odul girisi + noron agirliklari
        -- calm noronu = -stres + odul, stress noronu = +stres, excite = +odul
        ------------------------------------------------------------------
        wb_write(uart_rx, C_EMO_W_BASE + 0, to_q412(-1.0)); -- calm  <- -stress
        wb_write(uart_rx, C_EMO_W_BASE + 1, to_q412( 1.0)); -- calm  <- +reward
        wb_write(uart_rx, C_EMO_W_BASE + 2, to_q412( 1.0)); -- stress<- +stress
        wb_write(uart_rx, C_EMO_W_BASE + 3, to_q412( 0.0)); -- stress<- reward
        wb_write(uart_rx, C_EMO_W_BASE + 4, to_q412( 0.0)); -- excite<- stress
        wb_write(uart_rx, C_EMO_W_BASE + 5, to_q412( 1.0)); -- excite<- +reward

        wb_write(uart_rx, C_EMO_STRESS_I, to_q412(0.2));
        wb_write(uart_rx, C_EMO_REWARD_I, to_q412(0.6));

        wb_write(uart_rx, C_EMO_CTRL, x"0001"); -- start

        wait for 2 us;

        -- ikinci tur: mood'un onceki degerle harmanlandigini (atalet) gozlemle
        wb_write(uart_rx, C_EMO_STRESS_I, to_q412(0.0));
        wb_write(uart_rx, C_EMO_REWARD_I, to_q412(0.0));
        wb_write(uart_rx, C_EMO_CTRL, x"0001");

        wait for 2 us;

        report "COGNITION OUT0 (ileri)= " & integer'image(to_integer(probe_cog_out(0)));
        report "COGNITION OUT1 (don)  = " & integer'image(to_integer(probe_cog_out(1)));
        report "EMOTION CALM          = " & integer'image(to_integer(probe_emo_mood(0)));
        report "EMOTION STRESS        = " & integer'image(to_integer(probe_emo_mood(1)));
        report "EMOTION EXCITE        = " & integer'image(to_integer(probe_emo_mood(2)));
        report "MOTOR SPEED_L         = " & integer'image(to_integer(probe_speed_l));
        report "MOTOR SPEED_R         = " & integer'image(to_integer(probe_speed_r));

        wait for 5 us;
        report "TESTBENCH TAMAMLANDI" severity note;
        std.env.stop;
    end process;

end architecture sim;
